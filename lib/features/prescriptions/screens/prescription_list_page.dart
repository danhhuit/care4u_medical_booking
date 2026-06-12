// import 'package:flutter/material.dart';
// import 'package:care4u_medical_booking/app/theme/settings_manager.dart';
// import 'package:care4u_medical_booking/core/constants/app_translations.dart';
// import 'prescription_detail_page.dart';
// import 'revisit_schedule_page.dart';
// import 'package:care4u_medical_booking/features/store/presentation/screens/product_list_screen.dart';

// class PrescriptionListPage extends StatelessWidget {
//   const PrescriptionListPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder<String>(
//       valueListenable: SettingsManager.languageCode,
//       builder: (context, lang, _) {
//         return ValueListenableBuilder<ThemeMode>(
//           valueListenable: SettingsManager.themeMode,
//           builder: (context, mode, _) {
//             final isDark = Theme.of(context).brightness == Brightness.dark;
//             final cardColor = isDark ? const Color(0xFF1E2022) : Colors.white;
//             final textColor = isDark ? Colors.white : Colors.black;

//             return Scaffold(
//               backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//               appBar: AppBar(
//                 backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
//                 elevation: 0.5,
//                 centerTitle: true,
//                 title: Text(
//                   AppTranslations.tr('prescriptions'),
//                   style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 18),
//                 ),
//                 actions: [
//                   IconButton(
//                     icon: Icon(Icons.shopping_cart, color: textColor),
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => const ProductListScreen()),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//               body: ListView.builder(
//                 padding: const EdgeInsets.all(16),
//                 itemCount: 2,
//                 itemBuilder: (context, index) {
//                   return _buildPrescriptionCard(
//                     context,
//                     title: index == 0 ? AppTranslations.tr('prescription_stomach') : AppTranslations.tr('prescription_throat'),
//                     doctor: index == 0 ? 'BS. Lê Văn B' : 'BS. Phạm Thị Dung',
//                     date: index == 0 ? '25/03/2026' : '10/04/2026',
//                     status: index == 0 ? AppTranslations.tr('active_status') : AppTranslations.tr('done_status'),
//                     isDark: isDark,
//                     cardColor: cardColor,
//                     textColor: textColor,
//                   );
//                 },
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   Widget _buildPrescriptionCard(
//     BuildContext context, {
//     required String title,
//     required String doctor,
//     required String date,
//     required String status,
//     required bool isDark,
//     required Color cardColor,
//     required Color textColor,
//   }) {
//     final statusColor = status == AppTranslations.tr('active_status') ? Colors.green : Colors.grey;
    
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: cardColor,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: isDark ? Colors.black.withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.03),
//             blurRadius: 10,
//           )
//         ],
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   color: Colors.blue.withValues(alpha: 0.1),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: const Icon(Icons.medication_liquid, color: Colors.blue),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor)),
//                     Text('${AppTranslations.tr('doctor_label')}: $doctor', style: const TextStyle(color: Colors.grey, fontSize: 13)),
//                   ],
//                 ),
//               ),
//               Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12)),
//             ],
//           ),
//           const Divider(height: 24, color: Colors.grey),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text('${AppTranslations.tr('date_label') ?? "Ngày kê"}: $date', style: const TextStyle(color: Colors.blueGrey, fontSize: 13)),
//               Row(
//                 children: [
//                   OutlinedButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => const RevisitSchedulePage()),
//                       );
//                     },
//                     style: OutlinedButton.styleFrom(
//                       foregroundColor: Colors.blue,
//                       side: const BorderSide(color: Colors.blue),
//                       padding: const EdgeInsets.symmetric(horizontal: 12),
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                     ),
//                     child: Text(AppTranslations.tr('revisit_schedule')),
//                   ),
//                   const SizedBox(width: 8),
//                   ElevatedButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => const PrescriptionDetailPage()),
//                       );
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue,
//                       foregroundColor: Colors.white,
//                       elevation: 0,
//                       padding: const EdgeInsets.symmetric(horizontal: 12),
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                     ),
//                     child: Text(AppTranslations.tr('see_all') ?? 'Chi tiết'),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
