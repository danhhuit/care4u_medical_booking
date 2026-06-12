using Care4U.Api.Data;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace Care4U.Api.Controllers;

public class UpdatePatientRequest
{
    public string? FullName { get; set; }
    public string? Dob { get; set; }
    public string? Gender { get; set; }
    public string? Phone { get; set; }
    public string? Address { get; set; }
    public string? BloodType { get; set; }
    public string? Allergies { get; set; }
    public string? AvatarUrl { get; set; }
    public string? EmergencyContactName { get; set; }
    public string? EmergencyContactPhone { get; set; }
}

[ApiController]
[Route("api/[controller]")]
public class PatientsController : ControllerBase
{
    private readonly Care4UDbContext _context;

    public PatientsController(Care4UDbContext context)
    {
        _context = context;
    }

    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        var data = await _context.Patients
            .Include(x => x.User)
            .OrderBy(x => x.Id)
            .Select(x => new
            {
                x.Id,
                x.UserId,
                Email = x.User.Email,
                x.FullName,
                Dob = x.Dob.HasValue ? x.Dob.Value.ToString("yyyy-MM-dd") : null,
                Gender = x.Gender.HasValue ? x.Gender.Value.ToString() : null,
                x.Phone,
                x.Address,
                x.BloodType,
                x.Allergies,
                x.AvatarUrl,
                x.EmergencyContactName,
                x.EmergencyContactPhone,
                x.CreatedAt,
                x.UpdatedAt
            })
            .ToListAsync();

        return Ok(data);
    }

    [HttpGet("{id:int}")]
    public async Task<IActionResult> GetById(int id)
    {
        var item = await _context.Patients
            .Include(x => x.User)
            .Where(x => x.Id == id)
            .Select(x => new
            {
                x.Id,
                x.UserId,
                Email = x.User.Email,
                x.FullName,
                Dob = x.Dob.HasValue ? x.Dob.Value.ToString("yyyy-MM-dd") : null,
                Gender = x.Gender.HasValue ? x.Gender.Value.ToString() : null,
                x.Phone,
                x.Address,
                x.BloodType,
                x.Allergies,
                x.AvatarUrl,
                x.EmergencyContactName,
                x.EmergencyContactPhone,
                x.CreatedAt,
                x.UpdatedAt
            })
            .FirstOrDefaultAsync();

        if (item == null)
        {
            return NotFound(new { message = "Không tìm thấy bệnh nhân" });
        }

        return Ok(item);
    }

    [HttpPut("{id:int}")]
    public async Task<IActionResult> Update(int id, UpdatePatientRequest request)
    {
        var patient = await _context.Patients.FirstOrDefaultAsync(x => x.Id == id);

        if (patient == null)
        {
            return NotFound(new { message = "Không tìm thấy bệnh nhân" });
        }

        if (!string.IsNullOrWhiteSpace(request.FullName))
        {
            patient.FullName = request.FullName.Trim();
        }

        if (!string.IsNullOrWhiteSpace(request.Phone))
        {
            patient.Phone = request.Phone.Trim();
        }

        if (!string.IsNullOrWhiteSpace(request.Address))
        {
            patient.Address = request.Address.Trim();
        }

        if (!string.IsNullOrWhiteSpace(request.BloodType))
        {
            patient.BloodType = request.BloodType.Trim();
        }

        if (request.Allergies != null)
        {
            patient.Allergies = request.Allergies.Trim();
        }

        if (request.AvatarUrl != null)
        {
            patient.AvatarUrl = request.AvatarUrl.Trim();
        }

        if (request.EmergencyContactName != null)
        {
            patient.EmergencyContactName = request.EmergencyContactName.Trim();
        }

        if (request.EmergencyContactPhone != null)
        {
            patient.EmergencyContactPhone = request.EmergencyContactPhone.Trim();
        }

        if (!string.IsNullOrWhiteSpace(request.Dob))
        {
            if (!DateOnly.TryParse(request.Dob.Trim(), out var dob))
            {
                return BadRequest(new { message = "Ngày sinh không hợp lệ. Định dạng đúng: yyyy-MM-dd" });
            }

            patient.Dob = dob;
        }

        var gender = NormalizeGender(request.Gender);
        if (gender.HasValue)
        {
            patient.Gender = gender.Value;
        }

        patient.UpdatedAt = DateTime.UtcNow;

        await _context.SaveChangesAsync();

        return Ok(new
        {
            message = "Cập nhật hồ sơ thành công",
            patient.Id,
            patient.UserId,
            patient.FullName,
            Dob = patient.Dob.HasValue ? patient.Dob.Value.ToString("yyyy-MM-dd") : null,
            Gender = patient.Gender.HasValue ? patient.Gender.Value.ToString() : null,
            patient.Phone,
            patient.Address,
            patient.BloodType,
            patient.Allergies,
            patient.AvatarUrl,
            patient.EmergencyContactName,
            patient.EmergencyContactPhone,
            patient.UpdatedAt
        });
    }

    private static char? NormalizeGender(string? gender)
    {
        if (string.IsNullOrWhiteSpace(gender))
        {
            return null;
        }

        var value = gender.Trim().ToLower();

        return value switch
        {
            "m" => 'M',
            "male" => 'M',
            "nam" => 'M',
            "f" => 'F',
            "female" => 'F',
            "nữ" => 'F',
            "nu" => 'F',
            "o" => 'O',
            "other" => 'O',
            "khác" => 'O',
            "khac" => 'O',
            _ => char.ToUpper(value[0])
        };
    }
}
