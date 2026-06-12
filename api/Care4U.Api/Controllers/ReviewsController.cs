using Care4U.Api.Data;
using Care4U.Api.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace Care4U.Api.Controllers;

public class CreateReviewRequest
{
    public int PatientId { get; set; }
    public int DoctorId { get; set; }
    public Guid AppointmentId { get; set; }
    public int Rating { get; set; }
    public string? Comment { get; set; }
    public bool IsAnonymous { get; set; }
}

public class UpdateReviewRequest
{
    public int? Rating { get; set; }
    public string? Comment { get; set; }
    public bool? IsAnonymous { get; set; }
    public bool? IsVisible { get; set; }
}

public class ReplyReviewRequest
{
    public string? Reply { get; set; }
}

[ApiController]
[Route("api/[controller]")]
public class ReviewsController : ControllerBase
{
    private readonly Care4UDbContext _context;

    public ReviewsController(Care4UDbContext context)
    {
        _context = context;
    }

    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        var data = await _context.Reviews
            .OrderByDescending(x => x.CreatedAt)
            .Select(x => new
            {
                x.Id,
                x.PatientId,
                PatientName = x.IsAnonymous ? "Ẩn danh" : x.Patient.FullName,
                x.DoctorId,
                DoctorName = x.Doctor.FullName,
                DoctorTitle = x.Doctor.Title,
                x.AppointmentId,
                x.Rating,
                x.Comment,
                x.IsAnonymous,
                x.IsVisible,
                x.Reply,
                x.RepliedAt,
                x.CreatedAt,
                x.UpdatedAt
            })
            .ToListAsync();

        return Ok(data);
    }

    [HttpGet("{id:int}")]
    public async Task<IActionResult> GetById(int id)
    {
        var item = await _context.Reviews
            .Where(x => x.Id == id)
            .Select(x => new
            {
                x.Id,
                x.PatientId,
                PatientName = x.IsAnonymous ? "Ẩn danh" : x.Patient.FullName,
                x.DoctorId,
                DoctorName = x.Doctor.FullName,
                DoctorTitle = x.Doctor.Title,
                x.AppointmentId,
                x.Rating,
                x.Comment,
                x.IsAnonymous,
                x.IsVisible,
                x.Reply,
                x.RepliedAt,
                x.CreatedAt,
                x.UpdatedAt
            })
            .FirstOrDefaultAsync();

        if (item == null)
        {
            return NotFound(new { message = "Không tìm thấy đánh giá" });
        }

        return Ok(item);
    }

    [HttpGet("doctor/{doctorId:int}")]
    public async Task<IActionResult> GetByDoctor(int doctorId)
    {
        var data = await _context.Reviews
            .Where(x => x.DoctorId == doctorId && x.IsVisible)
            .OrderByDescending(x => x.CreatedAt)
            .Select(x => new
            {
                x.Id,
                x.PatientId,
                PatientName = x.IsAnonymous ? "Ẩn danh" : x.Patient.FullName,
                x.DoctorId,
                DoctorName = x.Doctor.FullName,
                DoctorTitle = x.Doctor.Title,
                x.AppointmentId,
                x.Rating,
                x.Comment,
                x.IsAnonymous,
                x.IsVisible,
                x.Reply,
                x.RepliedAt,
                x.CreatedAt,
                x.UpdatedAt
            })
            .ToListAsync();

        return Ok(data);
    }

    [HttpGet("patient/{patientId:int}")]
    public async Task<IActionResult> GetByPatient(int patientId)
    {
        var data = await _context.Reviews
            .Where(x => x.PatientId == patientId)
            .OrderByDescending(x => x.CreatedAt)
            .Select(x => new
            {
                x.Id,
                x.PatientId,
                PatientName = x.IsAnonymous ? "Ẩn danh" : x.Patient.FullName,
                x.DoctorId,
                DoctorName = x.Doctor.FullName,
                DoctorTitle = x.Doctor.Title,
                x.AppointmentId,
                x.Rating,
                x.Comment,
                x.IsAnonymous,
                x.IsVisible,
                x.Reply,
                x.RepliedAt,
                x.CreatedAt,
                x.UpdatedAt
            })
            .ToListAsync();

        return Ok(data);
    }

    [HttpPost]
    public async Task<IActionResult> Create(CreateReviewRequest request)
    {
        if (request.Rating < 1 || request.Rating > 5)
        {
            return BadRequest(new { message = "Số sao phải từ 1 đến 5" });
        }

        var appointment = await _context.Appointments
            .FirstOrDefaultAsync(x =>
                x.Id == request.AppointmentId &&
                x.PatientId == request.PatientId &&
                x.DoctorId == request.DoctorId);

        if (appointment == null)
        {
            return BadRequest(new { message = "Không tìm thấy lịch hẹn phù hợp để đánh giá" });
        }

        var existed = await _context.Reviews
            .AnyAsync(x => x.AppointmentId == request.AppointmentId);

        if (existed)
        {
            return BadRequest(new { message = "Lịch hẹn này đã được đánh giá trước đó" });
        }

        var now = DateTime.UtcNow;

        var review = new Review
        {
            PatientId = request.PatientId,
            DoctorId = request.DoctorId,
            AppointmentId = request.AppointmentId,
            Rating = (short)request.Rating,
            Comment = request.Comment,
            IsAnonymous = request.IsAnonymous,
            IsVisible = true,
            CreatedAt = now,
            UpdatedAt = now
        };

        _context.Reviews.Add(review);
        await _context.SaveChangesAsync();

        await UpdateDoctorRating(request.DoctorId);

        return Ok(new
        {
            message = "Gửi đánh giá thành công",
            review.Id,
            review.PatientId,
            review.DoctorId,
            review.AppointmentId,
            review.Rating,
            review.Comment,
            review.IsAnonymous,
            review.IsVisible,
            review.CreatedAt
        });
    }

    [HttpPut("{id:int}")]
    public async Task<IActionResult> Update(int id, UpdateReviewRequest request)
    {
        var review = await _context.Reviews.FirstOrDefaultAsync(x => x.Id == id);

        if (review == null)
        {
            return NotFound(new { message = "Không tìm thấy đánh giá" });
        }

        if (request.Rating.HasValue)
        {
            if (request.Rating.Value < 1 || request.Rating.Value > 5)
            {
                return BadRequest(new { message = "Số sao phải từ 1 đến 5" });
            }

            review.Rating = (short)request.Rating.Value;
        }

        if (request.Comment != null)
        {
            review.Comment = request.Comment;
        }

        if (request.IsAnonymous.HasValue)
        {
            review.IsAnonymous = request.IsAnonymous.Value;
        }

        if (request.IsVisible.HasValue)
        {
            review.IsVisible = request.IsVisible.Value;
        }

        review.UpdatedAt = DateTime.UtcNow;

        await _context.SaveChangesAsync();
        await UpdateDoctorRating(review.DoctorId);

        return Ok(new
        {
            message = "Cập nhật đánh giá thành công",
            review.Id,
            review.Rating,
            review.Comment,
            review.IsAnonymous,
            review.IsVisible,
            review.UpdatedAt
        });
    }

    [HttpPut("{id:int}/reply")]
    public async Task<IActionResult> Reply(int id, ReplyReviewRequest request)
    {
        var review = await _context.Reviews.FirstOrDefaultAsync(x => x.Id == id);

        if (review == null)
        {
            return NotFound(new { message = "Không tìm thấy đánh giá" });
        }

        review.Reply = request.Reply;
        review.RepliedAt = DateTime.UtcNow;
        review.UpdatedAt = DateTime.UtcNow;

        await _context.SaveChangesAsync();

        return Ok(new
        {
            message = "Phản hồi đánh giá thành công",
            review.Id,
            review.Reply,
            review.RepliedAt
        });
    }

    [HttpDelete("{id:int}")]
    public async Task<IActionResult> Delete(int id)
    {
        var review = await _context.Reviews.FirstOrDefaultAsync(x => x.Id == id);

        if (review == null)
        {
            return NotFound(new { message = "Không tìm thấy đánh giá" });
        }

        var doctorId = review.DoctorId;

        _context.Reviews.Remove(review);
        await _context.SaveChangesAsync();

        await UpdateDoctorRating(doctorId);

        return Ok(new { message = "Xóa đánh giá thành công" });
    }

    private async Task UpdateDoctorRating(int doctorId)
    {
        var visibleReviews = _context.Reviews
            .Where(x => x.DoctorId == doctorId && x.IsVisible);

        var count = await visibleReviews.CountAsync();

        var doctor = await _context.Doctors.FirstOrDefaultAsync(x => x.Id == doctorId);
        if (doctor == null)
        {
            return;
        }

        if (count == 0)
        {
            doctor.Rating = 0;
            doctor.TotalReviews = 0;
        }
        else
        {
            var avg = await visibleReviews.AverageAsync(x => (decimal)x.Rating);
            doctor.Rating = Math.Round(avg, 2);
            doctor.TotalReviews = count;
        }

        doctor.UpdatedAt = DateTime.UtcNow;
        await _context.SaveChangesAsync();
    }
}