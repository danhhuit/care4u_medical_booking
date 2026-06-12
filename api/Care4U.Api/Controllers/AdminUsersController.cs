using Care4U.Api.Data;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace Care4U.Api.Controllers;

public class UpdateUserStatusRequest
{
    public bool IsActive { get; set; }
}

public class UpdateAdminUserRequest
{
    public string? Email { get; set; }
    public string? Phone { get; set; }
    public string? NewPassword { get; set; }

    public string? FullName { get; set; }
    public string? Gender { get; set; }
    public string? Dob { get; set; }
    public string? Address { get; set; }

    public string? BloodType { get; set; }
    public string? Allergies { get; set; }
    public string? EmergencyContactName { get; set; }
    public string? EmergencyContactPhone { get; set; }

    public string? Title { get; set; }
    public string? LicenseNumber { get; set; }
    public decimal? ConsultationFee { get; set; }
    public string? Bio { get; set; }
}

[ApiController]
[Route("api/admin/users")]
public class AdminUsersController : ControllerBase
{
    private readonly Care4UDbContext _context;

    public AdminUsersController(Care4UDbContext context)
    {
        _context = context;
    }

    [HttpGet]
    public async Task<IActionResult> GetUsers(
        [FromQuery] string? role,
        [FromQuery] string? keyword
    )
    {
        var usersQuery = _context.Users.AsNoTracking().AsQueryable();

        if (!string.IsNullOrWhiteSpace(role) && role != "all")
        {
            usersQuery = usersQuery.Where(u => u.Role == role);
        }

        if (!string.IsNullOrWhiteSpace(keyword))
        {
            var key = keyword.Trim().ToLower();

            usersQuery = usersQuery.Where(u =>
                u.Email.ToLower().Contains(key) ||
                (u.Phone != null && u.Phone.Contains(key))
            );
        }

        var users = await usersQuery
            .OrderBy(u => u.Role)
            .ThenBy(u => u.Email)
            .ToListAsync();

        var result = new List<object>();

        foreach (var user in users)
        {
            int? patientId = null;
            int? doctorId = null;
            string? fullName = null;
            string? licenseNumber = null;

            if (user.Role == "patient")
            {
                var patient = await _context.Patients
                    .AsNoTracking()
                    .FirstOrDefaultAsync(p => p.UserId == user.Id);

                if (patient != null)
                {
                    patientId = patient.Id;
                    fullName = patient.FullName;
                }
            }

            if (user.Role == "doctor")
            {
                var doctor = await _context.Doctors
                    .AsNoTracking()
                    .FirstOrDefaultAsync(d => d.UserId == user.Id);

                if (doctor != null)
                {
                    doctorId = doctor.Id;
                    fullName = doctor.FullName;
                    licenseNumber = doctor.LicenseNumber;
                }
            }

            result.Add(new
            {
                userId = user.Id,
                user.Email,
                user.Phone,
                user.Role,
                user.IsActive,
                user.CreatedAt,
                user.UpdatedAt,
                patientId,
                doctorId,
                fullName,
                licenseNumber
            });
        }

        return Ok(result);
    }

    [HttpGet("{userId:guid}")]
    public async Task<IActionResult> GetUserDetail(Guid userId)
    {
        var user = await _context.Users
            .AsNoTracking()
            .FirstOrDefaultAsync(u => u.Id == userId);

        if (user == null)
        {
            return NotFound(new { message = "Không tìm thấy tài khoản" });
        }

        object? profile = null;

        if (user.Role == "patient")
        {
            profile = await _context.Patients
                .AsNoTracking()
                .Where(p => p.UserId == user.Id)
                .Select(p => new
                {
                    p.Id,
                    p.UserId,
                    p.FullName,
                    p.Dob,
                    p.Gender,
                    p.Phone,
                    p.Address,
                    p.BloodType,
                    p.Allergies,
                    p.AvatarUrl,
                    p.EmergencyContactName,
                    p.EmergencyContactPhone,
                    p.CreatedAt,
                    p.UpdatedAt
                })
                .FirstOrDefaultAsync();
        }

        if (user.Role == "doctor")
        {
            profile = await _context.Doctors
                .AsNoTracking()
                .Where(d => d.UserId == user.Id)
                .Select(d => new
                {
                    d.Id,
                    d.UserId,
                    d.FullName,
                    d.Title,
                    d.LicenseNumber,
                    d.ConsultationFee,
                    d.Bio,
                    d.Rating,
                    d.CreatedAt,
                    d.UpdatedAt
                })
                .FirstOrDefaultAsync();
        }

        return Ok(new
        {
            user = new
            {
                user.Id,
                user.Email,
                user.Phone,
                user.Role,
                user.IsActive,
                user.CreatedAt,
                user.UpdatedAt
            },
            profile
        });
    }

    [HttpPut("{userId:guid}/status")]
    public async Task<IActionResult> UpdateUserStatus(
        Guid userId,
        UpdateUserStatusRequest request
    )
    {
        var user = await _context.Users.FirstOrDefaultAsync(u => u.Id == userId);

        if (user == null)
        {
            return NotFound(new { message = "Không tìm thấy tài khoản" });
        }

        user.IsActive = request.IsActive;
        user.UpdatedAt = DateTime.UtcNow;

        await _context.SaveChangesAsync();

        return Ok(new
        {
            message = request.IsActive
                ? "Đã mở khóa tài khoản"
                : "Đã khóa tài khoản",
            userId = user.Id,
            user.IsActive
        });
    }

    [HttpPut("{userId:guid}")]
    public async Task<IActionResult> UpdateUser(Guid userId, UpdateAdminUserRequest request)
    {
        var user = await _context.Users.FirstOrDefaultAsync(u => u.Id == userId);

        if (user == null)
        {
            return NotFound(new { message = "Không tìm thấy tài khoản" });
        }

        var now = DateTime.UtcNow;

        var newEmail = request.Email?.Trim().ToLower();
        if (!string.IsNullOrWhiteSpace(newEmail) && newEmail != user.Email.ToLower())
        {
            var emailExists = await _context.Users
                .AnyAsync(u => u.Id != user.Id && u.Email.ToLower() == newEmail);

            if (emailExists)
            {
                return BadRequest(new { message = "Email đã tồn tại" });
            }

            user.Email = newEmail;
        }

        var newPhone = NormalizeAccount(request.Phone);
        if (!string.IsNullOrWhiteSpace(newPhone) && newPhone != user.Phone)
        {
            var phoneExists = await _context.Users
                .AnyAsync(u => u.Id != user.Id && u.Phone != null && u.Phone == newPhone);

            if (phoneExists)
            {
                return BadRequest(new { message = "Số điện thoại đã tồn tại" });
            }

            user.Phone = newPhone;
        }

        if (!string.IsNullOrWhiteSpace(request.NewPassword))
        {
            var password = request.NewPassword.Trim();

            if (!System.Text.RegularExpressions.Regex.IsMatch(password, @"^\d{6}$"))
            {
                return BadRequest(new { message = "Mật khẩu mới phải gồm 6 chữ số" });
            }

            user.PasswordHash = BCrypt.Net.BCrypt.HashPassword(password, workFactor: 6);
        }

        user.UpdatedAt = now;

        if (user.Role == "patient")
        {
            var patient = await _context.Patients.FirstOrDefaultAsync(p => p.UserId == user.Id);

            if (patient != null)
            {
                if (!string.IsNullOrWhiteSpace(request.FullName))
                {
                    patient.FullName = request.FullName.Trim();
                }

                if (!string.IsNullOrWhiteSpace(user.Phone))
                {
                    patient.Phone = user.Phone;
                }

                if (!string.IsNullOrWhiteSpace(request.Gender))
                {
                    var genderText = request.Gender.Trim().ToUpper();
                    var gender = genderText[0];

                    if (gender != 'M' && gender != 'F' && gender != 'O')
                    {
                        return BadRequest(new { message = "Giới tính không hợp lệ" });
                    }

                    patient.Gender = gender;
                }

                if (!string.IsNullOrWhiteSpace(request.Dob))
                {
                    if (!DateOnly.TryParse(request.Dob, out var parsedDob))
                    {
                        return BadRequest(new { message = "Ngày sinh không hợp lệ. Định dạng đúng: yyyy-MM-dd" });
                    }

                    patient.Dob = parsedDob;
                }

                if (request.Address != null)
                {
                    patient.Address = request.Address;
                }

                if (request.BloodType != null)
                {
                    patient.BloodType = request.BloodType;
                }

                if (request.Allergies != null)
                {
                    patient.Allergies = request.Allergies;
                }

                if (request.EmergencyContactName != null)
                {
                    patient.EmergencyContactName = request.EmergencyContactName;
                }

                if (request.EmergencyContactPhone != null)
                {
                    patient.EmergencyContactPhone = request.EmergencyContactPhone;
                }

                patient.UpdatedAt = now;
            }
        }

        if (user.Role == "doctor")
        {
            var doctor = await _context.Doctors.FirstOrDefaultAsync(d => d.UserId == user.Id);

            if (doctor != null)
            {
                if (!string.IsNullOrWhiteSpace(request.FullName))
                {
                    doctor.FullName = request.FullName.Trim();
                }

                if (!string.IsNullOrWhiteSpace(request.Title))
                {
                    doctor.Title = request.Title.Trim();
                }

                if (!string.IsNullOrWhiteSpace(request.LicenseNumber))
                {
                    var license = NormalizeLicense(request.LicenseNumber);

                    var licenseExists = await _context.Doctors.AnyAsync(d =>
                        d.Id != doctor.Id &&
                        d.LicenseNumber != null &&
                        d.LicenseNumber.ToUpper() == license
                    );

                    if (licenseExists)
                    {
                        return BadRequest(new { message = "Mã định danh bác sĩ đã tồn tại" });
                    }

                    doctor.LicenseNumber = license;
                }

                if (request.ConsultationFee != null)
                {
                    doctor.ConsultationFee = request.ConsultationFee.Value;
                }

                if (request.Bio != null)
                {
                    doctor.Bio = request.Bio;
                }

                doctor.UpdatedAt = now;
            }
        }

        await _context.SaveChangesAsync();

        return Ok(new
        {
            message = "Cập nhật tài khoản thành công",
            userId = user.Id
        });
    }

    private static string NormalizeAccount(string? account)
    {
        var value = (account ?? string.Empty).Trim();

        if (value.StartsWith("+84"))
        {
            value = "0" + value.Substring(3);
        }

        if (value.StartsWith("84") && value.Length == 11)
        {
            value = "0" + value.Substring(2);
        }

        return value;
    }

    private static string NormalizeLicense(string? licenseNumber)
    {
        return (licenseNumber ?? string.Empty)
            .Trim()
            .Replace(" ", "")
            .ToUpper();
    }
}