import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class LineChartWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        titlesData: FlTitlesData(
          bottomTitles: AxisTitle(
            showTitle: true,
            margin: 8,
            reservedSize: 22,
            getTextStyles: (value) => const TextStyle(fontSize: 10, color: Colors.white),
            getTitles: (value) {
              switch (value.toInt()) {
                case 1:
                  return 'Jan';
                case 2:
                  return 'Feb';
                case 3:
                  return 'Mar';
                case 4:
                  return 'Apr';
                case 5:
                  return 'May';
                default:
                  return '';
              }
            },
          ),
          leftTitles: AxisTitle(
            showTitle: true,
            margin: 8,
            reservedSize: 22,
            getTextStyles: (value) => const TextStyle(fontSize: 10, color: Colors.white),
            getTitles: (value) {
              switch (value.toInt()) {
                case 1:
                  return '1';
                case 3:
                  return '3';
                case 5:
                  return '5';
                case 7:
                  return '7';
                default:
                  return '';
              }
            },
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(1, 1),
              FlSpot(2, 1.3),
              FlSpot(3, 1.4),
              FlSpot(4, 3.4),
              FlSpot(5, 7),
            ],
            isCurved: true,
            barWidth: 2,
            color: Colors.blue,
            belowBarData: BarAreaData(show: true, color: Colors.green),
          ),
        ],
      ),
    );
  }
  
  AxisTitle({required bool showTitle, required int margin, required int reservedSize, required TextStyle Function(dynamic value) getTextStyles, required String Function(dynamic value) getTitles}) {}
}
