using Care4U.Api.Data;
using Care4U.Api.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace Care4U.Api.Controllers;

public class CreatePrescriptionItemRequest
{
    public int MedicineId { get; set; }
    public string Dosage { get; set; } = string.Empty;
    public string Frequency { get; set; } = string.Empty;
    public string Duration { get; set; } = string.Empty;
    public int Quantity { get; set; }
    public string? Instructions { get; set; }
}

public class CreatePrescriptionRequest
{
    public int MedicalRecordId { get; set; }
    public int DoctorId { get; set; }
    public int PatientId { get; set; }
    public string? DateIssued { get; set; }
    public string? ValidUntil { get; set; }
    public string? Status { get; set; }
    public string? PharmacistNotes { get; set; }
    public string? Notes { get; set; }
    public List<CreatePrescriptionItemRequest> Items { get; set; } = new();
}

[ApiController]
[Route("api/[controller]")]
public class PrescriptionsController : ControllerBase
{
    private readonly Care4UDbContext _context;

    public PrescriptionsController(Care4UDbContext context)
    {
        _context = context;
    }

    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        var data = await _context.Prescriptions
            .Include(x => x.Patient)
            .Include(x => x.Doctor)
            .Include(x => x.MedicalRecord)
            .Include(x => x.PrescriptionItems)
                .ThenInclude(i => i.Medicine)
            .OrderByDescending(x => x.DateIssued)
            .Select(x => new
            {
                x.Id,
                x.MedicalRecordId,
                x.DoctorId,
                DoctorName = x.Doctor.FullName,
                DoctorTitle = x.Doctor.Title,
                x.PatientId,
                PatientName = x.Patient.FullName,
                x.PrescriptionNo,
                x.DateIssued,
                x.ValidUntil,
                x.Status,
                x.PharmacistNotes,
                x.Notes,
                x.CreatedAt,
                x.UpdatedAt,
                Items = x.PrescriptionItems.Select(i => new
                {
                    i.Id,
                    i.MedicineId,
                    MedicineName = i.Medicine.Name,
                    GenericName = i.Medicine.GenericName,
                    BrandName = i.Medicine.BrandName,
                    DosageForm = i.Medicine.DosageForm,
                    Strength = i.Medicine.Strength,
                    Unit = i.Medicine.Unit,
                    Price = i.Medicine.Price,
                    i.Dosage,
                    i.Frequency,
                    i.Duration,
                    i.Quantity,
                    i.Instructions
                }).ToList()
            })
            .ToListAsync();

        return Ok(data);
    }

    [HttpGet("doctor/{doctorId:int}")]
    public async Task<IActionResult> GetByDoctor(int doctorId)
    {
        var data = await _context.Prescriptions
            .Include(x => x.Patient)
            .Include(x => x.Doctor)
            .Include(x => x.MedicalRecord)
            .Include(x => x.PrescriptionItems)
                .ThenInclude(i => i.Medicine)
            .Where(x => x.DoctorId == doctorId)
            .OrderByDescending(x => x.DateIssued)
            .Select(x => new
            {
                x.Id,
                x.MedicalRecordId,
                x.DoctorId,
                DoctorName = x.Doctor.FullName,
                DoctorTitle = x.Doctor.Title,
                x.PatientId,
                PatientName = x.Patient.FullName,
                x.PrescriptionNo,
                x.DateIssued,
                x.ValidUntil,
                x.Status,
                x.PharmacistNotes,
                x.Notes,
                x.CreatedAt,
                x.UpdatedAt,
                Items = x.PrescriptionItems.Select(i => new
                {
                    i.Id,
                    i.MedicineId,
                    MedicineName = i.Medicine.Name,
                    GenericName = i.Medicine.GenericName,
                    BrandName = i.Medicine.BrandName,
                    DosageForm = i.Medicine.DosageForm,
                    Strength = i.Medicine.Strength,
                    Unit = i.Medicine.Unit,
                    Price = i.Medicine.Price,
                    i.Dosage,
                    i.Frequency,
                    i.Duration,
                    i.Quantity,
                    i.Instructions
                }).ToList()
            })
            .ToListAsync();

        return Ok(data);
    }

    [HttpGet("patient/{patientId:int}")]
    public async Task<IActionResult> GetByPatient(int patientId)
    {
        var data = await _context.Prescriptions
            .Include(x => x.Patient)
            .Include(x => x.Doctor)
            .Include(x => x.MedicalRecord)
            .Include(x => x.PrescriptionItems)
                .ThenInclude(i => i.Medicine)
            .Where(x => x.PatientId == patientId)
            .OrderByDescending(x => x.DateIssued)
            .Select(x => new
            {
                x.Id,
                x.MedicalRecordId,
                x.DoctorId,
                DoctorName = x.Doctor.FullName,
                DoctorTitle = x.Doctor.Title,
                x.PatientId,
                PatientName = x.Patient.FullName,
                x.PrescriptionNo,
                x.DateIssued,
                x.ValidUntil,
                x.Status,
                x.PharmacistNotes,
                x.Notes,
                x.CreatedAt,
                x.UpdatedAt,
                Items = x.PrescriptionItems.Select(i => new
                {
                    i.Id,
                    i.MedicineId,
                    MedicineName = i.Medicine.Name,
                    GenericName = i.Medicine.GenericName,
                    BrandName = i.Medicine.BrandName,
                    DosageForm = i.Medicine.DosageForm,
                    Strength = i.Medicine.Strength,
                    Unit = i.Medicine.Unit,
                    Price = i.Medicine.Price,
                    i.Dosage,
                    i.Frequency,
                    i.Duration,
                    i.Quantity,
                    i.Instructions
                }).ToList()
            })
            .ToListAsync();

        return Ok(data);
    }

    [HttpGet("{id:int}")]
    public async Task<IActionResult> GetById(int id)
    {
        var item = await _context.Prescriptions
            .Include(x => x.Patient)
            .Include(x => x.Doctor)
            .Include(x => x.MedicalRecord)
            .Include(x => x.PrescriptionItems)
                .ThenInclude(i => i.Medicine)
            .Where(x => x.Id == id)
            .Select(x => new
            {
                x.Id,
                x.MedicalRecordId,
                x.DoctorId,
                DoctorName = x.Doctor.FullName,
                DoctorTitle = x.Doctor.Title,
                x.PatientId,
                PatientName = x.Patient.FullName,
                x.PrescriptionNo,
                x.DateIssued,
                x.ValidUntil,
                x.Status,
                x.PharmacistNotes,
                x.Notes,
                x.CreatedAt,
                x.UpdatedAt,
                Items = x.PrescriptionItems.Select(i => new
                {
                    i.Id,
                    i.MedicineId,
                    MedicineName = i.Medicine.Name,
                    GenericName = i.Medicine.GenericName,
                    BrandName = i.Medicine.BrandName,
                    DosageForm = i.Medicine.DosageForm,
                    Strength = i.Medicine.Strength,
                    Unit = i.Medicine.Unit,
                    Price = i.Medicine.Price,
                    i.Dosage,
                    i.Frequency,
                    i.Duration,
                    i.Quantity,
                    i.Instructions
                }).ToList()
            })
            .FirstOrDefaultAsync();

        if (item == null)
        {
            return NotFound(new { message = "Không tìm thấy đơn thuốc" });
        }

        return Ok(item);
    }

    [HttpPost]
    public async Task<IActionResult> Create(CreatePrescriptionRequest request)
    {
        try
        {
            if (request.DoctorId <= 0 || request.PatientId <= 0 || request.MedicalRecordId <= 0)
            {
                return BadRequest(new { message = "Thiếu thông tin bác sĩ, bệnh nhân hoặc hồ sơ bệnh án" });
            }

            if (request.Items == null || request.Items.Count == 0)
            {
                return BadRequest(new { message = "Đơn thuốc phải có ít nhất 1 thuốc" });
            }

            var doctorExists = await _context.Doctors.AnyAsync(x => x.Id == request.DoctorId);
            if (!doctorExists)
            {
                return BadRequest(new { message = "Không tìm thấy bác sĩ" });
            }

            var patientExists = await _context.Patients.AnyAsync(x => x.Id == request.PatientId);
            if (!patientExists)
            {
                return BadRequest(new { message = "Không tìm thấy bệnh nhân" });
            }

            var medicalRecord = await _context.MedicalRecords
                .FirstOrDefaultAsync(x => x.Id == request.MedicalRecordId);

            if (medicalRecord == null)
            {
                return BadRequest(new { message = "Không tìm thấy hồ sơ bệnh án" });
            }

            if (medicalRecord.DoctorId != request.DoctorId || medicalRecord.PatientId != request.PatientId)
            {
                return BadRequest(new { message = "Hồ sơ bệnh án không khớp với bác sĩ hoặc bệnh nhân" });
            }

            var existingPrescription = await _context.Prescriptions
                .FirstOrDefaultAsync(x => x.MedicalRecordId == request.MedicalRecordId);

            if (existingPrescription != null)
            {
                return BadRequest(new
                {
                    message = "Hồ sơ bệnh án này đã có đơn thuốc. Vui lòng xem đơn thuốc hiện có hoặc chọn hồ sơ bệnh án khác.",
                    existingPrescriptionId = existingPrescription.Id,
                    existingPrescriptionNo = existingPrescription.PrescriptionNo
                });
            }

            foreach (var item in request.Items)
            {
                if (item.MedicineId <= 0)
                {
                    return BadRequest(new { message = "MedicineId không hợp lệ" });
                }

                if (item.Quantity <= 0)
                {
                    return BadRequest(new { message = "Số lượng thuốc phải lớn hơn 0" });
                }

                if (string.IsNullOrWhiteSpace(item.Dosage) ||
                    string.IsNullOrWhiteSpace(item.Frequency) ||
                    string.IsNullOrWhiteSpace(item.Duration))
                {
                    return BadRequest(new { message = "Liều dùng, tần suất và thời gian dùng không được để trống" });
                }

                var medicineExists = await _context.Medicines
                    .AnyAsync(x => x.Id == item.MedicineId && x.IsActive);

                if (!medicineExists)
                {
                    return BadRequest(new { message = $"Không tìm thấy thuốc đang hoạt động với id {item.MedicineId}" });
                }
            }

            var now = DateTime.UtcNow;
            var dateIssued = ParseDateOnlyOrDefault(request.DateIssued, DateOnly.FromDateTime(now));
            var validUntil = ParseNullableDateOnly(request.ValidUntil) ?? dateIssued.AddDays(30);

            var prescription = new Prescription
            {
                MedicalRecordId = request.MedicalRecordId,
                DoctorId = request.DoctorId,
                PatientId = request.PatientId,
                PrescriptionNo = $"RX-{now:yyyyMMddHHmmssfff}",
                DateIssued = dateIssued,
                ValidUntil = validUntil,
                Status = NormalizeStatus(request.Status),
                PharmacistNotes = request.PharmacistNotes,
                Notes = request.Notes,
                CreatedAt = now,
                UpdatedAt = now
            };

            foreach (var item in request.Items)
            {
                prescription.PrescriptionItems.Add(new PrescriptionItem
                {
                    MedicineId = item.MedicineId,
                    Dosage = item.Dosage.Trim(),
                    Frequency = item.Frequency.Trim(),
                    Duration = item.Duration.Trim(),
                    Quantity = item.Quantity,
                    Instructions = string.IsNullOrWhiteSpace(item.Instructions) ? null : item.Instructions.Trim(),
                    CreatedAt = now
                });
            }

            _context.Prescriptions.Add(prescription);
            await _context.SaveChangesAsync();
            var patient = await _context.Patients
            .FirstOrDefaultAsync(x => x.Id == request.PatientId);

            if (patient != null)
            {
                _context.Notifications.Add(new Notification
                {
                    UserId = patient.UserId,
                    Title = "Bạn có đơn thuốc mới",
                    Body = $"Bác sĩ đã kê đơn thuốc {prescription.PrescriptionNo}. Vui lòng kiểm tra trong mục Đơn thuốc.",
                    Type = "prescription_ready",
                    RefType = "prescription",
                    RefId = prescription.Id.ToString(),
                    IsRead = false,
                    CreatedAt = DateTime.UtcNow
                });

                await _context.SaveChangesAsync();
            }
            return Ok(new
            {
                message = "Tạo đơn thuốc thành công",
                prescription.Id,
                prescription.PrescriptionNo,
                prescription.DoctorId,
                prescription.PatientId,
                prescription.MedicalRecordId,
                prescription.DateIssued,
                prescription.ValidUntil,
                prescription.Status,
                prescription.Notes,
                Items = prescription.PrescriptionItems.Select(i => new
                {
                    i.Id,
                    i.MedicineId,
                    i.Dosage,
                    i.Frequency,
                    i.Duration,
                    i.Quantity,
                    i.Instructions
                }).ToList()
            });
        }
        catch (DbUpdateException ex)
        {
            return BadRequest(new
            {
                message = "Không thể lưu đơn thuốc vào database",
                error = ex.InnerException?.Message ?? ex.Message
            });
        }
        catch (Exception ex)
        {
            return BadRequest(new
            {
                message = "Tạo đơn thuốc thất bại",
                error = ex.Message
            });
        }
    }

    private static DateOnly ParseDateOnlyOrDefault(string? value, DateOnly fallback)
    {
        return DateOnly.TryParse(value, out var parsed) ? parsed : fallback;
    }

    private static DateOnly? ParseNullableDateOnly(string? value)
    {
        return DateOnly.TryParse(value, out var parsed) ? parsed : null;
    }

    private static string NormalizeStatus(string? status)
    {
        var value = (status ?? "").Trim().ToLower();

        return value switch
        {
            "active" => "active",
            "completed" => "completed",
            "done" => "completed",
            "cancelled" => "cancelled",
            "canceled" => "cancelled",
            _ => "active"
        };
    }
}
