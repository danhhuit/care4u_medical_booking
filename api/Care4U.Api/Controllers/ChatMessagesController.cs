using Care4U.Api.Data;
using Care4U.Api.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace Care4U.Api.Controllers;

public class CreateChatMessageRequest
{
    public Guid RoomId { get; set; }
    public Guid? SenderId { get; set; }
    public string? SenderRole { get; set; }
    public string? Content { get; set; }
    public string? MessageType { get; set; }
    public string? FileUrl { get; set; }
    public string? FileName { get; set; }
    public int? FileSize { get; set; }
}

[ApiController]
[Route("api/[controller]")]
public class ChatMessagesController : ControllerBase
{
    private readonly Care4UDbContext _context;

    public ChatMessagesController(Care4UDbContext context)
    {
        _context = context;
    }

    [HttpGet("room/{roomId:guid}")]
    public async Task<IActionResult> GetByRoom(Guid roomId)
    {
        var roomExists = await _context.ChatRooms.AnyAsync(x => x.Id == roomId);
        if (!roomExists)
        {
            return NotFound(new { message = "Không tìm thấy phòng chat" });
        }

        var data = await _context.ChatMessages
            .AsNoTracking()
            .Include(x => x.Sender)
            .Where(x => x.RoomId == roomId && !x.IsDeleted)
            .OrderBy(x => x.CreatedAt)
            .Select(x => new
            {
                x.Id,
                x.RoomId,
                x.SenderId,
                SenderName = x.Sender.Email,
                SenderRole = x.Sender.Role,
                x.Content,
                x.MessageType,
                x.FileUrl,
                x.FileName,
                x.FileSize,
                x.IsRead,
                x.ReadAt,
                x.IsDeleted,
                x.CreatedAt
            })
            .ToListAsync();

        return Ok(data);
    }

    [HttpPost]
    public async Task<IActionResult> Create(CreateChatMessageRequest request)
    {
        if (request.RoomId == Guid.Empty)
        {
            return BadRequest(new { message = "Thiếu mã phòng chat" });
        }

        if (string.IsNullOrWhiteSpace(request.Content) && string.IsNullOrWhiteSpace(request.FileUrl))
        {
            return BadRequest(new { message = "Tin nhắn không được để trống" });
        }

        var room = await _context.ChatRooms.FirstOrDefaultAsync(x => x.Id == request.RoomId);
        if (room == null)
        {
            return NotFound(new { message = "Không tìm thấy phòng chat" });
        }

        var senderId = request.SenderId.HasValue && request.SenderId.Value != Guid.Empty
            ? request.SenderId.Value
            : await ResolveSenderIdAsync(room, request.SenderRole);

        if (senderId == Guid.Empty)
        {
            return BadRequest(new { message = "Không xác định được người gửi" });
        }

        var sender = await _context.Users
            .Where(x => x.Id == senderId)
            .Select(x => new
            {
                x.Id,
                x.Email,
                x.Role
            })
            .FirstOrDefaultAsync();

        if (sender == null)
        {
            return BadRequest(new { message = "Người gửi không tồn tại" });
        }

        var now = DateTime.UtcNow;
        var message = new ChatMessage
        {
            Id = Guid.NewGuid(),
            RoomId = room.Id,
            SenderId = sender.Id,
            Content = string.IsNullOrWhiteSpace(request.Content) ? null : request.Content.Trim(),
            MessageType = NormalizeMessageType(request.MessageType),
            FileUrl = string.IsNullOrWhiteSpace(request.FileUrl) ? null : request.FileUrl.Trim(),
            FileName = string.IsNullOrWhiteSpace(request.FileName) ? null : request.FileName.Trim(),
            FileSize = request.FileSize,
            IsRead = false,
            IsDeleted = false,
            CreatedAt = now
        };

        _context.ChatMessages.Add(message);
        room.LastMessageAt = now;
        room.UpdatedAt = now;

        await _context.SaveChangesAsync();

        return Ok(new
        {
            message = "Gửi tin nhắn thành công",
            messageId = message.Id,
            message.Id,
            message.RoomId,
            message.SenderId,
            SenderName = sender.Email,
            SenderRole = sender.Role,
            message.Content,
            message.MessageType,
            message.FileUrl,
            message.FileName,
            message.FileSize,
            message.IsRead,
            message.ReadAt,
            message.CreatedAt
        });
    }

    [HttpPut("{id:guid}/read")]
    public async Task<IActionResult> MarkAsRead(Guid id)
    {
        var message = await _context.ChatMessages.FirstOrDefaultAsync(x => x.Id == id);
        if (message == null)
        {
            return NotFound(new { message = "Không tìm thấy tin nhắn" });
        }

        if (!message.IsRead)
        {
            message.IsRead = true;
            message.ReadAt = DateTime.UtcNow;
            await _context.SaveChangesAsync();
        }

        return Ok(new { message = "Đã đánh dấu tin nhắn đã đọc", messageId = id });
    }

    [HttpPut("room/{roomId:guid}/read")]
    public async Task<IActionResult> MarkRoomAsRead(
        Guid roomId,
        [FromQuery] string? readerRole,
        [FromQuery] Guid? readerId)
    {
        var room = await _context.ChatRooms.FirstOrDefaultAsync(x => x.Id == roomId);
        if (room == null)
        {
            return NotFound(new { message = "Không tìm thấy phòng chat" });
        }

        Guid currentReaderId;
        if (readerId.HasValue && readerId.Value != Guid.Empty)
        {
            currentReaderId = readerId.Value;
        }
        else
        {
            currentReaderId = await ResolveSenderIdAsync(room, readerRole);
        }

        if (currentReaderId == Guid.Empty)
        {
            return BadRequest(new { message = "ReaderRole phải là patient hoặc doctor" });
        }

        var messages = await _context.ChatMessages
            .Where(x =>
                x.RoomId == roomId &&
                !x.IsDeleted &&
                !x.IsRead &&
                x.SenderId != currentReaderId)
            .ToListAsync();

        foreach (var item in messages)
        {
            item.IsRead = true;
            item.ReadAt = DateTime.UtcNow;
        }

        await _context.SaveChangesAsync();

        return Ok(new
        {
            message = "Đã đánh dấu tin nhắn của đối phương là đã đọc",
            count = messages.Count
        });
    }

    [HttpDelete("{id:guid}")]
    public async Task<IActionResult> Delete(Guid id)
    {
        var message = await _context.ChatMessages.FirstOrDefaultAsync(x => x.Id == id);
        if (message == null)
        {
            return NotFound(new { message = "Không tìm thấy tin nhắn" });
        }

        message.IsDeleted = true;
        await _context.SaveChangesAsync();

        return Ok(new { message = "Đã xóa tin nhắn" });
    }

    private async Task<Guid> ResolveSenderIdAsync(ChatRoom room, string? role)
    {
        var normalizedRole = (role ?? string.Empty).Trim().ToLower();

        if (normalizedRole == "doctor")
        {
            return await _context.Doctors
                .Where(x => x.Id == room.DoctorId)
                .Select(x => x.UserId)
                .FirstOrDefaultAsync();
        }

        if (normalizedRole == "patient")
        {
            return await _context.Patients
                .Where(x => x.Id == room.PatientId)
                .Select(x => x.UserId)
                .FirstOrDefaultAsync();
        }

        return Guid.Empty;
    }

    private static string NormalizeMessageType(string? type)
    {
        var value = (type ?? string.Empty).Trim().ToLower();
        return value switch
        {
            "image" => "image",
            "file" => "file",
            "prescription" => "prescription",
            "system" => "system",
            _ => "text"
        };
    }
}
