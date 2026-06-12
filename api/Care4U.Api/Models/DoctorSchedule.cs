using System;
using System.Collections.Generic;

namespace Care4U.Api.Models;

public partial class DoctorSchedule
{
    public int Id { get; set; }

    public int DoctorId { get; set; }

    public DateOnly ScheduleDate { get; set; }

    public TimeOnly StartTime { get; set; }

    public TimeOnly EndTime { get; set; }

    // public DateOnly WorkDate { get; set; }

    public int SlotDuration { get; set; }

    public int MaxPatients { get; set; }

    public int BookedCount { get; set; }

    public bool IsAvailable { get; set; }

    public string? Note { get; set; }

    public DateTime CreatedAt { get; set; }

    public DateTime UpdatedAt { get; set; }

    public virtual ICollection<Appointment> Appointments { get; set; } = new List<Appointment>();

    public virtual Doctor Doctor { get; set; } = null!;
}
