import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class IncomeOverviewLineGraph {
  List<Map<String, dynamic>> IncomeData = [];

  LineChartData mainData(List<Map<String, dynamic>> IncomeData) {
    this.IncomeData = IncomeData;
    IncomeData.sort((a, b) => a['date'].toDate().compareTo(b['date'].toDate()));
    List<FlSpot> IncomeSpots = [];
    IncomeSpots = IncomeData.asMap().entries.map((entry) {
      DateTime currentDate = entry.value['date'].toDate();
      double amount = entry.value['amount'] / 1000;
      return FlSpot(entry.key.toDouble(), amount);
    }).toList();

    return LineChartData(
      borderData: FlBorderData(
        border: Border.all(color: Colors.black, width: 2),
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Colors.black,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(strokeWidth: 1, color: Colors.black);
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
      maxX: IncomeSpots.length.toDouble() < 5
          ? 5
          : IncomeSpots.length.toDouble() - 1,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: IncomeSpots,
          isCurved: true,
          show: true,
          gradient: const RadialGradient(colors: <Color>[
            Color(0xFFFFFF00),
            Color(0xFFFF00),
          ]),
          barWidth: 1,
          dotData: const FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: const LinearGradient(
                colors: <Color>[Color(0xFFFF8C00), Color(0xFFFF4500)]),
          ),
        ),
      ],
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w400,
      fontSize: 13,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '1k';
        break;
      case 2:
        text = '2K';
        break;
      case 3:
        text = '3K';
        break;
      case 4:
        text = '4K';
        break;
      case 5:
        text = '5K';
        break;
      case 6:
        text = '6K';
        break;
      default:
        return Container();
    }
    if (value.toInt() > 6) {
      switch (value.toInt()) {
        case 7:
          text = '7k';
          break;
        case 8:
          text = '8K';
          break;
        case 9:
          text = '9K';
          break;
        case 10:
          text = '10K';
          break;
        default:
          return Container();
      }
    }
    return Text(text, style: style, textAlign: TextAlign.center);
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    int index = value.toInt();
    if (index < 0 || index >= IncomeData.length) {
      return Container(); // Handle out-of-bounds index
    }

    DateTime currentDate = IncomeData[index]['date'].toDate();
    String day = DateFormat('dd/MM/yy').format(currentDate);

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        day,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: IncomeData.length >= 10 ? 6 : 8,
        ),
      ),
    );
  }
}
