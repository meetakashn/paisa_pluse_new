import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashboardLineGraph {
  LineChartData mainData(List<Map<String, dynamic>> expenseData) {
    List<FlSpot> expenseSpots = [];

    for (int i = 0; i < expenseData.length; i++) {
      DateTime expenseDate = expenseData[i]['date'].toDate();
      // Extract the month as an integer
      int month = expenseDate.month;
      // Example: Formatting the date to a string (you can customize the format as needed)
      String formattedDate =
          DateFormat('dd MMMM yyyy HH:mm').format(expenseDate);
      double amount =
          expenseData[i]['amount'] / 10000; // Adjust the scale as needed
      expenseSpots.add(FlSpot(month.toDouble(), amount));
    }
    return LineChartData(
      borderData: FlBorderData(
        border: Border.all(color: Colors.blue, width: 2),
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Colors.blue,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(strokeWidth: 1, color: Colors.blue);
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false, reservedSize: 20),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 32,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 35,
          ),
        ),
      ),
      minX: 0,
      maxX: 11,
      minY: -1,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: expenseSpots,
          isCurved: true,
          show: true,
          gradient: const RadialGradient(colors: <Color>[
            Color(0xFFffff00),
            Color(0xFFffc40c),
          ]),
          barWidth: 2,
          dotData: const FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: const LinearGradient(
                colors: <Color>[Color(0xFF0f4d92), Color(0xFFffcc00)]),
          ),
        ),
      ],
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 13,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '10K';
        break;
      case 2:
        text = '20K';
        break;
      case 3:
        text = '30K';
        break;
      case 4:
        text = '40K';
        break;
      case 5:
        text = '50K';
        break;
      case 6:
        text = '60K';
        break;
      default:
        return Container();
    }
    return Text(text, style: style, textAlign: TextAlign.end);
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 13,
    );
    Widget text;
      switch (value.toInt()) {
        case 1:
          text = const Text(
            'JAN',
            style: style,
          );
          break;
        case 3:
          text = const Text(
            'MAR',
            style: style,
          );
          break;
        case 5:
          text = const Text(
            'MAY',
            style: style,
          );
          break;
        case 7:
          text = const Text('JULY', style: style);
          break;
        case 9:
          text = const Text('SEP', style: style);
          break;
        case 11:
          text = const Text('NOV', style: style);
          break;
        default:
          text = const Text('', style: style);
          break;
      }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }
}
