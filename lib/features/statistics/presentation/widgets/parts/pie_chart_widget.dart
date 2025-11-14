import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PieChartWidget extends StatelessWidget {
  const PieChartWidget({
    super.key,
    required this.totalGames,
    required this.totalWins,
    required this.totalLosses,
    required this.totalCancelled,
    required this.colorLosses,
    required this.colorWins,
    required this.colorCancelled,
    required this.maxWidth,
  });

  final double totalGames;
  final double totalWins;
  final double totalLosses;
  final double totalCancelled;
  final Color colorLosses;
  final Color colorWins;
  final Color colorCancelled;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            value: totalLosses,
            color: colorLosses,
            title: '${totalLosses.toInt()}',
            radius: maxWidth / 3,
          ),
          PieChartSectionData(
            value: totalWins,
            color: colorWins,
            title: '${totalWins.toInt()}',
            radius: maxWidth / 3,
          ),
          PieChartSectionData(
            value: totalCancelled,
            color: colorCancelled,
            title: '${totalCancelled.toInt()}',
            radius: maxWidth / 3,
          ),
        ],
      ),
    );
  }
}