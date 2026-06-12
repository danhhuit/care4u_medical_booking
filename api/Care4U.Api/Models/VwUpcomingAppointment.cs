using System;
using System.Collections.Generic;

namespace Care4U.Api.Models;

public partial class VwUpcomingAppointment
{
    public Guid? Id { get; set; }

    public string? AppointmentNo { get; set; }

    public string? Status { get; set; }

    public string? Reason { get; set; }

    public string? PatientName { get; set; }

    public string? PatientPhone { get; set; }

    public string? DoctorName { get; set; }

    public string? DoctorTitle { get; set; }

    public string? SpecialtyName { get; set; }

    public string? HealthCenterName { get; set; }

    public DateOnly? ScheduleDate { get; set; }

    public TimeOnly? StartTime { get; set; }

    public TimeOnly? EndTime { get; set; }

    public DateTime? CreatedAt { get; set; }
}
