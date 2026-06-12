using System;
using System.Collections.Generic;

namespace Care4U.Api.Models;

public partial class MedicalRecord
{
    public int Id { get; set; }

    public Guid AppointmentId { get; set; }

    public int PatientId { get; set; }

    public int DoctorId { get; set; }

    public DateOnly RecordDate { get; set; }

    public string ChiefComplaint { get; set; } = null!;

    public string? Symptoms { get; set; }

    public string Diagnosis { get; set; } = null!;

    public string? Icd10Code { get; set; }

    public string? TreatmentPlan { get; set; }

    public DateOnly? FollowUpDate { get; set; }

    public string? VitalSigns { get; set; }

    public List<string>? Attachments { get; set; }

    public DateTime CreatedAt { get; set; }

    public DateTime UpdatedAt { get; set; }

    public virtual Appointment Appointment { get; set; } = null!;

    public virtual Doctor Doctor { get; set; } = null!;

    public virtual Patient Patient { get; set; } = null!;

    public virtual Prescription? Prescription { get; set; }
}
