class DoctorDetailRouteArgs {
  final String doctorId;

  const DoctorDetailRouteArgs({required this.doctorId});
}

class AppointmentBookingRouteArgs {
  final String? specialtyId;
  final String? doctorId;
  final String? doctorName;

  const AppointmentBookingRouteArgs({
    this.specialtyId,
    this.doctorId,
    this.doctorName,
  });
}
