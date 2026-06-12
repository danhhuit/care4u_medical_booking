using System;
using System.Collections.Generic;

namespace Care4U.Api.Models;

public partial class Notification
{
    public Guid Id { get; set; }

    public Guid UserId { get; set; }

    public string Title { get; set; } = null!;

    public string Body { get; set; } = null!;

    public string Type { get; set; } = null!;

    public string? RefType { get; set; }

    public string? RefId { get; set; }

    public bool IsRead { get; set; }

    public DateTime? ReadAt { get; set; }

    public DateTime CreatedAt { get; set; }

    public virtual User User { get; set; } = null!;
}
