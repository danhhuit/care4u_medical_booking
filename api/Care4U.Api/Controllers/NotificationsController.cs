using Care4U.Api.Data;
using Care4U.Api.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace Care4U.Api.Controllers;

public class CreateNotificationRequest
{
    public Guid? UserId { get; set; }
    public int? PatientId { get; set; }
    public string Title { get; set; } = null!;
    public string Body { get; set; } = null!;
    public string Type { get; set; } = "info";
    public string? RefType { get; set; }
    public string? RefId { get; set; }
}

[ApiController]
[Route("api/[controller]")]
public class NotificationsController : ControllerBase
{
    private readonly Care4UDbContext _context;

    public NotificationsController(Care4UDbContext context)
    {
        _context = context;
    }

    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        var data = await _context.Notifications
            .OrderByDescending(x => x.CreatedAt)
            .Select(x => new
            {
                x.Id,
                x.UserId,
                x.Title,
                x.Body,
                x.Type,
                x.RefType,
                x.RefId,
                x.IsRead,
                x.ReadAt,
                x.CreatedAt
            })
            .ToListAsync();

        return Ok(data);
    }

    [HttpGet("user/{userId:guid}")]
    public async Task<IActionResult> GetByUser(Guid userId)
    {
        var data = await _context.Notifications
            .Where(x => x.UserId == userId)
            .OrderByDescending(x => x.CreatedAt)
            .Select(x => new
            {
                x.Id,
                x.UserId,
                x.Title,
                x.Body,
                x.Type,
                x.RefType,
                x.RefId,
                x.IsRead,
                x.ReadAt,
                x.CreatedAt
            })
            .ToListAsync();

        return Ok(data);
    }

    [HttpGet("patient/{patientId:int}")]
    public async Task<IActionResult> GetByPatient(int patientId)
    {
        var patient = await _context.Patients
            .AsNoTracking()
            .FirstOrDefaultAsync(x => x.Id == patientId);

        if (patient == null)
        {
            return NotFound(new { message = "Không tìm thấy bệnh nhân" });
        }

        var data = await _context.Notifications
            .Where(x => x.UserId == patient.UserId)
            .OrderByDescending(x => x.CreatedAt)
            .Select(x => new
            {
                x.Id,
                x.UserId,
                x.Title,
                x.Body,
                x.Type,
                x.RefType,
                x.RefId,
                x.IsRead,
                x.ReadAt,
                x.CreatedAt
            })
            .ToListAsync();

        return Ok(data);
    }

    [HttpPost]
    public async Task<IActionResult> Create(CreateNotificationRequest request)
    {
        Guid? userId = request.UserId;

        if (!userId.HasValue && request.PatientId.HasValue)
        {
            var patient = await _context.Patients
                .AsNoTracking()
                .FirstOrDefaultAsync(x => x.Id == request.PatientId.Value);

            if (patient == null)
            {
                return BadRequest(new { message = "Bệnh nhân không tồn tại" });
            }

            userId = patient.UserId;
        }

        if (!userId.HasValue)
        {
            return BadRequest(new { message = "Cần truyền userId hoặc patientId" });
        }

        var userExists = await _context.Users.AnyAsync(x => x.Id == userId.Value);
        if (!userExists)
        {
            return BadRequest(new { message = "Người dùng không tồn tại" });
        }

        var now = DateTime.UtcNow;

        var notification = new Notification
        {
            Id = Guid.NewGuid(),
            UserId = userId.Value,
            Title = request.Title,
            Body = request.Body,
            Type = NormalizeNotificationType(request.Type),
            RefType = request.RefType,
            RefId = request.RefId,
            IsRead = false,
            ReadAt = null,
            CreatedAt = now
        };

        _context.Notifications.Add(notification);
        await _context.SaveChangesAsync();

        return Ok(new
        {
            message = "Tạo thông báo thành công",
            notification.Id,
            notification.UserId,
            notification.Title,
            notification.Body,
            notification.Type,
            notification.RefType,
            notification.RefId,
            notification.IsRead,
            notification.ReadAt,
            notification.CreatedAt
        });
    }

    [HttpPut("{id:guid}/read")]
    public async Task<IActionResult> MarkAsRead(Guid id)
    {
        var notification = await _context.Notifications.FirstOrDefaultAsync(x => x.Id == id);

        if (notification == null)
        {
            return NotFound(new { message = "Không tìm thấy thông báo" });
        }

        if (!notification.IsRead)
        {
            notification.IsRead = true;
            notification.ReadAt = DateTime.UtcNow;
            await _context.SaveChangesAsync();
        }

        return Ok(new
        {
            message = "Đã đánh dấu thông báo là đã đọc",
            notification.Id,
            notification.IsRead,
            notification.ReadAt
        });
    }

    [HttpPut("patient/{patientId:int}/read-all")]
    public async Task<IActionResult> MarkAllAsReadByPatient(int patientId)
    {
        var patient = await _context.Patients
            .AsNoTracking()
            .FirstOrDefaultAsync(x => x.Id == patientId);

        if (patient == null)
        {
            return NotFound(new { message = "Không tìm thấy bệnh nhân" });
        }

        var now = DateTime.UtcNow;

        var unreadNotifications = await _context.Notifications
            .Where(x => x.UserId == patient.UserId && !x.IsRead)
            .ToListAsync();

        foreach (var item in unreadNotifications)
        {
            item.IsRead = true;
            item.ReadAt = now;
        }

        await _context.SaveChangesAsync();

        return Ok(new
        {
            message = "Đã đánh dấu tất cả thông báo là đã đọc",
            count = unreadNotifications.Count
        });
    }

    [HttpDelete("{id:guid}")]
    public async Task<IActionResult> Delete(Guid id)
    {
        var notification = await _context.Notifications.FirstOrDefaultAsync(x => x.Id == id);

        if (notification == null)
        {
            return NotFound(new { message = "Không tìm thấy thông báo" });
        }

        _context.Notifications.Remove(notification);
        await _context.SaveChangesAsync();

        return Ok(new { message = "Xóa thông báo thành công" });
    }
    private static string NormalizeNotificationType(string? type)
    {
        var value = (type ?? "").Trim().ToLower();

        return value switch
        {
            "reminder" => "appointment_reminder",
            "appointment_reminder" => "appointment_reminder",

            "confirmed" => "appointment_confirmed",
            "appointment_confirmed" => "appointment_confirmed",

            "cancelled" => "appointment_cancelled",
            "canceled" => "appointment_cancelled",
            "appointment_cancelled" => "appointment_cancelled",

            "result" => "system",
            "test_result" => "system",

            "message" => "new_message",
            "new_message" => "new_message",

            "prescription" => "prescription_ready",
            "prescription_ready" => "prescription_ready",

            "payment" => "payment_success",
            "payment_success" => "payment_success",

            "order" => "order_update",
            "order_update" => "order_update",

            "review" => "review_reply",
            "review_reply" => "review_reply",

            "system" => "system",

            _ => "system"
        };
    }
}
