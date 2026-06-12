using Care4U.Api.Data;
using Care4U.Api.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace Care4U.Api.Controllers;

public class CreateDoctorScheduleRequest
{
    public int DoctorId { get; set; }
    public string ScheduleDate { get; set; } = "";
    public string StartTime { get; set; } = "";
    public string EndTime { get; set; } = "";
    public int? SlotDuration { get; set; }
    public int? MaxPatients { get; set; }
    public bool? IsAvailable { get; set; }
    public string? Note { get; set; }
}

public class UpdateDoctorScheduleRequest
{
    public string? ScheduleDate { get; set; }
    public string? StartTime { get; set; }
    public string? EndTime { get; set; }
    public int? SlotDuration { get; set; }
    public int? MaxPatients { get; set; }
    public bool? IsAvailable { get; set; }
    public string? Note { get; set; }
}

[ApiController]
[Route("api/[controller]")]
public class DoctorSchedulesController : ControllerBase
{
    private readonly Care4UDbContext _context;

    public DoctorSchedulesController(Care4UDbContext context)
    {
        _context = context;
    }

    private static object ToScheduleDto(DoctorSchedule x)
    {
        return new
        {
            x.Id,
            x.DoctorId,
            DoctorName = x.Doctor != null ? x.Doctor.FullName : null,
            DoctorTitle = x.Doctor != null ? x.Doctor.Title : null,
            ScheduleDate = x.ScheduleDate.ToString("yyyy-MM-dd"),
            StartTime = x.StartTime.ToString("HH:mm"),
            EndTime = x.EndTime.ToString("HH:mm"),
            x.SlotDuration,
            x.MaxPatients,
            x.BookedCount,
            x.IsAvailable,
            AvailableSlots = x.MaxPatients - x.BookedCount,
            x.Note,
            x.CreatedAt,
            x.UpdatedAt
        };
    }

    // GET: /api/DoctorSchedules
    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        var schedules = await _context.DoctorSchedules
            .AsNoTracking()
            .Include(x => x.Doctor)
            .OrderByDescending(x => x.ScheduleDate)
            .ThenBy(x => x.StartTime)
            .ToListAsync();

        return Ok(schedules.Select(ToScheduleDto).ToList());
    }

    // GET: /api/DoctorSchedules/1
    [HttpGet("{id:int}")]
    public async Task<IActionResult> GetById(int id)
    {
        var schedule = await _context.DoctorSchedules
            .AsNoTracking()
            .Include(x => x.Doctor)
            .FirstOrDefaultAsync(x => x.Id == id);

        if (schedule == null)
        {
            return NotFound(new { message = "Không tìm thấy lịch làm việc" });
        }

        return Ok(ToScheduleDto(schedule));
    }

    // GET: /api/DoctorSchedules/doctor/1
    [HttpGet("doctor/{doctorId:int}")]
    public async Task<IActionResult> GetByDoctor(int doctorId)
    {
        var doctorExists = await _context.Doctors
            .AsNoTracking()
            .AnyAsync(x => x.Id == doctorId);

        if (!doctorExists)
        {
            return NotFound(new { message = "Không tìm thấy bác sĩ" });
        }

        var schedules = await _context.DoctorSchedules
            .AsNoTracking()
            .Include(x => x.Doctor)
            .Where(x => x.DoctorId == doctorId)
            .OrderBy(x => x.ScheduleDate)
            .ThenBy(x => x.StartTime)
            .ToListAsync();

        return Ok(schedules.Select(ToScheduleDto).ToList());
    }

    // GET: /api/DoctorSchedules/available?doctorId=1
    [HttpGet("available")]
    public async Task<IActionResult> GetAvailableSchedules([FromQuery] int doctorId)
    {
        return await GetAvailableSchedulesByDoctor(doctorId);
    }

    // GET: /api/DoctorSchedules/available/doctor/1
    [HttpGet("available/doctor/{doctorId:int}")]
    public async Task<IActionResult> GetAvailableSchedulesByDoctor(int doctorId)
    {
        if (doctorId <= 0)
        {
            return BadRequest(new { message = "Thiếu doctorId" });
        }

        var doctorExists = await _context.Doctors
            .AsNoTracking()
            .AnyAsync(x => x.Id == doctorId);

        if (!doctorExists)
        {
            return NotFound(new { message = "Không tìm thấy bác sĩ" });
        }

        var today = DateOnly.FromDateTime(DateTime.Now);

        var schedules = await _context.DoctorSchedules
            .AsNoTracking()
            .Include(x => x.Doctor)
            .Where(x =>
                x.DoctorId == doctorId &&
                x.ScheduleDate >= today &&
                x.IsAvailable &&
                x.BookedCount < x.MaxPatients
            )
            .OrderBy(x => x.ScheduleDate)
            .ThenBy(x => x.StartTime)
            .ToListAsync();

        return Ok(schedules.Select(ToScheduleDto).ToList());
    }

    // POST: /api/DoctorSchedules
    [HttpPost]
    public async Task<IActionResult> Create(CreateDoctorScheduleRequest request)
    {
        if (!DateOnly.TryParse(request.ScheduleDate, out var scheduleDate))
        {
            return BadRequest(new { message = "Ngày làm việc không hợp lệ. Định dạng đúng: yyyy-MM-dd" });
        }

        if (!TimeOnly.TryParse(request.StartTime, out var startTime) ||
            !TimeOnly.TryParse(request.EndTime, out var endTime))
        {
            return BadRequest(new { message = "Giờ làm việc không hợp lệ. Ví dụ đúng: 08:00" });
        }

        if (startTime >= endTime)
        {
            return BadRequest(new { message = "Giờ bắt đầu phải nhỏ hơn giờ kết thúc" });
        }

        var doctorExists = await _context.Doctors.AnyAsync(x => x.Id == request.DoctorId);
        if (!doctorExists)
        {
            return BadRequest(new { message = "Không tìm thấy bác sĩ" });
        }

        var duplicated = await _context.DoctorSchedules.AnyAsync(x =>
            x.DoctorId == request.DoctorId &&
            x.ScheduleDate == scheduleDate &&
            x.StartTime == startTime);

        if (duplicated)
        {
            return BadRequest(new { message = "Bác sĩ đã có lịch tại thời điểm này" });
        }

        var now = DateTime.UtcNow;

        var schedule = new DoctorSchedule
        {
            DoctorId = request.DoctorId,
            ScheduleDate = scheduleDate,
            StartTime = startTime,
            EndTime = endTime,
            SlotDuration = request.SlotDuration ?? 30,
            MaxPatients = request.MaxPatients ?? 1,
            BookedCount = 0,
            IsAvailable = request.IsAvailable ?? true,
            Note = request.Note,
            CreatedAt = now,
            UpdatedAt = now
        };

        _context.DoctorSchedules.Add(schedule);
        await _context.SaveChangesAsync();

        var created = await _context.DoctorSchedules
            .AsNoTracking()
            .Include(x => x.Doctor)
            .FirstAsync(x => x.Id == schedule.Id);

        return Ok(new
        {
            message = "Tạo lịch làm việc thành công",
            data = ToScheduleDto(created)
        });
    }

    // PUT: /api/DoctorSchedules/1
    [HttpPut("{id:int}")]
    public async Task<IActionResult> Update(int id, UpdateDoctorScheduleRequest request)
    {
        var schedule = await _context.DoctorSchedules.FirstOrDefaultAsync(x => x.Id == id);

        if (schedule == null)
        {
            return NotFound(new { message = "Không tìm thấy lịch làm việc" });
        }

        if (!string.IsNullOrWhiteSpace(request.ScheduleDate))
        {
            if (!DateOnly.TryParse(request.ScheduleDate, out var scheduleDate))
            {
                return BadRequest(new { message = "Ngày làm việc không hợp lệ. Định dạng đúng: yyyy-MM-dd" });
            }

            schedule.ScheduleDate = scheduleDate;
        }

        if (!string.IsNullOrWhiteSpace(request.StartTime))
        {
            if (!TimeOnly.TryParse(request.StartTime, out var startTime))
            {
                return BadRequest(new { message = "Giờ bắt đầu không hợp lệ. Ví dụ đúng: 08:00" });
            }

            schedule.StartTime = startTime;
        }

        if (!string.IsNullOrWhiteSpace(request.EndTime))
        {
            if (!TimeOnly.TryParse(request.EndTime, out var endTime))
            {
                return BadRequest(new { message = "Giờ kết thúc không hợp lệ. Ví dụ đúng: 17:00" });
            }

            schedule.EndTime = endTime;
        }

        if (schedule.StartTime >= schedule.EndTime)
        {
            return BadRequest(new { message = "Giờ bắt đầu phải nhỏ hơn giờ kết thúc" });
        }

        if (request.SlotDuration.HasValue)
        {
            schedule.SlotDuration = request.SlotDuration.Value;
        }

        if (request.MaxPatients.HasValue)
        {
            if (request.MaxPatients.Value < schedule.BookedCount)
            {
                return BadRequest(new { message = "Số bệnh nhân tối đa không được nhỏ hơn số đã đặt" });
            }

            schedule.MaxPatients = request.MaxPatients.Value;
        }

        if (request.IsAvailable.HasValue)
        {
            schedule.IsAvailable = request.IsAvailable.Value;
        }

        if (request.Note != null)
        {
            schedule.Note = request.Note;
        }

        schedule.UpdatedAt = DateTime.UtcNow;

        await _context.SaveChangesAsync();

        var updated = await _context.DoctorSchedules
            .AsNoTracking()
            .Include(x => x.Doctor)
            .FirstAsync(x => x.Id == schedule.Id);

        return Ok(new
        {
            message = "Cập nhật lịch làm việc thành công",
            data = ToScheduleDto(updated)
        });
    }

    // DELETE: /api/DoctorSchedules/1
    [HttpDelete("{id:int}")]
    public async Task<IActionResult> Delete(int id)
    {
        var schedule = await _context.DoctorSchedules.FirstOrDefaultAsync(x => x.Id == id);

        if (schedule == null)
        {
            return NotFound(new { message = "Không tìm thấy lịch làm việc" });
        }

        if (schedule.BookedCount > 0)
        {
            return BadRequest(new { message = "Không thể xóa lịch đã có bệnh nhân đặt" });
        }

        var hasAppointment = await _context.Appointments.AnyAsync(x => x.ScheduleId == id);
        if (hasAppointment)
        {
            return BadRequest(new { message = "Không thể xóa lịch đã phát sinh lịch hẹn" });
        }

        _context.DoctorSchedules.Remove(schedule);
        await _context.SaveChangesAsync();

        return Ok(new { message = "Xóa lịch làm việc thành công" });
    }
}
