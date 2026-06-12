using System;
using System.Collections.Generic;

namespace Care4U.Api.Models;

public partial class Prescription
{
    public int Id { get; set; }

    public int MedicalRecordId { get; set; }

    public int DoctorId { get; set; }

    public int PatientId { get; set; }

    public string PrescriptionNo { get; set; } = null!;

    public DateOnly DateIssued { get; set; }

    public DateOnly? ValidUntil { get; set; }

    public string Status { get; set; } = null!;

    public string? PharmacistNotes { get; set; }

    public string? Notes { get; set; }

    public DateTime CreatedAt { get; set; }

    public DateTime UpdatedAt { get; set; }

    public virtual Doctor Doctor { get; set; } = null!;

    public virtual MedicalRecord MedicalRecord { get; set; } = null!;

    public virtual Patient Patient { get; set; } = null!;

    public virtual ICollection<PrescriptionItem> PrescriptionItems { get; set; } = new List<PrescriptionItem>();
}
