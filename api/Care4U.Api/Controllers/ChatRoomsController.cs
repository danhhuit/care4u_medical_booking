using Care4U.Api.Data;
using Care4U.Api.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace Care4U.Api.Controllers;

public class CreateChatRoomRequest
{
    public int PatientId { get; set; }
    public int DoctorId { get; set; }
    public Guid? AppointmentId { get; set; }
}

[ApiController]
[Route("api/[controller]")]
public class ChatRoomsController : ControllerBase
{
    private readonly Care4UDbContext _context;

    public ChatRoomsController(Care4UDbContext context)
    {
        _context = context;
    }

    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        var data = await _context.ChatRooms
            .AsNoTracking()
            .Include(x => x.Patient)
            .Include(x => x.Doctor)
            .Include(x => x.Appointment)
            .Include(x => x.ChatMessages)
            .OrderByDescending(x => x.LastMessageAt ?? x.UpdatedAt)
            .Select(x => new
            {
                x.Id,
                x.PatientId,
                PatientName = x.Patient.FullName,
                PatientUserId = x.Patient.UserId,
                x.DoctorId,
                DoctorName = x.Doctor.FullName,
                DoctorTitle = x.Doctor.Title,
                DoctorUserId = x.Doctor.UserId,
                x.AppointmentId,
                AppointmentNo = x.Appointment != null ? x.Appointment.AppointmentNo : null,
                x.Status,
                x.LastMessageAt,
                x.CreatedAt,
                x.UpdatedAt,
                LastMessage = x.ChatMessages
                    .Where(m => !m.IsDeleted)
                    .OrderByDescending(m => m.CreatedAt)
                    .Select(m => new
                    {
                        m.Id,
                        m.Content,
                        m.MessageType,
                        m.SenderId,
                        m.IsRead,
                        m.CreatedAt
                    })
                    .FirstOrDefault(),
                UnreadCount = x.ChatMessages.Count(m => !m.IsDeleted && !m.IsRead)
            })
            .ToListAsync();

        return Ok(data);
    }

    [HttpGet("{id:guid}")]
    public async Task<IActionResult> GetById(Guid id)
    {
        var item = await _context.ChatRooms
            .AsNoTracking()
            .Include(x => x.Patient)
            .Include(x => x.Doctor)
            .Include(x => x.Appointment)
            .Where(x => x.Id == id)
            .Select(x => new
            {
                x.Id,
                x.PatientId,
                PatientName = x.Patient.FullName,
                PatientUserId = x.Patient.UserId,
                x.DoctorId,
                DoctorName = x.Doctor.FullName,
                DoctorTitle = x.Doctor.Title,
                DoctorUserId = x.Doctor.UserId,
                x.AppointmentId,
                AppointmentNo = x.Appointment != null ? x.Appointment.AppointmentNo : null,
                x.Status,
                x.LastMessageAt,
                x.CreatedAt,
                x.UpdatedAt
            })
            .FirstOrDefaultAsync();

        if (item == null)
        {
            return NotFound(new { message = "Không tìm thấy phòng chat" });
        }

        return Ok(item);
    }

    [HttpGet("doctor/{doctorId:int}")]
    public async Task<IActionResult> GetByDoctor(int doctorId)
    {
        var doctorUserId = await _context.Doctors
            .Where(x => x.Id == doctorId)
            .Select(x => x.UserId)
            .FirstOrDefaultAsync();

        if (doctorUserId == Guid.Empty)
        {
            return NotFound(new { message = "Không tìm thấy bác sĩ" });
        }

        var data = await _context.ChatRooms
            .AsNoTracking()
            .Include(x => x.Patient)
            .Include(x => x.Doctor)
            .Include(x => x.Appointment)
            .Include(x => x.ChatMessages)
            .Where(x => x.DoctorId == doctorId)
            .OrderByDescending(x => x.LastMessageAt ?? x.UpdatedAt)
            .Select(x => new
            {
                x.Id,
                x.PatientId,
                PatientName = x.Patient.FullName,
                PatientUserId = x.Patient.UserId,
                x.DoctorId,
                DoctorName = x.Doctor.FullName,
                DoctorTitle = x.Doctor.Title,
                DoctorUserId = x.Doctor.UserId,
                x.AppointmentId,
                AppointmentNo = x.Appointment != null ? x.Appointment.AppointmentNo : null,
                x.Status,
                x.LastMessageAt,
                x.CreatedAt,
                x.UpdatedAt,
                LastMessage = x.ChatMessages
                    .Where(m => !m.IsDeleted)
                    .OrderByDescending(m => m.CreatedAt)
                    .Select(m => new
                    {
                        m.Id,
                        m.Content,
                        m.MessageType,
                        m.SenderId,
                        m.IsRead,
                        m.CreatedAt
                    })
                    .FirstOrDefault(),
                UnreadCount = x.ChatMessages.Count(m =>
                    !m.IsDeleted &&
                    !m.IsRead &&
                    m.SenderId != doctorUserId)
            })
            .ToListAsync();

        return Ok(data);
    }

    [HttpGet("patient/{patientId:int}")]
    public async Task<IActionResult> GetByPatient(int patientId)
    {
        var patientUserId = await _context.Patients
            .Where(x => x.Id == patientId)
            .Select(x => x.UserId)
            .FirstOrDefaultAsync();

        if (patientUserId == Guid.Empty)
        {
            return NotFound(new { message = "Không tìm thấy bệnh nhân" });
        }

        var data = await _context.ChatRooms
            .AsNoTracking()
            .Include(x => x.Patient)
            .Include(x => x.Doctor)
            .Include(x => x.Appointment)
            .Include(x => x.ChatMessages)
            .Where(x => x.PatientId == patientId)
            .OrderByDescending(x => x.LastMessageAt ?? x.UpdatedAt)
            .Select(x => new
            {
                x.Id,
                x.PatientId,
                PatientName = x.Patient.FullName,
                PatientUserId = x.Patient.UserId,
                x.DoctorId,
                DoctorName = x.Doctor.FullName,
                DoctorTitle = x.Doctor.Title,
                DoctorUserId = x.Doctor.UserId,
                x.AppointmentId,
                AppointmentNo = x.Appointment != null ? x.Appointment.AppointmentNo : null,
                x.Status,
                x.LastMessageAt,
                x.CreatedAt,
                x.UpdatedAt,
                LastMessage = x.ChatMessages
                    .Where(m => !m.IsDeleted)
                    .OrderByDescending(m => m.CreatedAt)
                    .Select(m => new
                    {
                        m.Id,
                        m.Content,
                        m.MessageType,
                        m.SenderId,
                        m.IsRead,
                        m.CreatedAt
                    })
                    .FirstOrDefault(),
                UnreadCount = x.ChatMessages.Count(m =>
                    !m.IsDeleted &&
                    !m.IsRead &&
                    m.SenderId != patientUserId)
            })
            .ToListAsync();

        return Ok(data);
    }

    [HttpPost]
    public async Task<IActionResult> CreateOrGet(CreateChatRoomRequest request)
    {
        if (request.PatientId <= 0 || request.DoctorId <= 0)
        {
            return BadRequest(new { message = "Thiếu mã bệnh nhân hoặc bác sĩ" });
        }

        var patientExists = await _context.Patients.AnyAsync(x => x.Id == request.PatientId);
        if (!patientExists)
        {
            return BadRequest(new { message = "Không tìm thấy bệnh nhân" });
        }

        var doctorExists = await _context.Doctors.AnyAsync(x => x.Id == request.DoctorId);
        if (!doctorExists)
        {
            return BadRequest(new { message = "Không tìm thấy bác sĩ" });
        }

        if (request.AppointmentId.HasValue)
        {
            var appointmentExists = await _context.Appointments.AnyAsync(x =>
                x.Id == request.AppointmentId.Value &&
                x.PatientId == request.PatientId &&
                x.DoctorId == request.DoctorId);

            if (!appointmentExists)
            {
                return BadRequest(new { message = "Lịch hẹn không khớp với bệnh nhân hoặc bác sĩ" });
            }
        }

        var room = await _context.ChatRooms.FirstOrDefaultAsync(x =>
            x.PatientId == request.PatientId &&
            x.DoctorId == request.DoctorId &&
            x.AppointmentId == request.AppointmentId);

        if (room == null)
        {
            var now = DateTime.UtcNow;
            room = new ChatRoom
            {
                Id = Guid.NewGuid(),
                PatientId = request.PatientId,
                DoctorId = request.DoctorId,
                AppointmentId = request.AppointmentId,
                Status = "active",
                CreatedAt = now,
                UpdatedAt = now,
                LastMessageAt = null
            };

            _context.ChatRooms.Add(room);
            await _context.SaveChangesAsync();
        }

        var result = await _context.ChatRooms
            .AsNoTracking()
            .Include(x => x.Patient)
            .Include(x => x.Doctor)
            .Include(x => x.Appointment)
            .Where(x => x.Id == room.Id)
            .Select(x => new
            {
                message = "Tạo hoặc lấy phòng chat thành công",
                x.Id,
                x.PatientId,
                PatientName = x.Patient.FullName,
                PatientUserId = x.Patient.UserId,
                x.DoctorId,
                DoctorName = x.Doctor.FullName,
                DoctorTitle = x.Doctor.Title,
                DoctorUserId = x.Doctor.UserId,
                x.AppointmentId,
                AppointmentNo = x.Appointment != null ? x.Appointment.AppointmentNo : null,
                x.Status,
                x.LastMessageAt,
                x.CreatedAt,
                x.UpdatedAt,
                UnreadCount = 0
            })
            .FirstAsync();

        return Ok(result);
    }
}
