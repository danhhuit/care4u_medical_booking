using System;
using System.Collections.Generic;
using Care4U.Api.Models;
using Microsoft.EntityFrameworkCore;

namespace Care4U.Api.Data;
using Care4U.Api.Models;

public partial class Care4UDbContext : DbContext
{
    public Care4UDbContext()
    {
    }

    public Care4UDbContext(DbContextOptions<Care4UDbContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Appointment> Appointments { get; set; }

    public virtual DbSet<ChatMessage> ChatMessages { get; set; }

    public virtual DbSet<ChatRoom> ChatRooms { get; set; }

    public virtual DbSet<Doctor> Doctors { get; set; }

    public virtual DbSet<DoctorSchedule> DoctorSchedules { get; set; }

    public virtual DbSet<HealthCenter> HealthCenters { get; set; }

    public virtual DbSet<MedicalRecord> MedicalRecords { get; set; }

    public virtual DbSet<Medicine> Medicines { get; set; }

    public virtual DbSet<Notification> Notifications { get; set; }

    public virtual DbSet<Order> Orders { get; set; }

    public virtual DbSet<OrderItem> OrderItems { get; set; }

    public virtual DbSet<Patient> Patients { get; set; }

    public virtual DbSet<Payment> Payments { get; set; }

    public virtual DbSet<Prescription> Prescriptions { get; set; }
    public virtual DbSet<UserFcmToken> UserFcmTokens { get; set; }

    public virtual DbSet<PrescriptionItem> PrescriptionItems { get; set; }

    public virtual DbSet<ProductCategory> ProductCategories { get; set; }

    public virtual DbSet<Review> Reviews { get; set; }

    public virtual DbSet<Specialty> Specialties { get; set; }

    public virtual DbSet<StoreProduct> StoreProducts { get; set; }

    public virtual DbSet<User> Users { get; set; }
    
    public virtual DbSet<PasswordResetOtp> PasswordResetOtps { get; set; }

    public virtual DbSet<VwDoctorSummary> VwDoctorSummaries { get; set; }

    public virtual DbSet<VwUpcomingAppointment> VwUpcomingAppointments { get; set; }

//     protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
// #warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see https://go.microsoft.com/fwlink/?LinkId=723263.
//         => optionsBuilder.UseNpgsql("Host=localhost;Port=5432;Database=care4u_db;Username=postgres;Password=123456");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<UserFcmToken>(entity =>
        {
            entity.ToTable("user_fcm_tokens");

            entity.HasKey(e => e.Id);

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.UserId).HasColumnName("user_id");
            entity.Property(e => e.Token).HasColumnName("token");
            entity.Property(e => e.Platform).HasColumnName("platform");
            entity.Property(e => e.DeviceId).HasColumnName("device_id");
            entity.Property(e => e.IsActive).HasColumnName("is_active");
            entity.Property(e => e.CreatedAt).HasColumnName("created_at");
            entity.Property(e => e.UpdatedAt).HasColumnName("updated_at");
            entity.Property(e => e.LastUsedAt).HasColumnName("last_used_at");

            entity.HasIndex(e => e.Token).IsUnique();

            entity.HasOne(e => e.User)
                .WithMany()
                .HasForeignKey(e => e.UserId);
        });
        modelBuilder
            .HasPostgresExtension("pgcrypto")
            .HasPostgresExtension("uuid-ossp");

        modelBuilder.Entity<Appointment>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("appointments_pkey");

            entity.ToTable("appointments");

            entity.HasIndex(e => e.AppointmentNo, "appointments_appointment_no_key").IsUnique();

            entity.HasIndex(e => e.CreatedAt, "idx_apt_created").IsDescending();

            entity.HasIndex(e => e.DoctorId, "idx_apt_doctor");

            entity.HasIndex(e => e.PatientId, "idx_apt_patient");

            entity.HasIndex(e => e.ScheduleId, "idx_apt_schedule");

            entity.HasIndex(e => e.Status, "idx_apt_status");

            entity.Property(e => e.Id)
                .HasDefaultValueSql("uuid_generate_v4()")
                .HasColumnName("id");
            entity.Property(e => e.AppointmentNo)
                .HasMaxLength(20)
                .HasColumnName("appointment_no");
            entity.Property(e => e.CancelReason).HasColumnName("cancel_reason");
            entity.Property(e => e.CancelledAt).HasColumnName("cancelled_at");
            entity.Property(e => e.CancelledBy).HasColumnName("cancelled_by");
            entity.Property(e => e.CompletedAt).HasColumnName("completed_at");
            entity.Property(e => e.ConfirmedAt).HasColumnName("confirmed_at");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("now()")
                .HasColumnName("created_at");
            entity.Property(e => e.DoctorId).HasColumnName("doctor_id");
            entity.Property(e => e.Notes).HasColumnName("notes");
            entity.Property(e => e.PatientId).HasColumnName("patient_id");
            entity.Property(e => e.Reason).HasColumnName("reason");
            entity.Property(e => e.ScheduleId).HasColumnName("schedule_id");
            entity.Property(e => e.Status)
                .HasMaxLength(20)
                .HasDefaultValueSql("'pending'::character varying")
                .HasColumnName("status");
            entity.Property(e => e.UpdatedAt)
                .HasDefaultValueSql("now()")
                .HasColumnName("updated_at");

            entity.HasOne(d => d.CancelledByNavigation).WithMany(p => p.Appointments)
                .HasForeignKey(d => d.CancelledBy)
                .HasConstraintName("appointments_cancelled_by_fkey");

            entity.HasOne(d => d.Doctor).WithMany(p => p.Appointments)
                .HasForeignKey(d => d.DoctorId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("appointments_doctor_id_fkey");

            entity.HasOne(d => d.Patient).WithMany(p => p.Appointments)
                .HasForeignKey(d => d.PatientId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("appointments_patient_id_fkey");

            entity.HasOne(d => d.Schedule).WithMany(p => p.Appointments)
                .HasForeignKey(d => d.ScheduleId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("appointments_schedule_id_fkey");
        });

        modelBuilder.Entity<ChatMessage>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("chat_messages_pkey");

            entity.ToTable("chat_messages");

            entity.HasIndex(e => new { e.RoomId, e.CreatedAt }, "idx_chat_messages_room").IsDescending(false, true);

            entity.HasIndex(e => e.SenderId, "idx_chat_messages_sender");

            entity.HasIndex(e => new { e.RoomId, e.IsRead }, "idx_chat_messages_unread").HasFilter("(is_read = false)");

            entity.Property(e => e.Id)
                .HasDefaultValueSql("uuid_generate_v4()")
                .HasColumnName("id");
            entity.Property(e => e.Content).HasColumnName("content");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("now()")
                .HasColumnName("created_at");
            entity.Property(e => e.FileName).HasColumnName("file_name");
            entity.Property(e => e.FileSize).HasColumnName("file_size");
            entity.Property(e => e.FileUrl).HasColumnName("file_url");
            entity.Property(e => e.IsDeleted).HasColumnName("is_deleted");
            entity.Property(e => e.IsRead).HasColumnName("is_read");
            entity.Property(e => e.MessageType)
                .HasMaxLength(20)
                .HasDefaultValueSql("'text'::character varying")
                .HasColumnName("message_type");
            entity.Property(e => e.ReadAt).HasColumnName("read_at");
            entity.Property(e => e.RoomId).HasColumnName("room_id");
            entity.Property(e => e.SenderId).HasColumnName("sender_id");

            entity.HasOne(d => d.Room).WithMany(p => p.ChatMessages)
                .HasForeignKey(d => d.RoomId)
                .HasConstraintName("chat_messages_room_id_fkey");

            entity.HasOne(d => d.Sender).WithMany(p => p.ChatMessages)
                .HasForeignKey(d => d.SenderId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("chat_messages_sender_id_fkey");
        });

        modelBuilder.Entity<ChatRoom>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("chat_rooms_pkey");

            entity.ToTable("chat_rooms");

            entity.HasIndex(e => new { e.PatientId, e.DoctorId, e.AppointmentId }, "chat_rooms_patient_id_doctor_id_appointment_id_key").IsUnique();

            entity.HasIndex(e => e.DoctorId, "idx_chat_rooms_doctor");

            entity.HasIndex(e => e.PatientId, "idx_chat_rooms_patient");

            entity.Property(e => e.Id)
                .HasDefaultValueSql("uuid_generate_v4()")
                .HasColumnName("id");
            entity.Property(e => e.AppointmentId).HasColumnName("appointment_id");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("now()")
                .HasColumnName("created_at");
            entity.Property(e => e.DoctorId).HasColumnName("doctor_id");
            entity.Property(e => e.LastMessageAt).HasColumnName("last_message_at");
            entity.Property(e => e.PatientId).HasColumnName("patient_id");
            entity.Property(e => e.Status)
                .HasMaxLength(20)
                .HasDefaultValueSql("'active'::character varying")
                .HasColumnName("status");
            entity.Property(e => e.UpdatedAt)
                .HasDefaultValueSql("now()")
                .HasColumnName("updated_at");

            entity.HasOne(d => d.Appointment).WithMany(p => p.ChatRooms)
                .HasForeignKey(d => d.AppointmentId)
                .HasConstraintName("chat_rooms_appointment_id_fkey");

            entity.HasOne(d => d.Doctor).WithMany(p => p.ChatRooms)
                .HasForeignKey(d => d.DoctorId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("chat_rooms_doctor_id_fkey");

            entity.HasOne(d => d.Patient).WithMany(p => p.ChatRooms)
                .HasForeignKey(d => d.PatientId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("chat_rooms_patient_id_fkey");
        });

        modelBuilder.Entity<Doctor>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("doctors_pkey");

            entity.ToTable("doctors");

            entity.HasIndex(e => e.LicenseNumber, "doctors_license_number_key").IsUnique();

            entity.HasIndex(e => e.UserId, "doctors_user_id_key").IsUnique();

            entity.HasIndex(e => e.HealthCenterId, "idx_doctors_health_center");

            entity.HasIndex(e => e.Rating, "idx_doctors_rating").IsDescending();

            entity.HasIndex(e => e.SpecialtyId, "idx_doctors_specialty");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.Achievements).HasColumnName("achievements");
            entity.Property(e => e.AvatarUrl).HasColumnName("avatar_url");
            entity.Property(e => e.Bio).HasColumnName("bio");
            entity.Property(e => e.ConsultationFee)
                .HasPrecision(12, 2)
                .HasDefaultValue(0m)
                .HasColumnName("consultation_fee");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("now()")
                .HasColumnName("created_at");
            entity.Property(e => e.Education).HasColumnName("education");
            entity.Property(e => e.ExperienceYears)
                .HasDefaultValue(0)
                .HasColumnName("experience_years");
            entity.Property(e => e.FullName)
                .HasMaxLength(150)
                .HasColumnName("full_name");
            entity.Property(e => e.HealthCenterId).HasColumnName("health_center_id");
            entity.Property(e => e.IsAvailable)
                .HasDefaultValue(true)
                .HasColumnName("is_available");
            entity.Property(e => e.LicenseNumber)
                .HasMaxLength(50)
                .HasColumnName("license_number");
            entity.Property(e => e.Rating)
                .HasPrecision(3, 2)
                .HasColumnName("rating");
            entity.Property(e => e.SpecialtyId).HasColumnName("specialty_id");
            entity.Property(e => e.Title)
                .HasMaxLength(50)
                .HasDefaultValueSql("'BS'::character varying")
                .HasColumnName("title");
            entity.Property(e => e.TotalReviews).HasColumnName("total_reviews");
            entity.Property(e => e.UpdatedAt)
                .HasDefaultValueSql("now()")
                .HasColumnName("updated_at");
            entity.Property(e => e.UserId).HasColumnName("user_id");

            entity.HasOne(d => d.HealthCenter).WithMany(p => p.Doctors)
                .HasForeignKey(d => d.HealthCenterId)
                .HasConstraintName("doctors_health_center_id_fkey");

            entity.HasOne(d => d.Specialty).WithMany(p => p.Doctors)
                .HasForeignKey(d => d.SpecialtyId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("doctors_specialty_id_fkey");

            entity.HasOne(d => d.User).WithOne(p => p.Doctor)
                .HasForeignKey<Doctor>(d => d.UserId)
                .HasConstraintName("doctors_user_id_fkey");
        });

        modelBuilder.Entity<DoctorSchedule>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("doctor_schedules_pkey");

            entity.ToTable("doctor_schedules");

            entity.HasIndex(e => new { e.DoctorId, e.ScheduleDate, e.StartTime }, "doctor_schedules_doctor_id_schedule_date_start_time_key").IsUnique();

            entity.HasIndex(e => new { e.IsAvailable, e.ScheduleDate }, "idx_schedules_avail");

            entity.HasIndex(e => e.ScheduleDate, "idx_schedules_date");

            entity.HasIndex(e => e.DoctorId, "idx_schedules_doctor");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.BookedCount).HasColumnName("booked_count");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("now()")
                .HasColumnName("created_at");
            entity.Property(e => e.DoctorId).HasColumnName("doctor_id");
            entity.Property(e => e.EndTime).HasColumnName("end_time");
            entity.Property(e => e.IsAvailable)
                .HasDefaultValue(true)
                .HasColumnName("is_available");
            entity.Property(e => e.MaxPatients)
                .HasDefaultValue(1)
                .HasColumnName("max_patients");
            entity.Property(e => e.Note).HasColumnName("note");
            entity.Property(e => e.ScheduleDate).HasColumnName("schedule_date");
            entity.Property(e => e.SlotDuration)
                .HasDefaultValue(30)
                .HasColumnName("slot_duration");
            entity.Property(e => e.StartTime).HasColumnName("start_time");
            entity.Property(e => e.UpdatedAt)
                .HasDefaultValueSql("now()")
                .HasColumnName("updated_at");

            entity.HasOne(d => d.Doctor).WithMany(p => p.DoctorSchedules)
                .HasForeignKey(d => d.DoctorId)
                .HasConstraintName("doctor_schedules_doctor_id_fkey");
        });

        modelBuilder.Entity<HealthCenter>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("health_centers_pkey");

            entity.ToTable("health_centers");

            entity.HasIndex(e => e.City, "idx_hc_city");

            entity.HasIndex(e => e.Type, "idx_hc_type");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.Address).HasColumnName("address");
            entity.Property(e => e.City)
                .HasMaxLength(100)
                .HasDefaultValueSql("'Hồ Chí Minh'::character varying")
                .HasColumnName("city");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("now()")
                .HasColumnName("created_at");
            entity.Property(e => e.District)
                .HasMaxLength(100)
                .HasColumnName("district");
            entity.Property(e => e.Email)
                .HasMaxLength(255)
                .HasColumnName("email");
            entity.Property(e => e.ImageUrl).HasColumnName("image_url");
            entity.Property(e => e.IsActive)
                .HasDefaultValue(true)
                .HasColumnName("is_active");
            entity.Property(e => e.LocationLat)
                .HasPrecision(10, 7)
                .HasColumnName("location_lat");
            entity.Property(e => e.LocationLng)
                .HasPrecision(10, 7)
                .HasColumnName("location_lng");
            entity.Property(e => e.Name)
                .HasMaxLength(200)
                .HasColumnName("name");
            entity.Property(e => e.Phone)
                .HasMaxLength(20)
                .HasColumnName("phone");
            entity.Property(e => e.Rating)
                .HasPrecision(3, 2)
                .HasDefaultValue(0m)
                .HasColumnName("rating");
            entity.Property(e => e.Type)
                .HasMaxLength(50)
                .HasDefaultValueSql("'clinic'::character varying")
                .HasColumnName("type");
            entity.Property(e => e.UpdatedAt)
                .HasDefaultValueSql("now()")
                .HasColumnName("updated_at");
            entity.Property(e => e.Ward)
                .HasMaxLength(100)
                .HasColumnName("ward");
            entity.Property(e => e.Website).HasColumnName("website");
        });

        modelBuilder.Entity<MedicalRecord>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("medical_records_pkey");

            entity.ToTable("medical_records");

            entity.HasIndex(e => e.RecordDate, "idx_mr_date").IsDescending();

            entity.HasIndex(e => e.DoctorId, "idx_mr_doctor");

            entity.HasIndex(e => e.PatientId, "idx_mr_patient");

            entity.HasIndex(e => e.AppointmentId, "medical_records_appointment_id_key").IsUnique();

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.AppointmentId).HasColumnName("appointment_id");
            entity.Property(e => e.Attachments).HasColumnName("attachments");
            entity.Property(e => e.ChiefComplaint).HasColumnName("chief_complaint");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("now()")
                .HasColumnName("created_at");
            entity.Property(e => e.Diagnosis).HasColumnName("diagnosis");
            entity.Property(e => e.DoctorId).HasColumnName("doctor_id");
            entity.Property(e => e.FollowUpDate).HasColumnName("follow_up_date");
            entity.Property(e => e.Icd10Code)
                .HasMaxLength(20)
                .HasColumnName("icd10_code");
            entity.Property(e => e.PatientId).HasColumnName("patient_id");
            entity.Property(e => e.RecordDate)
                .HasDefaultValueSql("CURRENT_DATE")
                .HasColumnName("record_date");
            entity.Property(e => e.Symptoms).HasColumnName("symptoms");
            entity.Property(e => e.TreatmentPlan).HasColumnName("treatment_plan");
            entity.Property(e => e.UpdatedAt)
                .HasDefaultValueSql("now()")
                .HasColumnName("updated_at");
            entity.Property(e => e.VitalSigns)
                .HasColumnType("jsonb")
                .HasColumnName("vital_signs");

            entity.HasOne(d => d.Appointment).WithOne(p => p.MedicalRecord)
                .HasForeignKey<MedicalRecord>(d => d.AppointmentId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("medical_records_appointment_id_fkey");

            entity.HasOne(d => d.Doctor).WithMany(p => p.MedicalRecords)
                .HasForeignKey(d => d.DoctorId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("medical_records_doctor_id_fkey");

            entity.HasOne(d => d.Patient).WithMany(p => p.MedicalRecords)
                .HasForeignKey(d => d.PatientId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("medical_records_patient_id_fkey");
        });

        modelBuilder.Entity<Medicine>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("medicines_pkey");

            entity.ToTable("medicines");

            entity.HasIndex(e => e.Category, "idx_medicines_category");

            entity.HasIndex(e => e.Name, "idx_medicines_name");

            entity.HasIndex(e => e.DrugCode, "medicines_drug_code_key").IsUnique();

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.BrandName)
                .HasMaxLength(200)
                .HasColumnName("brand_name");
            entity.Property(e => e.Category)
                .HasMaxLength(100)
                .HasColumnName("category");
            entity.Property(e => e.Contraindications).HasColumnName("contraindications");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("now()")
                .HasColumnName("created_at");
            entity.Property(e => e.Description).HasColumnName("description");
            entity.Property(e => e.DosageForm)
                .HasMaxLength(50)
                .HasColumnName("dosage_form");
            entity.Property(e => e.DrugCode)
                .HasMaxLength(50)
                .HasColumnName("drug_code");
            entity.Property(e => e.GenericName)
                .HasMaxLength(200)
                .HasColumnName("generic_name");
            entity.Property(e => e.ImageUrl).HasColumnName("image_url");
            entity.Property(e => e.IsActive)
                .HasDefaultValue(true)
                .HasColumnName("is_active");
            entity.Property(e => e.Manufacturer)
                .HasMaxLength(200)
                .HasColumnName("manufacturer");
            entity.Property(e => e.Name)
                .HasMaxLength(200)
                .HasColumnName("name");
            entity.Property(e => e.Price)
                .HasPrecision(12, 2)
                .HasDefaultValue(0m)
                .HasColumnName("price");
            entity.Property(e => e.RequiresRx)
                .HasDefaultValue(true)
                .HasColumnName("requires_rx");
            entity.Property(e => e.SideEffects).HasColumnName("side_effects");
            entity.Property(e => e.StorageConditions).HasColumnName("storage_conditions");
            entity.Property(e => e.Strength)
                .HasMaxLength(50)
                .HasColumnName("strength");
            entity.Property(e => e.Unit)
                .HasMaxLength(20)
                .HasDefaultValueSql("'viên'::character varying")
                .HasColumnName("unit");
            entity.Property(e => e.UpdatedAt)
                .HasDefaultValueSql("now()")
                .HasColumnName("updated_at");
            entity.Property(e => e.UsageInstructions).HasColumnName("usage_instructions");
        });

        modelBuilder.Entity<Notification>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("notifications_pkey");

            entity.ToTable("notifications");

            entity.HasIndex(e => new { e.UserId, e.IsRead }, "idx_notif_unread").HasFilter("(is_read = false)");

            entity.HasIndex(e => new { e.UserId, e.CreatedAt }, "idx_notif_user").IsDescending(false, true);

            entity.Property(e => e.Id)
                .HasDefaultValueSql("uuid_generate_v4()")
                .HasColumnName("id");
            entity.Property(e => e.Body).HasColumnName("body");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("now()")
                .HasColumnName("created_at");
            entity.Property(e => e.IsRead).HasColumnName("is_read");
            entity.Property(e => e.ReadAt).HasColumnName("read_at");
            entity.Property(e => e.RefId).HasColumnName("ref_id");
            entity.Property(e => e.RefType)
                .HasMaxLength(50)
                .HasColumnName("ref_type");
            entity.Property(e => e.Title)
                .HasMaxLength(200)
                .HasColumnName("title");
            entity.Property(e => e.Type)
                .HasMaxLength(50)
                .HasColumnName("type");
            entity.Property(e => e.UserId).HasColumnName("user_id");

            entity.HasOne(d => d.User).WithMany(p => p.Notifications)
                .HasForeignKey(d => d.UserId)
                .HasConstraintName("notifications_user_id_fkey");
        });

        modelBuilder.Entity<Order>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("orders_pkey");

            entity.ToTable("orders");

            entity.HasIndex(e => e.PatientId, "idx_orders_patient");

            entity.HasIndex(e => e.Status, "idx_orders_status");

            entity.HasIndex(e => e.OrderNo, "orders_order_no_key").IsUnique();

            entity.Property(e => e.Id)
                .HasDefaultValueSql("uuid_generate_v4()")
                .HasColumnName("id");
            entity.Property(e => e.CancelReason).HasColumnName("cancel_reason");
            entity.Property(e => e.CancelledAt).HasColumnName("cancelled_at");
            entity.Property(e => e.ConfirmedAt).HasColumnName("confirmed_at");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("now()")
                .HasColumnName("created_at");
            entity.Property(e => e.DeliveredAt).HasColumnName("delivered_at");
            entity.Property(e => e.Discount)
                .HasPrecision(14, 2)
                .HasColumnName("discount");
            entity.Property(e => e.OrderNo)
                .HasMaxLength(30)
                .HasColumnName("order_no");
            entity.Property(e => e.PatientId).HasColumnName("patient_id");
            entity.Property(e => e.ShippingAddress).HasColumnName("shipping_address");
            entity.Property(e => e.ShippingFee)
                .HasPrecision(14, 2)
                .HasColumnName("shipping_fee");
            entity.Property(e => e.ShippingName)
                .HasMaxLength(150)
                .HasColumnName("shipping_name");
            entity.Property(e => e.ShippingNote).HasColumnName("shipping_note");
            entity.Property(e => e.ShippingPhone)
                .HasMaxLength(20)
                .HasColumnName("shipping_phone");
            entity.Property(e => e.Status)
                .HasMaxLength(20)
                .HasDefaultValueSql("'pending'::character varying")
                .HasColumnName("status");
            entity.Property(e => e.Subtotal)
                .HasPrecision(14, 2)
                .HasColumnName("subtotal");
            entity.Property(e => e.TotalAmount)
                .HasPrecision(14, 2)
                .HasColumnName("total_amount");
            entity.Property(e => e.UpdatedAt)
                .HasDefaultValueSql("now()")
                .HasColumnName("updated_at");

            entity.HasOne(d => d.Patient).WithMany(p => p.Orders)
                .HasForeignKey(d => d.PatientId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("orders_patient_id_fkey");
        });

        modelBuilder.Entity<OrderItem>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("order_items_pkey");

            entity.ToTable("order_items");

            entity.HasIndex(e => e.OrderId, "idx_order_items_order");

            entity.HasIndex(e => e.ProductId, "idx_order_items_product");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("now()")
                .HasColumnName("created_at");
            entity.Property(e => e.OrderId).HasColumnName("order_id");
            entity.Property(e => e.PriceAtPurchase)
                .HasPrecision(14, 2)
                .HasColumnName("price_at_purchase");
            entity.Property(e => e.ProductId).HasColumnName("product_id");
            entity.Property(e => e.Quantity).HasColumnName("quantity");
            entity.Property(e => e.Subtotal)
                .HasPrecision(14, 2)
                .HasComputedColumnSql("((quantity)::numeric * price_at_purchase)", true)
                .HasColumnName("subtotal");

            entity.HasOne(d => d.Order).WithMany(p => p.OrderItems)
                .HasForeignKey(d => d.OrderId)
                .HasConstraintName("order_items_order_id_fkey");

            entity.HasOne(d => d.Product).WithMany(p => p.OrderItems)
                .HasForeignKey(d => d.ProductId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("order_items_product_id_fkey");
        });

        modelBuilder.Entity<Patient>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("patients_pkey");

            entity.ToTable("patients");

            entity.HasIndex(e => e.Phone, "idx_patients_phone");

            entity.HasIndex(e => e.UserId, "idx_patients_user_id");

            entity.HasIndex(e => e.Phone, "patients_phone_key").IsUnique();

            entity.HasIndex(e => e.UserId, "patients_user_id_key").IsUnique();

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.Address).HasColumnName("address");
            entity.Property(e => e.Allergies).HasColumnName("allergies");
            entity.Property(e => e.AvatarUrl).HasColumnName("avatar_url");
            entity.Property(e => e.BloodType)
                .HasMaxLength(5)
                .HasColumnName("blood_type");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("now()")
                .HasColumnName("created_at");
            entity.Property(e => e.Dob).HasColumnName("dob");
            entity.Property(e => e.EmergencyContactName)
                .HasMaxLength(150)
                .HasColumnName("emergency_contact_name");
            entity.Property(e => e.EmergencyContactPhone)
                .HasMaxLength(20)
                .HasColumnName("emergency_contact_phone");
            entity.Property(e => e.FullName)
                .HasMaxLength(150)
                .HasColumnName("full_name");
            entity.Property(e => e.Gender)
                .HasMaxLength(1)
                .HasColumnName("gender");
            entity.Property(e => e.Phone)
                .HasMaxLength(20)
                .HasColumnName("phone");
            entity.Property(e => e.UpdatedAt)
                .HasDefaultValueSql("now()")
                .HasColumnName("updated_at");
            entity.Property(e => e.UserId).HasColumnName("user_id");

            entity.HasOne(d => d.User).WithOne(p => p.Patient)
                .HasForeignKey<Patient>(d => d.UserId)
                .HasConstraintName("patients_user_id_fkey");
        });

        modelBuilder.Entity<Payment>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("payments_pkey");

            entity.ToTable("payments");

            entity.HasIndex(e => e.Status, "idx_payments_status");

            entity.HasIndex(e => e.Type, "idx_payments_type");

            entity.HasIndex(e => e.UserId, "idx_payments_user");

            entity.HasIndex(e => e.PaymentNo, "payments_payment_no_key").IsUnique();

            entity.Property(e => e.Id)
                .HasDefaultValueSql("uuid_generate_v4()")
                .HasColumnName("id");
            entity.Property(e => e.Amount)
                .HasPrecision(14, 2)
                .HasColumnName("amount");
            entity.Property(e => e.AppointmentId).HasColumnName("appointment_id");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("now()")
                .HasColumnName("created_at");
            entity.Property(e => e.Currency)
                .HasMaxLength(3)
                .HasDefaultValueSql("'VND'::bpchar")
                .IsFixedLength()
                .HasColumnName("currency");
            entity.Property(e => e.Discount)
                .HasPrecision(14, 2)
                .HasDefaultValue(0m)
                .HasColumnName("discount");
            entity.Property(e => e.FinalAmount)
                .HasPrecision(14, 2)
                .HasComputedColumnSql("(amount - discount)", true)
                .HasColumnName("final_amount");
            entity.Property(e => e.GatewayResponse)
                .HasColumnType("jsonb")
                .HasColumnName("gateway_response");
            entity.Property(e => e.OrderId).HasColumnName("order_id");
            entity.Property(e => e.PaidAt).HasColumnName("paid_at");
            entity.Property(e => e.PaymentMethod)
                .HasMaxLength(30)
                .HasColumnName("payment_method");
            entity.Property(e => e.PaymentNo)
                .HasMaxLength(30)
                .HasColumnName("payment_no");
            entity.Property(e => e.Status)
                .HasMaxLength(20)
                .HasDefaultValueSql("'pending'::character varying")
                .HasColumnName("status");
            entity.Property(e => e.TransactionRef)
                .HasMaxLength(100)
                .HasColumnName("transaction_ref");
            entity.Property(e => e.Type)
                .HasMaxLength(20)
                .HasColumnName("type");
            entity.Property(e => e.UpdatedAt)
                .HasDefaultValueSql("now()")
                .HasColumnName("updated_at");
            entity.Property(e => e.UserId).HasColumnName("user_id");

            entity.HasOne(d => d.Appointment).WithMany(p => p.Payments)
                .HasForeignKey(d => d.AppointmentId)
                .HasConstraintName("payments_appointment_id_fkey");

            entity.HasOne(d => d.Order).WithMany(p => p.Payments)
                .HasForeignKey(d => d.OrderId)
                .HasConstraintName("fk_payments_order");

            entity.HasOne(d => d.User).WithMany(p => p.Payments)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("payments_user_id_fkey");
        });

        modelBuilder.Entity<Prescription>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("prescriptions_pkey");

            entity.ToTable("prescriptions");

            entity.HasIndex(e => e.DoctorId, "idx_rx_doctor");

            entity.HasIndex(e => e.PatientId, "idx_rx_patient");

            entity.HasIndex(e => e.Status, "idx_rx_status");

            entity.HasIndex(e => e.MedicalRecordId, "prescriptions_medical_record_id_key").IsUnique();

            entity.HasIndex(e => e.PrescriptionNo, "prescriptions_prescription_no_key").IsUnique();

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("now()")
                .HasColumnName("created_at");
            entity.Property(e => e.DateIssued)
                .HasDefaultValueSql("CURRENT_DATE")
                .HasColumnName("date_issued");
            entity.Property(e => e.DoctorId).HasColumnName("doctor_id");
            entity.Property(e => e.MedicalRecordId).HasColumnName("medical_record_id");
            entity.Property(e => e.Notes).HasColumnName("notes");
            entity.Property(e => e.PatientId).HasColumnName("patient_id");
            entity.Property(e => e.PharmacistNotes).HasColumnName("pharmacist_notes");
            entity.Property(e => e.PrescriptionNo)
                .HasMaxLength(30)
                .HasColumnName("prescription_no");
            entity.Property(e => e.Status)
                .HasMaxLength(20)
                .HasDefaultValueSql("'active'::character varying")
                .HasColumnName("status");
            entity.Property(e => e.UpdatedAt)
                .HasDefaultValueSql("now()")
                .HasColumnName("updated_at");
            entity.Property(e => e.ValidUntil).HasColumnName("valid_until");

            entity.HasOne(d => d.Doctor).WithMany(p => p.Prescriptions)
                .HasForeignKey(d => d.DoctorId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("prescriptions_doctor_id_fkey");

            entity.HasOne(d => d.MedicalRecord).WithOne(p => p.Prescription)
                .HasForeignKey<Prescription>(d => d.MedicalRecordId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("prescriptions_medical_record_id_fkey");

            entity.HasOne(d => d.Patient).WithMany(p => p.Prescriptions)
                .HasForeignKey(d => d.PatientId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("prescriptions_patient_id_fkey");
        });

        modelBuilder.Entity<PrescriptionItem>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("prescription_items_pkey");

            entity.ToTable("prescription_items");

            entity.HasIndex(e => e.PrescriptionId, "idx_rx_items_prescription");

            entity.HasIndex(e => new { e.PrescriptionId, e.MedicineId }, "prescription_items_prescription_id_medicine_id_key").IsUnique();

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("now()")
                .HasColumnName("created_at");
            entity.Property(e => e.Dosage)
                .HasMaxLength(100)
                .HasColumnName("dosage");
            entity.Property(e => e.Duration)
                .HasMaxLength(100)
                .HasColumnName("duration");
            entity.Property(e => e.Frequency)
                .HasMaxLength(100)
                .HasColumnName("frequency");
            entity.Property(e => e.Instructions).HasColumnName("instructions");
            entity.Property(e => e.MedicineId).HasColumnName("medicine_id");
            entity.Property(e => e.PrescriptionId).HasColumnName("prescription_id");
            entity.Property(e => e.Quantity)
                .HasDefaultValue(1)
                .HasColumnName("quantity");

            entity.HasOne(d => d.Medicine).WithMany(p => p.PrescriptionItems)
                .HasForeignKey(d => d.MedicineId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("prescription_items_medicine_id_fkey");

            entity.HasOne(d => d.Prescription).WithMany(p => p.PrescriptionItems)
                .HasForeignKey(d => d.PrescriptionId)
                .HasConstraintName("prescription_items_prescription_id_fkey");
        });

        modelBuilder.Entity<ProductCategory>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("product_categories_pkey");

            entity.ToTable("product_categories");

            entity.HasIndex(e => e.Name, "product_categories_name_key").IsUnique();

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("now()")
                .HasColumnName("created_at");
            entity.Property(e => e.Description).HasColumnName("description");
            entity.Property(e => e.IconUrl).HasColumnName("icon_url");
            entity.Property(e => e.IsActive)
                .HasDefaultValue(true)
                .HasColumnName("is_active");
            entity.Property(e => e.Name)
                .HasMaxLength(100)
                .HasColumnName("name");
            entity.Property(e => e.ParentId).HasColumnName("parent_id");

            entity.HasOne(d => d.Parent).WithMany(p => p.InverseParent)
                .HasForeignKey(d => d.ParentId)
                .HasConstraintName("product_categories_parent_id_fkey");
        });

        modelBuilder.Entity<Review>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("reviews_pkey");

            entity.ToTable("reviews");

            entity.HasIndex(e => e.DoctorId, "idx_reviews_doctor");

            entity.HasIndex(e => e.PatientId, "idx_reviews_patient");

            entity.HasIndex(e => e.Rating, "idx_reviews_rating");

            entity.HasIndex(e => e.AppointmentId, "reviews_appointment_id_key").IsUnique();

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.AppointmentId).HasColumnName("appointment_id");
            entity.Property(e => e.Comment).HasColumnName("comment");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("now()")
                .HasColumnName("created_at");
            entity.Property(e => e.DoctorId).HasColumnName("doctor_id");
            entity.Property(e => e.IsAnonymous).HasColumnName("is_anonymous");
            entity.Property(e => e.IsVisible)
                .HasDefaultValue(true)
                .HasColumnName("is_visible");
            entity.Property(e => e.PatientId).HasColumnName("patient_id");
            entity.Property(e => e.Rating).HasColumnName("rating");
            entity.Property(e => e.RepliedAt).HasColumnName("replied_at");
            entity.Property(e => e.Reply).HasColumnName("reply");
            entity.Property(e => e.UpdatedAt)
                .HasDefaultValueSql("now()")
                .HasColumnName("updated_at");

            entity.HasOne(d => d.Appointment).WithOne(p => p.Review)
                .HasForeignKey<Review>(d => d.AppointmentId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("reviews_appointment_id_fkey");

            entity.HasOne(d => d.Doctor).WithMany(p => p.Reviews)
                .HasForeignKey(d => d.DoctorId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("reviews_doctor_id_fkey");

            entity.HasOne(d => d.Patient).WithMany(p => p.Reviews)
                .HasForeignKey(d => d.PatientId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("reviews_patient_id_fkey");
        });

        modelBuilder.Entity<Specialty>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("specialties_pkey");

            entity.ToTable("specialties");

            entity.HasIndex(e => e.Name, "specialties_name_key").IsUnique();

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("now()")
                .HasColumnName("created_at");
            entity.Property(e => e.Description).HasColumnName("description");
            entity.Property(e => e.IconUrl).HasColumnName("icon_url");
            entity.Property(e => e.IsActive)
                .HasDefaultValue(true)
                .HasColumnName("is_active");
            entity.Property(e => e.Name)
                .HasMaxLength(100)
                .HasColumnName("name");
            entity.Property(e => e.UpdatedAt)
                .HasDefaultValueSql("now()")
                .HasColumnName("updated_at");
        });

        modelBuilder.Entity<StoreProduct>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("store_products_pkey");

            entity.ToTable("store_products");

            entity.HasIndex(e => e.CategoryId, "idx_products_category");

            entity.HasIndex(e => e.Price, "idx_products_price");

            entity.HasIndex(e => e.Rating, "idx_products_rating").IsDescending();

            entity.HasIndex(e => e.Sku, "store_products_sku_key").IsUnique();

            entity.HasIndex(e => e.Slug, "store_products_slug_key").IsUnique();

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.Brand)
                .HasMaxLength(100)
                .HasColumnName("brand");
            entity.Property(e => e.CategoryId).HasColumnName("category_id");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("now()")
                .HasColumnName("created_at");
            entity.Property(e => e.Description).HasColumnName("description");
            entity.Property(e => e.ImageUrl).HasColumnName("image_url");
            entity.Property(e => e.Images).HasColumnName("images");
            entity.Property(e => e.IsActive)
                .HasDefaultValue(true)
                .HasColumnName("is_active");
            entity.Property(e => e.Name)
                .HasMaxLength(200)
                .HasColumnName("name");
            entity.Property(e => e.Origin)
                .HasMaxLength(100)
                .HasColumnName("origin");
            entity.Property(e => e.Price)
                .HasPrecision(14, 2)
                .HasColumnName("price");
            entity.Property(e => e.Rating)
                .HasPrecision(3, 2)
                .HasDefaultValue(0m)
                .HasColumnName("rating");
            entity.Property(e => e.SalePrice)
                .HasPrecision(14, 2)
                .HasColumnName("sale_price");
            entity.Property(e => e.ShortDesc).HasColumnName("short_desc");
            entity.Property(e => e.Sku)
                .HasMaxLength(50)
                .HasColumnName("sku");
            entity.Property(e => e.Slug)
                .HasMaxLength(200)
                .HasColumnName("slug");
            entity.Property(e => e.StockQuantity).HasColumnName("stock_quantity");
            entity.Property(e => e.TotalSold).HasColumnName("total_sold");
            entity.Property(e => e.Unit)
                .HasMaxLength(20)
                .HasDefaultValueSql("'cái'::character varying")
                .HasColumnName("unit");
            entity.Property(e => e.UpdatedAt)
                .HasDefaultValueSql("now()")
                .HasColumnName("updated_at");

            entity.HasOne(d => d.Category).WithMany(p => p.StoreProducts)
                .HasForeignKey(d => d.CategoryId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("store_products_category_id_fkey");
        });

        modelBuilder.Entity<User>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("users_pkey");

            entity.ToTable("users");

            entity.HasIndex(e => e.Email, "idx_users_email");

            entity.HasIndex(e => e.Role, "idx_users_role");

            entity.HasIndex(e => e.Email, "users_email_key").IsUnique();

            entity.Property(e => e.Phone)
                    .HasMaxLength(20)
                    .HasColumnName("phone");

            entity.Property(e => e.Id)
                .HasDefaultValueSql("uuid_generate_v4()")
                .HasColumnName("id");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("now()")
                .HasColumnName("created_at");
            entity.Property(e => e.Email)
                .HasMaxLength(255)
                .HasColumnName("email");
            entity.Property(e => e.IsActive)
                .HasDefaultValue(true)
                .HasColumnName("is_active");
            entity.Property(e => e.IsVerified).HasColumnName("is_verified");
            entity.Property(e => e.LastLoginAt).HasColumnName("last_login_at");
            entity.Property(e => e.PasswordHash).HasColumnName("password_hash");
            entity.Property(e => e.Role)
                .HasMaxLength(20)
                .HasColumnName("role");
            entity.Property(e => e.UpdatedAt)
                .HasDefaultValueSql("now()")
                .HasColumnName("updated_at");
        });

        modelBuilder.Entity<VwDoctorSummary>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("vw_doctor_summary");

            entity.Property(e => e.ConsultationFee)
                .HasPrecision(12, 2)
                .HasColumnName("consultation_fee");
            entity.Property(e => e.ExperienceYears).HasColumnName("experience_years");
            entity.Property(e => e.FullName)
                .HasMaxLength(150)
                .HasColumnName("full_name");
            entity.Property(e => e.HealthCenter)
                .HasMaxLength(200)
                .HasColumnName("health_center");
            entity.Property(e => e.HealthCenterAddress).HasColumnName("health_center_address");
            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.IsAvailable).HasColumnName("is_available");
            entity.Property(e => e.Rating)
                .HasPrecision(3, 2)
                .HasColumnName("rating");
            entity.Property(e => e.Specialty)
                .HasMaxLength(100)
                .HasColumnName("specialty");
            entity.Property(e => e.Title)
                .HasMaxLength(50)
                .HasColumnName("title");
            entity.Property(e => e.TotalCompletedAppointments).HasColumnName("total_completed_appointments");
            entity.Property(e => e.TotalReviews).HasColumnName("total_reviews");
        });

        modelBuilder.Entity<VwUpcomingAppointment>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("vw_upcoming_appointments");

            entity.Property(e => e.AppointmentNo)
                .HasMaxLength(20)
                .HasColumnName("appointment_no");
            entity.Property(e => e.CreatedAt).HasColumnName("created_at");
            entity.Property(e => e.DoctorName)
                .HasMaxLength(150)
                .HasColumnName("doctor_name");
            entity.Property(e => e.DoctorTitle)
                .HasMaxLength(50)
                .HasColumnName("doctor_title");
            entity.Property(e => e.EndTime).HasColumnName("end_time");
            entity.Property(e => e.HealthCenterName)
                .HasMaxLength(200)
                .HasColumnName("health_center_name");
            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.PatientName)
                .HasMaxLength(150)
                .HasColumnName("patient_name");
            entity.Property(e => e.PatientPhone)
                .HasMaxLength(20)
                .HasColumnName("patient_phone");
            entity.Property(e => e.Reason).HasColumnName("reason");
            entity.Property(e => e.ScheduleDate).HasColumnName("schedule_date");
            entity.Property(e => e.SpecialtyName)
                .HasMaxLength(100)
                .HasColumnName("specialty_name");
            entity.Property(e => e.StartTime).HasColumnName("start_time");
            entity.Property(e => e.Status)
                .HasMaxLength(20)
                .HasColumnName("status");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
