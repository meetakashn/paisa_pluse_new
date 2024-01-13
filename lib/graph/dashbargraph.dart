import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DashboardBarGraph {
  BarChartData mainData(String uid) {
    return BarChartData(
      alignment: BarChartAlignment.start,
      groupsSpace: 30,
      barTouchData: BarTouchData(
        enabled: false,
      ),
      borderData: FlBorderData(show: true, border: Border.all(width: 1)),
      barGroups: [
        BarChartGroupData(
          x: 0,
          barRods: [
            BarChartRodData(
              toY: 30000,
              color: Colors.brown,
              width: 20,
              borderRadius: BorderRadius.circular(0),
            ),
          ],
        ),
        BarChartGroupData(
          x: 1,
          barRods: [
            BarChartRodData(
              toY: 45000,
              color: Colors.red,
              width: 20,
              borderRadius: BorderRadius.circular(0),
            ),
          ],
        ),
        BarChartGroupData(
          x: 3,
          barRods: [
            BarChartRodData(
              toY: 20000,
              color: Colors.green,
              width: 20,
              borderRadius: BorderRadius.circular(0),
            ),
          ],
        ),
        BarChartGroupData(
          x: 5,
          barRods: [
            BarChartRodData(
              toY: 1500,
              color: Colors.green,
              width: 20,
              borderRadius: BorderRadius.circular(0),
            ),
          ],
        ),
        BarChartGroupData(
          x: 8,
          barRods: [
            BarChartRodData(
              toY: 25055,
              color: Colors.orange,
              width: 20,
              borderRadius: BorderRadius.circular(0),
            ),
          ],
        ),
      ],
      titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
                showTitles: true, getTitlesWidget: bottomTitleWidgets),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          )),
      minY: 0,
      maxY: 50000,
      gridData: FlGridData(
        show: true,
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
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.brown,
      fontWeight: FontWeight.bold,
      fontSize: 13,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Food';
        break; //feb
      case 1:
        text = 'Medical';
        break; //ap
      case 2:
        text = 'Education';
        break; //ju
      case 3:
        text = 'Bills';
        break; //aug
      case 5:
        text = 'Transport';
        break; //oct
      case 8:
        text = 'Buy';
        break;
      default:
        text = '';
        break;
    }
    return Text(text, style: style, textAlign: TextAlign.end);
  }
}
