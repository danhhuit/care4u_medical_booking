using System;
using System.Collections.Generic;

namespace Care4U.Api.Models;

public partial class PrescriptionItem
{
    public int Id { get; set; }

    public int PrescriptionId { get; set; }

    public int MedicineId { get; set; }

    public string Dosage { get; set; } = null!;

    public string Frequency { get; set; } = null!;

    public string Duration { get; set; } = null!;

    public int Quantity { get; set; }

    public string? Instructions { get; set; }

    public DateTime CreatedAt { get; set; }

    public virtual Medicine Medicine { get; set; } = null!;

    public virtual Prescription Prescription { get; set; } = null!;
}
