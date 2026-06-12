using System;
using System.Collections.Generic;

namespace Care4U.Api.Models;

public partial class Appointment
{
    public Guid Id { get; set; }

    public int PatientId { get; set; }

    public int DoctorId { get; set; }

    public int ScheduleId { get; set; }

    public string AppointmentNo { get; set; } = null!;

    public string Status { get; set; } = null!;

    public string? Reason { get; set; }

    public string? Notes { get; set; }

    public Guid? CancelledBy { get; set; }

    public string? CancelReason { get; set; }

    public DateTime? CancelledAt { get; set; }

    public DateTime? ConfirmedAt { get; set; }

    public DateTime? CompletedAt { get; set; }

    public DateTime CreatedAt { get; set; }

    public DateTime UpdatedAt { get; set; }

    public virtual User? CancelledByNavigation { get; set; }

    public virtual ICollection<ChatRoom> ChatRooms { get; set; } = new List<ChatRoom>();

    public virtual Doctor Doctor { get; set; } = null!;

    public virtual MedicalRecord? MedicalRecord { get; set; }

    public virtual Patient Patient { get; set; } = null!;

    public virtual ICollection<Payment> Payments { get; set; } = new List<Payment>();

    public virtual Review? Review { get; set; }

    public virtual DoctorSchedule Schedule { get; set; } = null!;
}
