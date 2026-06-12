using Care4U.Api.Data;
using Care4U.Api.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Cryptography;
namespace Care4U.Api.Controllers;

public class LoginRequest
{
    public string? Account { get; set; }
    public string? Password { get; set; }
    public string? LicenseNumber { get; set; }
}

public class ChangePasswordRequest
{
    public Guid UserId { get; set; }

    public string OldPassword { get; set; } = string.Empty;

    public string NewPassword { get; set; } = string.Empty;
}

public class RegisterPatientRequest
{
    public string? FullName { get; set; }
    public string? Email { get; set; }
    public string? Phone { get; set; }
    public string? Password { get; set; }
    public string? Gender { get; set; }
    public string? Dob { get; set; }
    public string? Address { get; set; }
}

public class ForgotPasswordRequest
{
    public string? Account { get; set; }
}

public class VerifyOtpRequest
{
    public string? Account { get; set; }
    public string? Otp { get; set; }
}

public class ResetPasswordRequest
{
    public Guid ResetToken { get; set; }
    public string? NewPassword { get; set; }
}

[ApiController]
[Route("api/[controller]")]
public class AuthController : ControllerBase
{
    private readonly Care4UDbContext _context;

    public AuthController(Care4UDbContext context)
    {
        _context = context;
    }
    [HttpPost("register")]
    public async Task<IActionResult> RegisterPatient(RegisterPatientRequest request)
    {
        var fullName = request.FullName?.Trim() ?? string.Empty;
        var email = request.Email?.Trim().ToLower() ?? string.Empty;
        var phone = NormalizeAccount(request.Phone);
        var password = request.Password?.Trim() ?? string.Empty;
        var genderText = string.IsNullOrWhiteSpace(request.Gender)
            ? "M"
            : request.Gender.Trim().ToUpper();

        char gender = genderText[0];

        if (gender != 'M' && gender != 'F' && gender != 'O')
        {
            return BadRequest(new { message = "Giới tính không hợp lệ" });
        }
        var address = request.Address?.Trim();

        if (string.IsNullOrWhiteSpace(fullName))
        {
            return BadRequest(new { message = "Vui lòng nhập họ tên" });
        }

        if (string.IsNullOrWhiteSpace(email))
        {
            return BadRequest(new { message = "Vui lòng nhập email" });
        }

        if (!System.Text.RegularExpressions.Regex.IsMatch(email, @"^[^@\s]+@[^@\s]+\.[^@\s]+$"))
        {
            return BadRequest(new { message = "Email không hợp lệ" });
        }

        if (string.IsNullOrWhiteSpace(phone))
        {
            return BadRequest(new { message = "Vui lòng nhập số điện thoại" });
        }

        if (!System.Text.RegularExpressions.Regex.IsMatch(phone, @"^\d{10}$"))
        {
            return BadRequest(new { message = "Số điện thoại phải gồm 10 chữ số" });
        }

        if (!System.Text.RegularExpressions.Regex.IsMatch(password, @"^\d{6}$"))
        {
            return BadRequest(new { message = "Mật khẩu phải gồm 6 chữ số" });
        }

        var emailExists = await _context.Users.AnyAsync(x => x.Email.ToLower() == email);
        if (emailExists)
        {
            return BadRequest(new { message = "Email đã tồn tại" });
        }

        var phoneExists = await _context.Users.AnyAsync(x => x.Phone != null && x.Phone == phone);
        if (phoneExists)
        {
            return BadRequest(new { message = "Số điện thoại đã tồn tại" });
        }

        var now = DateTime.UtcNow;
        var userId = Guid.NewGuid();

        var user = new User
        {
            Id = userId,
            Email = email,
            Phone = phone,
            PasswordHash = BCrypt.Net.BCrypt.HashPassword(password, workFactor: 6),
            Role = "patient",
            IsActive = true,
            // EmailVerified = false,
            CreatedAt = now,
            UpdatedAt = now
        };

        _context.Users.Add(user);
        await _context.SaveChangesAsync();

        var patient = new Patient
        {
            UserId = userId,
            // Email = email,
            FullName = fullName,
            Phone = phone,
            Gender = gender,
            Address = address,
            BloodType = null,
            Allergies = null,
            AvatarUrl = null,
            EmergencyContactName = null,
            EmergencyContactPhone = null,
            CreatedAt = now,
            UpdatedAt = now
        };

        if (!string.IsNullOrWhiteSpace(request.Dob))
        {
            // Nếu Patient.Dob của bạn là DateOnly? thì dùng dòng này:
            patient.Dob = DateOnly.Parse(request.Dob);

            // Nếu Patient.Dob của bạn là DateTime? thì đổi thành:
            // patient.Dob = DateTime.Parse(request.Dob);
        }

        _context.Patients.Add(patient);
        await _context.SaveChangesAsync();

        return Ok(new
        {
            message = "Đăng ký thành công",
            userId = user.Id,
            email = user.Email,
            phone = user.Phone,
            role = user.Role,
            patientId = patient.Id,
            doctorId = (int?)null
        });
    }
    [HttpPost("login")]
    public async Task<IActionResult> Login(LoginRequest request)
    {
        var account = NormalizeAccount(request.Account);
        var password = request.Password?.Trim() ?? string.Empty;

        if (string.IsNullOrWhiteSpace(account) || string.IsNullOrWhiteSpace(password))
        {
            return BadRequest(new { message = "Vui lòng nhập tài khoản và mật khẩu" });
        }

        var user = await _context.Users
            .FirstOrDefaultAsync(x =>
                x.Email.ToLower() == account.ToLower() ||
                (x.Phone != null && x.Phone == account));

        if (user == null)
        {
            return BadRequest(new { message = "Tài khoản không tồn tại" });
        }

        if (!user.IsActive)
        {
            return BadRequest(new { message = "Tài khoản đã bị khóa" });
        }

        var passwordOk = BCrypt.Net.BCrypt.Verify(password, user.PasswordHash);

        if (!passwordOk)
        {
            return BadRequest(new { message = "Sai mật khẩu" });
        }

        int? patientId = null;
        int? doctorId = null;

        if (user.Role == "patient")
        {
            patientId = await _context.Patients
                .Where(x => x.UserId == user.Id)
                .Select(x => (int?)x.Id)
                .FirstOrDefaultAsync();
        }

        string? doctorLicenseNumber = null;

        if (user.Role == "doctor")
        {
            var inputLicense = NormalizeLicense(request.LicenseNumber);

            if (string.IsNullOrWhiteSpace(inputLicense))
            {
                return BadRequest(new { message = "Vui lòng nhập mã định danh bác sĩ" });
            }

            var doctor = await _context.Doctors
                .FirstOrDefaultAsync(x => x.UserId == user.Id);

            if (doctor == null)
            {
                return BadRequest(new { message = "Không tìm thấy hồ sơ bác sĩ" });
            }

            var dbLicense = NormalizeLicense(doctor.LicenseNumber);

            if (dbLicense != inputLicense)
            {
                return BadRequest(new { message = "Mã định danh bác sĩ không chính xác" });
            }

            doctorId = doctor.Id;
            doctorLicenseNumber = doctor.LicenseNumber;
        }

        return Ok(new
        {
            message = "Đăng nhập thành công",
            userId = user.Id,
            user.Email,
            user.Phone,
            user.Role,
            user.IsActive,
            // user.EmailVerified,
            patientId,
            doctorId,
            licenseNumber = doctorLicenseNumber
        });
    }

    [HttpPost("forgot-password/send-otp")]
    public async Task<IActionResult> SendForgotPasswordOtp(ForgotPasswordRequest request)
    {
        var account = NormalizeAccount(request.Account);

        if (string.IsNullOrWhiteSpace(account))
        {
            return BadRequest(new { message = "Vui lòng nhập email hoặc số điện thoại" });
        }

        var user = await _context.Users
            .FirstOrDefaultAsync(x =>
                x.Email.ToLower() == account.ToLower() ||
                (x.Phone != null && x.Phone == account));

        if (user == null)
        {
            return BadRequest(new { message = "Email hoặc số điện thoại không tồn tại trong hệ thống" });
        }

        if (!user.IsActive)
        {
            return BadRequest(new { message = "Tài khoản đã bị khóa" });
        }

        var now = DateTime.UtcNow;

        var oldOtps = await _context.PasswordResetOtps
            .Where(x => x.UserId == user.Id && x.UsedAt == null)
            .ToListAsync();

        foreach (var item in oldOtps)
        {
            item.UsedAt = now;
        }

        var otp = GenerateOtp();
        var otpHash = BCrypt.Net.BCrypt.HashPassword(otp, workFactor: 6);

        var deliveryType = account.Contains("@") ? "email" : "phone";

        var resetOtp = new PasswordResetOtp
        {
            Id = Guid.NewGuid(),
            UserId = user.Id,
            OtpHash = otpHash,
            DeliveryTarget = account,
            DeliveryType = deliveryType,
            ExpiresAt = now.AddSeconds(30),
            CreatedAt = now
        };

        _context.PasswordResetOtps.Add(resetOtp);
        await _context.SaveChangesAsync();

        // DEMO: in OTP ra console backend.
        // Sau này tích hợp SMTP/SMS thì thay hàm này bằng gửi thật.
        Console.WriteLine($"[CARE4U OTP] Account: {account} - OTP: {otp} - Expires in 30 seconds");

        return Ok(new
        {
            message = "Mã OTP đã được gửi",
            expiresInSeconds = 30,

            // Chỉ để demo. Khi nộp thật nên xóa dòng này.
            devOtp = otp
        });
    }

    [HttpPost("forgot-password/verify-otp")]
    public async Task<IActionResult> VerifyForgotPasswordOtp(VerifyOtpRequest request)
    {
        var account = NormalizeAccount(request.Account);
        var otp = request.Otp?.Trim() ?? string.Empty;

        if (string.IsNullOrWhiteSpace(account) || string.IsNullOrWhiteSpace(otp))
        {
            return BadRequest(new { message = "Vui lòng nhập tài khoản và OTP" });
        }

        if (!System.Text.RegularExpressions.Regex.IsMatch(otp, @"^\d{6}$"))
        {
            return BadRequest(new { message = "OTP phải gồm 6 chữ số" });
        }

        var user = await _context.Users
            .FirstOrDefaultAsync(x =>
                x.Email.ToLower() == account.ToLower() ||
                (x.Phone != null && x.Phone == account));

        if (user == null)
        {
            return BadRequest(new { message = "Tài khoản không tồn tại" });
        }

        var now = DateTime.UtcNow;

        var latestOtp = await _context.PasswordResetOtps
            .Where(x => x.UserId == user.Id && x.UsedAt == null)
            .OrderByDescending(x => x.CreatedAt)
            .FirstOrDefaultAsync();

        if (latestOtp == null)
        {
            return BadRequest(new { message = "Không tìm thấy OTP. Vui lòng gửi lại mã" });
        }

        if (latestOtp.ExpiresAt < now)
        {
            return BadRequest(new { message = "OTP hết hiệu lực" });
        }

        var otpOk = BCrypt.Net.BCrypt.Verify(otp, latestOtp.OtpHash);

        if (!otpOk)
        {
            return BadRequest(new { message = "OTP không chính xác" });
        }

        latestOtp.VerifiedAt = now;
        latestOtp.ResetToken = Guid.NewGuid();
        latestOtp.ResetTokenExpiresAt = now.AddMinutes(5);

        await _context.SaveChangesAsync();

        return Ok(new
        {
            message = "Xác thực OTP thành công",
            resetToken = latestOtp.ResetToken,
            resetTokenExpiresInMinutes = 5
        });
    }

    [HttpPost("forgot-password/reset")]
    public async Task<IActionResult> ResetPassword(ResetPasswordRequest request)
    {
        var newPassword = request.NewPassword?.Trim() ?? string.Empty;

        if (request.ResetToken == Guid.Empty)
        {
            return BadRequest(new { message = "Thiếu reset token" });
        }

        if (!System.Text.RegularExpressions.Regex.IsMatch(newPassword, @"^\d{6}$"))
        {
            return BadRequest(new { message = "Mật khẩu mới phải gồm 6 chữ số" });
        }

        var now = DateTime.UtcNow;

        var otpRecord = await _context.PasswordResetOtps
            .Include(x => x.User)
            .FirstOrDefaultAsync(x =>
                x.ResetToken == request.ResetToken &&
                x.VerifiedAt != null &&
                x.UsedAt == null);

        if (otpRecord == null)
        {
            return BadRequest(new { message = "Token đổi mật khẩu không hợp lệ" });
        }

        if (otpRecord.ResetTokenExpiresAt == null || otpRecord.ResetTokenExpiresAt < now)
        {
            return BadRequest(new { message = "Phiên đổi mật khẩu đã hết hạn" });
        }

        otpRecord.User.PasswordHash = BCrypt.Net.BCrypt.HashPassword(newPassword, workFactor: 6);
        otpRecord.User.UpdatedAt = now;
        otpRecord.UsedAt = now;

        await _context.SaveChangesAsync();

        return Ok(new { message = "Đổi mật khẩu thành công" });
    }

    private static string GenerateOtp()
    {
        var number = RandomNumberGenerator.GetInt32(0, 1000000);
        return number.ToString("D6");
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

    [HttpPost("change-password")]
    public async Task<IActionResult> ChangePassword(ChangePasswordRequest request)
    {
        if (request.UserId == Guid.Empty)
        {
            return BadRequest(new { message = "Thiếu thông tin người dùng" });
        }

        if (string.IsNullOrWhiteSpace(request.OldPassword) ||
            string.IsNullOrWhiteSpace(request.NewPassword))
        {
            return BadRequest(new { message = "Vui lòng nhập đầy đủ mật khẩu" });
        }

        if (request.NewPassword.Length < 6)
        {
            return BadRequest(new { message = "Mật khẩu mới phải có ít nhất 6 ký tự" });
        }

        var user = await _context.Users
            .FirstOrDefaultAsync(x => x.Id == request.UserId);

        if (user == null)
        {
            return NotFound(new { message = "Không tìm thấy người dùng" });
        }

        var isOldPasswordValid = BCrypt.Net.BCrypt.Verify(
            request.OldPassword,
            user.PasswordHash
        );

        if (!isOldPasswordValid)
        {
            return BadRequest(new { message = "Mật khẩu hiện tại không đúng" });
        }

        user.PasswordHash = BCrypt.Net.BCrypt.HashPassword(request.NewPassword, workFactor: 6);
        user.UpdatedAt = DateTime.UtcNow;

        await _context.SaveChangesAsync();

        return Ok(new { message = "Đổi mật khẩu thành công" });
    }
}