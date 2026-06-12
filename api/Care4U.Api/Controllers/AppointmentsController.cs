using Care4U.Api.Data;
using Care4U.Api.Models;
using Care4U.Api.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace Care4U.Api.Controllers;
public class CreateAppointmentRequest
{
    public int PatientId { get; set; }
    public int DoctorId { get; set; }
    public int? ScheduleId { get; set; }
    public string? Reason { get; set; }
    public string? Notes { get; set; }
}
public class CancelAppointmentRequest
{
    public string? CancelReason { get; set; }
}

public class RescheduleAppointmentRequest
{
    public int DoctorId { get; set; }
    public int ScheduleId { get; set; }
}

[ApiController]
[Route("api/[controller]")]
public class AppointmentsController : ControllerBase
{
    private readonly Care4UDbContext _context;
    private readonly FcmNotificationService _fcm;

    public AppointmentsController(Care4UDbContext context, FcmNotificationService fcm)
    {
        _context = context;
        _fcm = fcm;
    }

    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        var data = await _context.Appointments
            .Include(x => x.Patient)
            .Include(x => x.Doctor)
                .ThenInclude(d => d.Specialty)
            .Include(x => x.Doctor)
                .ThenInclude(d => d.HealthCenter)
            .OrderByDescending(x => x.CreatedAt)
            .Select(x => new
            {
                x.Id,
                x.PatientId,
                PatientName = x.Patient.FullName,
                x.DoctorId,
                DoctorName = x.Doctor.FullName,
                DoctorTitle = x.Doctor.Title,
                SpecialtyName = x.Doctor.Specialty.Name,
                HealthCenterName = x.Doctor.HealthCenter != null ? x.Doctor.HealthCenter.Name : null,
                x.ScheduleId,
                x.AppointmentNo,
                x.Status,
                x.Reason,
                x.Notes,
                x.CancelReason,
                x.CancelledAt,
                x.ConfirmedAt,
                x.CompletedAt,
                x.CreatedAt
            })
            .ToListAsync();

        return Ok(data);
    }
    [HttpPut("{id:guid}/cancel")]
    public async Task<IActionResult> Cancel(Guid id, CancelAppointmentRequest request)
    {
        var appointment = await _context.Appointments.FirstOrDefaultAsync(x => x.Id == id);

        if (appointment == null)
        {
            return NotFound(new { message = "Không tìm thấy lịch hẹn" });
        }

        if (appointment.Status == "cancelled")
        {
            return BadRequest(new { message = "Lịch hẹn này đã được hủy trước đó" });
        }

        if (appointment.Status == "completed")
        {
            return BadRequest(new { message = "Không thể hủy lịch hẹn đã hoàn thành" });
        }

        appointment.Status = "cancelled";
        appointment.CancelReason = string.IsNullOrWhiteSpace(request.CancelReason)
            ? "Người dùng hủy lịch"
            : request.CancelReason;
        appointment.CancelledAt = DateTime.UtcNow;

        await _context.SaveChangesAsync();
        var patient = await _context.Patients
            .FirstOrDefaultAsync(p => p.Id == appointment.PatientId);

        if (patient != null)
        {
            await _fcm.SendToUserAsync(
                patient.UserId,
                "Hủy lịch thành công",
                $"Lịch hẹn {appointment.AppointmentNo} đã được hủy.",
                new Dictionary<string, string>
                {
                    ["type"] = "appointment_cancelled",
                    ["appointmentId"] = appointment.Id.ToString(),
                    ["appointmentNo"] = appointment.AppointmentNo
                }
            );
        }

        return Ok(new
        {
            message = "Hủy lịch hẹn thành công",
            appointment.Id,
            appointment.AppointmentNo,
            appointment.Status,
            appointment.CancelReason,
            appointment.CancelledAt
        });
    }
    [HttpGet("{id:guid}")]
    public async Task<IActionResult> GetById(Guid id)
    {
        var item = await _context.Appointments
            .Include(x => x.Patient)
            .Include(x => x.Doctor)
                .ThenInclude(d => d.Specialty)
            .Include(x => x.Doctor)
                .ThenInclude(d => d.HealthCenter)
            .Where(x => x.Id == id)
            .Select(x => new
            {
                x.Id,
                x.PatientId,
                PatientName = x.Patient.FullName,
                x.DoctorId,
                DoctorName = x.Doctor.FullName,
                DoctorTitle = x.Doctor.Title,
                SpecialtyName = x.Doctor.Specialty.Name,
                HealthCenterName = x.Doctor.HealthCenter != null ? x.Doctor.HealthCenter.Name : null,
                x.ScheduleId,
                x.AppointmentNo,
                x.Status,
                x.Reason,
                x.Notes,
                x.CancelReason,
                x.CancelledAt,
                x.ConfirmedAt,
                x.CompletedAt,
                x.CreatedAt
            })
            .FirstOrDefaultAsync();

        if (item == null)
        {
            return NotFound(new { message = "Không tìm thấy lịch hẹn" });
        }

        return Ok(item);
    }

    [HttpGet("patient/{patientId:int}")]
    public async Task<IActionResult> GetByPatient(int patientId)
    {
        var data = await _context.Appointments
            .Include(x => x.Patient)
            .Include(x => x.Doctor)
                .ThenInclude(d => d.Specialty)
            .Include(x => x.Doctor)
                .ThenInclude(d => d.HealthCenter)
            .Where(x => x.PatientId == patientId)
            .OrderByDescending(x => x.CreatedAt)
            .Select(x => new
            {
                x.Id,
                x.PatientId,
                PatientName = x.Patient.FullName,
                x.DoctorId,
                DoctorName = x.Doctor.FullName,
                DoctorTitle = x.Doctor.Title,
                SpecialtyName = x.Doctor.Specialty.Name,
                HealthCenterName = x.Doctor.HealthCenter != null ? x.Doctor.HealthCenter.Name : null,
                x.ScheduleId,
                x.AppointmentNo,
                x.Status,
                x.Reason,
                x.Notes,
                x.CancelReason,
                x.CancelledAt,
                x.ConfirmedAt,
                x.CompletedAt,
                x.CreatedAt
            })
            .ToListAsync();

        return Ok(data);
    }

    [HttpPost]
    public async Task<IActionResult> Create(CreateAppointmentRequest request)
    {
        var patientExists = await _context.Patients.AnyAsync(x => x.Id == request.PatientId);
        if (!patientExists)
        {
            return BadRequest(new { message = "Bệnh nhân không tồn tại" });
        }

        var doctorExists = await _context.Doctors.AnyAsync(x => x.Id == request.DoctorId);
        if (!doctorExists)
        {
            return BadRequest(new { message = "Bác sĩ không tồn tại" });
        }

        var schedule = request.ScheduleId.HasValue && request.ScheduleId.Value > 0
            ? await _context.DoctorSchedules
                .FirstOrDefaultAsync(x => x.Id == request.ScheduleId.Value && x.DoctorId == request.DoctorId)
            : await _context.DoctorSchedules
                .Where(x => x.DoctorId == request.DoctorId)
                .OrderBy(x => x.Id)
                .FirstOrDefaultAsync();

        if (schedule == null)
        {
            return BadRequest(new { message = "Không tìm thấy lịch khám phù hợp của bác sĩ" });
        }

        var now = DateTime.UtcNow;

        var appointment = new Appointment
        {
            Id = Guid.NewGuid(),
            PatientId = request.PatientId,
            DoctorId = request.DoctorId,
            ScheduleId = schedule.Id,
            AppointmentNo = $"APT-{now:yyyyMMdd-HHmmss}",
            Status = "pending",
            Reason = request.Reason,
            Notes = request.Notes,
            CreatedAt = now
        };

        _context.Appointments.Add(appointment);
        await _context.SaveChangesAsync();

        var patient = await _context.Patients
            .FirstOrDefaultAsync(p => p.Id == appointment.PatientId);

        if (patient != null)
        {
            await _fcm.SendToUserAsync(
                patient.UserId,
                "Đặt lịch thành công",
                $"Bạn đã đặt lịch khám thành công. Mã lịch: {appointment.AppointmentNo}",
                new Dictionary<string, string>
                {
                    ["type"] = "appointment_created",
                    ["appointmentId"] = appointment.Id.ToString(),
                    ["appointmentNo"] = appointment.AppointmentNo
                }
            );
        }
        return Ok(new
        {
            message = "Đặt lịch thành công",
            appointment.Id,
            appointment.AppointmentNo,
            appointment.PatientId,
            appointment.DoctorId,
            appointment.ScheduleId,
            appointment.Status,
            appointment.Reason,
            appointment.CreatedAt
        });
    }
    [HttpPut("{id:guid}/reschedule")]
    public async Task<IActionResult> RescheduleAppointment(
        Guid id,
        RescheduleAppointmentRequest request
    )
    {
        var appointment = await _context.Appointments
            .FirstOrDefaultAsync(a => a.Id == id);

        if (appointment == null)
        {
            return NotFound(new { message = "Không tìm thấy lịch hẹn" });
        }

        var status = appointment.Status.ToLower();

        if (status == "cancelled" || status == "canceled" || status == "da_huy")
        {
            return BadRequest(new { message = "Lịch hẹn đã hủy, không thể đổi lịch" });
        }

        if (status == "completed" || status == "hoan_thanh")
        {
            return BadRequest(new { message = "Lịch hẹn đã hoàn thành, không thể đổi lịch" });
        }

        var doctor = await _context.Doctors
            .FirstOrDefaultAsync(d => d.Id == request.DoctorId);

        if (doctor == null)
        {
            return BadRequest(new { message = "Bác sĩ không tồn tại" });
        }

        var newSchedule = await _context.DoctorSchedules
            .FirstOrDefaultAsync(s =>
                s.Id == request.ScheduleId &&
                s.DoctorId == request.DoctorId
            );

        if (newSchedule == null)
        {
            return BadRequest(new { message = "Không tìm thấy lịch làm việc phù hợp của bác sĩ" });
        }

        if (!newSchedule.IsAvailable)
        {
            return BadRequest(new { message = "Khung giờ này hiện không khả dụng" });
        }

        if (newSchedule.BookedCount >= newSchedule.MaxPatients)
        {
            return BadRequest(new { message = "Khung giờ này đã đầy" });
        }

        var exists = await _context.Appointments.AnyAsync(a =>
            a.Id != id &&
            a.ScheduleId == newSchedule.Id &&
            a.Status != "cancelled" &&
            a.Status != "canceled"
        );

        if (exists)
        {
            return BadRequest(new { message = "Khung giờ này đã có lịch hẹn" });
        }

        var oldSchedule = await _context.DoctorSchedules
            .FirstOrDefaultAsync(s => s.Id == appointment.ScheduleId);

        if (oldSchedule != null && oldSchedule.Id != newSchedule.Id)
        {
            if (oldSchedule.BookedCount > 0)
            {
                oldSchedule.BookedCount -= 1;
            }

            oldSchedule.UpdatedAt = DateTime.UtcNow;

            newSchedule.BookedCount += 1;
            newSchedule.UpdatedAt = DateTime.UtcNow;
        }

        appointment.DoctorId = request.DoctorId;
        appointment.ScheduleId = newSchedule.Id;
        // appointment.Status = "upcoming";
        appointment.UpdatedAt = DateTime.UtcNow;

        await _context.SaveChangesAsync();
        var patient = await _context.Patients
            .FirstOrDefaultAsync(p => p.Id == appointment.PatientId);

        if (patient != null)
        {
            await _fcm.SendToUserAsync(
                patient.UserId,
                "Đổi lịch thành công",
                $"Lịch hẹn {appointment.AppointmentNo} đã được cập nhật.",
                new Dictionary<string, string>
                {
                    ["type"] = "appointment_rescheduled",
                    ["appointmentId"] = appointment.Id.ToString(),
                    ["appointmentNo"] = appointment.AppointmentNo
                }
            );
        }
        return Ok(new
        {
            message = "Đổi lịch thành công",
            appointment.Id,
            appointment.AppointmentNo,
            appointment.PatientId,
            appointment.DoctorId,
            appointment.ScheduleId,
            appointment.Status,
            doctor = new
            {
                doctor.Id,
                doctor.FullName,
                doctor.Title
            },
            schedule = new
            {
                newSchedule.Id,
                newSchedule.DoctorId,
                newSchedule.ScheduleDate,
                newSchedule.StartTime,
                newSchedule.EndTime,
                newSchedule.BookedCount,
                newSchedule.MaxPatients,
                newSchedule.IsAvailable
            }
        });
    }
}
