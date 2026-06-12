using System;
using System.Collections.Generic;

namespace Care4U.Api.Models;

public partial class Doctor
{
    public int Id { get; set; }

    public Guid UserId { get; set; }

    public int SpecialtyId { get; set; }

    public int? HealthCenterId { get; set; }

    public string FullName { get; set; } = null!;

    public string? Title { get; set; }

    public string? LicenseNumber { get; set; }

    public int? ExperienceYears { get; set; }

    public decimal? ConsultationFee { get; set; }

    public string? Bio { get; set; }

    public string? Education { get; set; }

    public string? Achievements { get; set; }

    public decimal Rating { get; set; }

    public int TotalReviews { get; set; }

    public string? AvatarUrl { get; set; }

    public bool IsAvailable { get; set; }

    public DateTime CreatedAt { get; set; }

    public DateTime UpdatedAt { get; set; }

    public virtual ICollection<Appointment> Appointments { get; set; } = new List<Appointment>();

    public virtual ICollection<ChatRoom> ChatRooms { get; set; } = new List<ChatRoom>();

    public virtual ICollection<DoctorSchedule> DoctorSchedules { get; set; } = new List<DoctorSchedule>();

    public virtual HealthCenter? HealthCenter { get; set; }

    public virtual ICollection<MedicalRecord> MedicalRecords { get; set; } = new List<MedicalRecord>();

    public virtual ICollection<Prescription> Prescriptions { get; set; } = new List<Prescription>();

    public virtual ICollection<Review> Reviews { get; set; } = new List<Review>();

    public virtual Specialty Specialty { get; set; } = null!;

    public virtual User User { get; set; } = null!;
}
