using System;
using System.Collections.Generic;

namespace Care4U.Api.Models;

public partial class VwDoctorSummary
{
    public int? Id { get; set; }

    public string? FullName { get; set; }

    public string? Title { get; set; }

    public decimal? Rating { get; set; }

    public int? TotalReviews { get; set; }

    public int? ExperienceYears { get; set; }

    public decimal? ConsultationFee { get; set; }

    public bool? IsAvailable { get; set; }

    public string? Specialty { get; set; }

    public string? HealthCenter { get; set; }

    public string? HealthCenterAddress { get; set; }

    public long? TotalCompletedAppointments { get; set; }
}
