using Care4U.Api.Data;
using Care4U.Api.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace Care4U.Api.Controllers;

public class CreateMedicalRecordRequest
{
    public Guid AppointmentId { get; set; }
    public int PatientId { get; set; }
    public int DoctorId { get; set; }
    public string? RecordDate { get; set; }
    public string ChiefComplaint { get; set; } = string.Empty;
    public string? Symptoms { get; set; }
    public string Diagnosis { get; set; } = string.Empty;
    public string? Icd10Code { get; set; }
    public string? TreatmentPlan { get; set; }
    public string? FollowUpDate { get; set; }
    public string? VitalSigns { get; set; }
    public List<string>? Attachments { get; set; }
}

public class UpdateMedicalRecordRequest
{
    public string? RecordDate { get; set; }
    public string? ChiefComplaint { get; set; }
    public string? Symptoms { get; set; }
    public string? Diagnosis { get; set; }
    public string? Icd10Code { get; set; }
    public string? TreatmentPlan { get; set; }
    public string? FollowUpDate { get; set; }
    public string? VitalSigns { get; set; }
    public List<string>? Attachments { get; set; }
}

[ApiController]
[Route("api/[controller]")]
public class MedicalRecordsController : ControllerBase
{
    private readonly Care4UDbContext _context;

    public MedicalRecordsController(Care4UDbContext context)
    {
        _context = context;
    }

    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        var data = await BuildQuery()
            .OrderByDescending(x => x.RecordDate)
            .Select(x => ToResponse(x))
            .ToListAsync();

        return Ok(data);
    }

    [HttpGet("doctor/{doctorId:int}")]
    public async Task<IActionResult> GetByDoctor(int doctorId)
    {
        var data = await BuildQuery()
            .Where(x => x.DoctorId == doctorId)
            .OrderByDescending(x => x.RecordDate)
            .Select(x => ToResponse(x))
            .ToListAsync();

        return Ok(data);
    }

    [HttpGet("patient/{patientId:int}")]
    public async Task<IActionResult> GetByPatient(int patientId)
    {
        var data = await BuildQuery()
            .Where(x => x.PatientId == patientId)
            .OrderByDescending(x => x.RecordDate)
            .Select(x => ToResponse(x))
            .ToListAsync();

        return Ok(data);
    }

    [HttpGet("{id:int}")]
    public async Task<IActionResult> GetById(int id)
    {
        var item = await BuildQuery()
            .Where(x => x.Id == id)
            .Select(x => ToResponse(x))
            .FirstOrDefaultAsync();

        if (item == null)
        {
            return NotFound(new { message = "Không tìm thấy hồ sơ bệnh án" });
        }

        return Ok(item);
    }

    [HttpGet("appointment/{appointmentId:guid}")]
    public async Task<IActionResult> GetByAppointment(Guid appointmentId)
    {
        var item = await BuildQuery()
            .Where(x => x.AppointmentId == appointmentId)
            .Select(x => ToResponse(x))
            .FirstOrDefaultAsync();

        if (item == null)
        {
            return NotFound(new { message = "Không tìm thấy hồ sơ bệnh án của lịch hẹn này" });
        }

        return Ok(item);
    }

    [HttpPost]
    public async Task<IActionResult> Create(CreateMedicalRecordRequest request)
    {
        if (request.AppointmentId == Guid.Empty)
        {
            return BadRequest(new { message = "Thiếu mã lịch hẹn" });
        }

        if (request.DoctorId <= 0 || request.PatientId <= 0)
        {
            return BadRequest(new { message = "Thiếu thông tin bác sĩ hoặc bệnh nhân" });
        }

        if (string.IsNullOrWhiteSpace(request.ChiefComplaint))
        {
            return BadRequest(new { message = "Lý do khám không được để trống" });
        }

        if (string.IsNullOrWhiteSpace(request.Diagnosis))
        {
            return BadRequest(new { message = "Chẩn đoán không được để trống" });
        }

        var appointment = await _context.Appointments
            .FirstOrDefaultAsync(x => x.Id == request.AppointmentId);

        if (appointment == null)
        {
            return BadRequest(new { message = "Không tìm thấy lịch hẹn" });
        }

        if (appointment.DoctorId != request.DoctorId || appointment.PatientId != request.PatientId)
        {
            return BadRequest(new { message = "Lịch hẹn không khớp với bác sĩ hoặc bệnh nhân" });
        }

        var existed = await _context.MedicalRecords
            .AnyAsync(x => x.AppointmentId == request.AppointmentId);

        if (existed)
        {
            return BadRequest(new { message = "Lịch hẹn này đã có hồ sơ bệnh án" });
        }

        var now = DateTime.UtcNow;
        var recordDate = ParseDateOnlyOrDefault(request.RecordDate, DateOnly.FromDateTime(now));
        var followUpDate = ParseNullableDateOnly(request.FollowUpDate);

        var record = new MedicalRecord
        {
            AppointmentId = request.AppointmentId,
            PatientId = request.PatientId,
            DoctorId = request.DoctorId,
            RecordDate = recordDate,
            ChiefComplaint = request.ChiefComplaint.Trim(),
            Symptoms = NormalizeNullable(request.Symptoms),
            Diagnosis = request.Diagnosis.Trim(),
            Icd10Code = NormalizeNullable(request.Icd10Code),
            TreatmentPlan = NormalizeNullable(request.TreatmentPlan),
            FollowUpDate = followUpDate,
            VitalSigns = NormalizeNullable(request.VitalSigns),
            Attachments = request.Attachments,
            CreatedAt = now,
            UpdatedAt = now
        };

        try
        {
            _context.MedicalRecords.Add(record);
            await _context.SaveChangesAsync();
        }
        catch (DbUpdateException ex)
        {
            return BadRequest(new
            {
                message = "Không thể lưu hồ sơ bệnh án vào database",
                error = ex.InnerException?.Message ?? ex.Message
            });
        }

        var result = await BuildQuery()
            .Where(x => x.Id == record.Id)
            .Select(x => ToResponse(x))
            .FirstOrDefaultAsync();

        return Ok(new
        {
            message = "Tạo hồ sơ bệnh án thành công",
            record = result
        });
    }

    [HttpPut("{id:int}")]
    public async Task<IActionResult> Update(int id, UpdateMedicalRecordRequest request)
    {
        var record = await _context.MedicalRecords.FirstOrDefaultAsync(x => x.Id == id);

        if (record == null)
        {
            return NotFound(new { message = "Không tìm thấy hồ sơ bệnh án" });
        }

        if (request.RecordDate != null)
        {
            record.RecordDate = ParseDateOnlyOrDefault(request.RecordDate, record.RecordDate);
        }

        if (request.ChiefComplaint != null)
        {
            if (string.IsNullOrWhiteSpace(request.ChiefComplaint))
            {
                return BadRequest(new { message = "Lý do khám không được để trống" });
            }
            record.ChiefComplaint = request.ChiefComplaint.Trim();
        }

        if (request.Diagnosis != null)
        {
            if (string.IsNullOrWhiteSpace(request.Diagnosis))
            {
                return BadRequest(new { message = "Chẩn đoán không được để trống" });
            }
            record.Diagnosis = request.Diagnosis.Trim();
        }

        if (request.Symptoms != null) record.Symptoms = NormalizeNullable(request.Symptoms);
        if (request.Icd10Code != null) record.Icd10Code = NormalizeNullable(request.Icd10Code);
        if (request.TreatmentPlan != null) record.TreatmentPlan = NormalizeNullable(request.TreatmentPlan);
        if (request.FollowUpDate != null) record.FollowUpDate = ParseNullableDateOnly(request.FollowUpDate);
        if (request.VitalSigns != null) record.VitalSigns = NormalizeNullable(request.VitalSigns);
        if (request.Attachments != null) record.Attachments = request.Attachments;

        record.UpdatedAt = DateTime.UtcNow;

        try
        {
            await _context.SaveChangesAsync();
        }
        catch (DbUpdateException ex)
        {
            return BadRequest(new
            {
                message = "Không thể cập nhật hồ sơ bệnh án",
                error = ex.InnerException?.Message ?? ex.Message
            });
        }

        var result = await BuildQuery()
            .Where(x => x.Id == id)
            .Select(x => ToResponse(x))
            .FirstOrDefaultAsync();

        return Ok(new
        {
            message = "Cập nhật hồ sơ bệnh án thành công",
            record = result
        });
    }

    private IQueryable<MedicalRecord> BuildQuery()
    {
        return _context.MedicalRecords
            .Include(x => x.Patient)
            .Include(x => x.Doctor)
                .ThenInclude(d => d.Specialty)
            .Include(x => x.Doctor)
                .ThenInclude(d => d.HealthCenter);
    }

    private static object ToResponse(MedicalRecord x)
    {
        return new
        {
            x.Id,
            x.AppointmentId,
            x.PatientId,
            PatientName = x.Patient.FullName,
            x.DoctorId,
            DoctorName = x.Doctor.FullName,
            DoctorTitle = x.Doctor.Title,
            SpecialtyName = x.Doctor.Specialty.Name,
            HealthCenterName = x.Doctor.HealthCenter != null ? x.Doctor.HealthCenter.Name : null,
            x.RecordDate,
            x.ChiefComplaint,
            x.Symptoms,
            x.Diagnosis,
            x.Icd10Code,
            x.TreatmentPlan,
            x.FollowUpDate,
            x.VitalSigns,
            x.Attachments,
            x.CreatedAt,
            x.UpdatedAt
        };
    }

    private static DateOnly ParseDateOnlyOrDefault(string? value, DateOnly fallback)
    {
        return DateOnly.TryParse(value, out var parsed) ? parsed : fallback;
    }

    private static DateOnly? ParseNullableDateOnly(string? value)
    {
        return DateOnly.TryParse(value, out var parsed) ? parsed : null;
    }

    private static string? NormalizeNullable(string? value)
    {
        var text = value?.Trim();
        return string.IsNullOrWhiteSpace(text) ? null : text;
    }
}
