import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:evora/data/mock/analytics.dart';
import 'package:evora/theme/sketch_colors.dart';

/// Minimal bar chart over a [SeriesPoint] list, styled to the theme.
class SimpleBarChart extends StatelessWidget {
  const SimpleBarChart({super.key, required this.points, this.height = 200});

  final List<SeriesPoint> points;
  final double height;

  @override
  Widget build(BuildContext context) {
    final s = context.sketch;
    final maxValue = points.map((p) => p.value).fold(0.0, (a, b) => a > b ? a : b);

    return SizedBox(
      height: height,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxValue * 1.2,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                getTitlesWidget: (value, _) {
                  final i = value.toInt();
                  if (i < 0 || i >= points.length) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(points[i].label,
                        style: TextStyle(color: s.bodySubtle, fontSize: 11)),
                  );
                },
              ),
            ),
          ),
          barGroups: [
            for (var i = 0; i < points.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: points[i].value,
                    color: s.brand,
                    width: 18,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                    borderSide: BorderSide(color: s.ink, width: 2),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
