import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/core/constants/app_translations.dart';

enum RevenuePeriod { day, month, year }

class RevenueChart extends StatelessWidget {
  final List<Map<String, dynamic>> stats;
  final RevenuePeriod period;
  final Color cardColor;
  final Color textColor;
  final Color subTextColor;

  const RevenueChart({
    super.key,
    required this.stats,
    required this.period,
    required this.cardColor,
    required this.textColor,
    required this.subTextColor,
  });

  String _formatMoneyShort(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    }
    if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}K';
    }
    return amount.toInt().toString();
  }

  String _axisLabel(String key) {
    if (period == RevenuePeriod.year) return key;
    if (period == RevenuePeriod.month) {
      final parts = key.split('-');
      if (parts.length >= 2) return '${parts[1]}/${parts[0].substring(2)}';
    }
    final parts = key.split('-');
    if (parts.length == 3) return '${parts[2]}/${parts[1]}';
    return key;
  }

  List<Map<String, dynamic>> get _chartData {
    final sorted = List<Map<String, dynamic>>.from(stats)
      ..sort((a, b) => '${a['date']}'.compareTo('${b['date']}'));
    if (sorted.length <= 12) return sorted;
    return sorted.sublist(sorted.length - 12);
  }

  @override
  Widget build(BuildContext context) {
    if (_chartData.isEmpty) {
      return Card(
        color: cardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: subTextColor.withValues(alpha: 0.15)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: Center(
            child: Text(
              AppTranslations.tr('no_revenue_data'),
              style: TextStyle(color: subTextColor),
            ),
          ),
        ),
      );
    }

    final maxTotal = _chartData
        .map((e) => (e['total'] as double? ?? 0))
        .reduce((a, b) => a > b ? a : b);

    return Card(
      color: cardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: subTextColor.withValues(alpha: 0.15)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppTranslations.tr('revenue_chart_title'),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: textColor,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxTotal * 1.2,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: maxTotal > 0 ? maxTotal / 4 : 1,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: subTextColor.withValues(alpha: 0.12),
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          if (value == 0 || value > maxTotal * 1.15) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: Text(
                              _formatMoneyShort(value),
                              style: TextStyle(fontSize: 10, color: subTextColor),
                            ),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < 0 || index >= _chartData.length) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              _axisLabel('${_chartData[index]['date']}'),
                              style: TextStyle(fontSize: 9, color: subTextColor),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  barGroups: List.generate(_chartData.length, (index) {
                    final total = _chartData[index]['total'] as double? ?? 0;
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: total,
                          width: _chartData.length > 8 ? 12 : 18,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              AppColors.primary.withValues(alpha: 0.7),
                              AppColors.primary,
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (_) => AppColors.primary.withValues(alpha: 0.9),
                      tooltipRoundedRadius: 8,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final stat = _chartData[group.x.toInt()];
                        final total = stat['total'] as double? ?? 0;
                        final label = _axisLabel('${stat['date']}');
                        final formatted = total.toInt().toString().replaceAllMapped(
                          RegExp(r'\B(?=(\d{3})+(?!\d))'),
                          (m) => '.',
                        );
                        return BarTooltipItem(
                          '$label\n$formattedđ',
                          const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
