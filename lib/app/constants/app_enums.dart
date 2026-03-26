enum UserRole { patient, doctor, admin }

enum AppointmentStatus { pending, confirmed, checkedIn, completed, cancelled }

enum Gender { male, female, other }

enum PaymentMethod { cash, card, momo, bankTransfer }

enum NotificationType {
  appointmentReminder,
  appointmentUpdated,
  paymentSuccess,
  system,
}
