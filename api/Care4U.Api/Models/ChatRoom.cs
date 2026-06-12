using System;
using System.Collections.Generic;

namespace Care4U.Api.Models;

public partial class ChatRoom
{
    public Guid Id { get; set; }

    public int PatientId { get; set; }

    public int DoctorId { get; set; }

    public Guid? AppointmentId { get; set; }

    public string Status { get; set; } = null!;

    public DateTime? LastMessageAt { get; set; }

    public DateTime CreatedAt { get; set; }

    public DateTime UpdatedAt { get; set; }

    public virtual Appointment? Appointment { get; set; }

    public virtual ICollection<ChatMessage> ChatMessages { get; set; } = new List<ChatMessage>();

    public virtual Doctor Doctor { get; set; } = null!;

    public virtual Patient Patient { get; set; } = null!;
}
