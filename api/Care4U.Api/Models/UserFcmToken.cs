using System;

namespace Care4U.Api.Models;

public partial class UserFcmToken
{
    public int Id { get; set; }

    public Guid UserId { get; set; }

    public string Token { get; set; } = null!;

    public string? Platform { get; set; }

    public string? DeviceId { get; set; }

    public bool IsActive { get; set; } = true;

    public DateTime CreatedAt { get; set; }

    public DateTime UpdatedAt { get; set; }

    public DateTime? LastUsedAt { get; set; }

    public virtual User User { get; set; } = null!;
}