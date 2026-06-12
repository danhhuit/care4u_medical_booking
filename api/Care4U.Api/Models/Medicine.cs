using System;
using System.Collections.Generic;

namespace Care4U.Api.Models;

public partial class Medicine
{
    public int Id { get; set; }

    public string Name { get; set; } = null!;

    public string? GenericName { get; set; }

    public string? BrandName { get; set; }

    public string? DrugCode { get; set; }

    public string? Category { get; set; }

    public string? DosageForm { get; set; }

    public string? Strength { get; set; }

    public string? Manufacturer { get; set; }

    public string? Description { get; set; }

    public string? UsageInstructions { get; set; }

    public string? SideEffects { get; set; }

    public string? Contraindications { get; set; }

    public string? StorageConditions { get; set; }

    public decimal? Price { get; set; }

    public string? Unit { get; set; }

    public bool RequiresRx { get; set; }

    public bool IsActive { get; set; }

    public string? ImageUrl { get; set; }

    public DateTime CreatedAt { get; set; }

    public DateTime UpdatedAt { get; set; }

    public virtual ICollection<PrescriptionItem> PrescriptionItems { get; set; } = new List<PrescriptionItem>();
}
