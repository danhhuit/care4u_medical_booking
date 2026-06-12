using Care4U.Api.Data;
using FirebaseAdmin.Messaging;
using Microsoft.EntityFrameworkCore;

namespace Care4U.Api.Services;

public class FcmNotificationService
{
    private readonly Care4UDbContext _context;

    public FcmNotificationService(Care4UDbContext context)
    {
        _context = context;
    }

    public async Task SendToUserAsync(
        Guid userId,
        string title,
        string body,
        Dictionary<string, string>? data = null
    )
    {
        if (FirebaseAdmin.FirebaseApp.DefaultInstance == null)
        {
            return;
        }

        var tokens = await _context.UserFcmTokens
            .Where(x => x.UserId == userId && x.IsActive)
            .Select(x => x.Token)
            .ToListAsync();

        if (tokens.Count == 0)
        {
            return;
        }

        foreach (var token in tokens)
        {
            var message = new Message
            {
                Token = token,
                Notification = new Notification
                {
                    Title = title,
                    Body = body
                },
                Data = data ?? new Dictionary<string, string>(),
                Android = new AndroidConfig
                {
                    Priority = Priority.High,
                    Notification = new AndroidNotification
                    {
                        ChannelId = "care4u_high_importance_channel",
                        Sound = "default"
                    }
                }
            };

            try
            {
                await FirebaseMessaging.DefaultInstance.SendAsync(message);
            }
            catch
            {
                // Demo: bỏ qua token lỗi.
                // Sau này có thể cập nhật is_active = false nếu token hết hạn.
            }
        }
    }
}