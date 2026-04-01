import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/shared/mock/mock_data.dart';
import 'package:care4u_medical_booking/core/constants/app_translations.dart';
import '../widgets/appointment_card.dart';
import '../models/appointment_status.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  AppointmentStatus _mapStatus(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
      case 'pending':
      case 'upcoming':
        return AppointmentStatus.upcoming;
      case 'completed':
        return AppointmentStatus.completed;
      case 'cancelled':
        return AppointmentStatus.cancelled;
      default:
        return AppointmentStatus.upcoming;
    }
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppTranslations.tr('nav_appointments')),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(text: AppTranslations.tr('upcoming')),
              Tab(text: AppTranslations.tr('completed')),
              Tab(text: AppTranslations.tr('cancelled')),
            ],
            indicatorColor: Theme.of(context).primaryColor,
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.grey,
          ),
        ),
        body: TabBarView(
          children: [
            _buildAppointmentList(AppointmentStatus.upcoming),
            _buildAppointmentList(AppointmentStatus.completed),
            _buildAppointmentList(AppointmentStatus.cancelled),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentList(AppointmentStatus status) {
    final filteredList = MockData.appointments.where((app) {
      return _mapStatus(app['status'] as String) == status;
    }).toList();

    if (filteredList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              AppTranslations.tr('no_appointments'),
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 80),
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        return AppointmentCard(
          appointmentData: filteredList[index],
          status: status,
          onRefresh: _refresh,
        );
      },
    );
  }
}