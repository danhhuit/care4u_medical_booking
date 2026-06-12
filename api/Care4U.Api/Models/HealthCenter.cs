using System;
using System.Collections.Generic;

namespace Care4U.Api.Models;

public partial class HealthCenter
{
    public int Id { get; set; }

    public string Name { get; set; } = null!;

    public string Address { get; set; } = null!;

    public string? Ward { get; set; }

    public string? District { get; set; }

    public string City { get; set; } = null!;

    public string? Phone { get; set; }

    public string? Email { get; set; }

    public string? Website { get; set; }

    public decimal? LocationLat { get; set; }

    public decimal? LocationLng { get; set; }

    public string Type { get; set; } = null!;

    public decimal? Rating { get; set; }

    public string? ImageUrl { get; set; }

    public bool IsActive { get; set; }

    public DateTime CreatedAt { get; set; }

    public DateTime UpdatedAt { get; set; }

    public virtual ICollection<Doctor> Doctors { get; set; } = new List<Doctor>();
}
