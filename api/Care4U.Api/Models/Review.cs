using System;
using System.Collections.Generic;

namespace Care4U.Api.Models;

public partial class Review
{
    public int Id { get; set; }

    public int PatientId { get; set; }

    public int DoctorId { get; set; }

    public Guid AppointmentId { get; set; }

    public short Rating { get; set; }

    public string? Comment { get; set; }

    public bool IsAnonymous { get; set; }

    public bool IsVisible { get; set; }

    public string? Reply { get; set; }

    public DateTime? RepliedAt { get; set; }

    public DateTime CreatedAt { get; set; }

    public DateTime UpdatedAt { get; set; }

    public virtual Appointment Appointment { get; set; } = null!;

    public virtual Doctor Doctor { get; set; } = null!;

    public virtual Patient Patient { get; set; } = null!;
}
