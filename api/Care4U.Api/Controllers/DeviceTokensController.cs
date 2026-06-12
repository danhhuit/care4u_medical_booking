using Care4U.Api.Data;
using Care4U.Api.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace Care4U.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class DeviceTokensController : ControllerBase
{
    private readonly Care4UDbContext _context;

    public DeviceTokensController(Care4UDbContext context)
    {
        _context = context;
    }

    [HttpPost("register")]
    public async Task<IActionResult> Register(RegisterFcmTokenRequest request)
    {
        if (request.UserId == Guid.Empty)
        {
            return BadRequest(new { message = "Thiếu userId" });
        }

        if (string.IsNullOrWhiteSpace(request.Token))
        {
            return BadRequest(new { message = "Thiếu FCM token" });
        }

        var user = await _context.Users
            .FirstOrDefaultAsync(u => u.Id == request.UserId);

        if (user == null)
        {
            return BadRequest(new { message = "Người dùng không tồn tại" });
        }

        var existing = await _context.UserFcmTokens
            .FirstOrDefaultAsync(x => x.Token == request.Token);

        if (existing == null)
        {
            existing = new UserFcmToken
            {
                UserId = request.UserId,
                Token = request.Token,
                Platform = request.Platform,
                DeviceId = request.DeviceId,
                IsActive = true,
                CreatedAt = DateTime.UtcNow,
                UpdatedAt = DateTime.UtcNow,
                LastUsedAt = DateTime.UtcNow
            };

            _context.UserFcmTokens.Add(existing);
        }
        else
        {
            existing.UserId = request.UserId;
            existing.Platform = request.Platform;
            existing.DeviceId = request.DeviceId;
            existing.IsActive = true;
            existing.UpdatedAt = DateTime.UtcNow;
            existing.LastUsedAt = DateTime.UtcNow;
        }

        await _context.SaveChangesAsync();

        return Ok(new
        {
            message = "Đã lưu FCM token",
            existing.UserId,
            existing.Platform
        });
    }
}

public class RegisterFcmTokenRequest
{
    public Guid UserId { get; set; }

    public string Token { get; set; } = string.Empty;

    public string? Platform { get; set; }

    public string? DeviceId { get; set; }
}