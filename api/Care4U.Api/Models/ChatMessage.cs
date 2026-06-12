using System;
using System.Collections.Generic;

namespace Care4U.Api.Models;

public partial class ChatMessage
{
    public Guid Id { get; set; }

    public Guid RoomId { get; set; }

    public Guid SenderId { get; set; }

    public string? Content { get; set; }

    public string MessageType { get; set; } = null!;

    public string? FileUrl { get; set; }

    public string? FileName { get; set; }

    public int? FileSize { get; set; }

    public bool IsRead { get; set; }

    public DateTime? ReadAt { get; set; }

    public bool IsDeleted { get; set; }

    public DateTime CreatedAt { get; set; }

    public virtual ChatRoom Room { get; set; } = null!;

    public virtual User Sender { get; set; } = null!;
}
