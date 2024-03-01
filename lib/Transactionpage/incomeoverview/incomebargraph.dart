import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class IncomeOverviewBarGraph {
  int lastDays = 7;

  Future<BarChartData> mainData(String uid, String days) async {
    try {
      int lastDays = 7;
      if (days == 'Last 28 days') {
        lastDays = 28;
      } else if (days == 'Last 90 days') {
        lastDays = 90;
      }
      this.lastDays = lastDays;
      return BarChartData(
        alignment: BarChartAlignment.start,
        groupsSpace: 40,
        barTouchData: BarTouchData(
          enabled: true,
          allowTouchBarBackDraw: true,
        ),
        borderData: FlBorderData(show: true, border: Border.all(width: 1)),
        barGroups: [
          BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(
                toY: await getTotalAmountForFreelance(uid),
                color: Colors.blue,
                width: 32,
                borderRadius: BorderRadius.circular(0),
              ),
            ],
          ),
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(
                toY: await getTotalAmountForSalary(uid),
                color: Colors.red,
                width: 33,
                borderRadius: BorderRadius.circular(0),
              ),
            ],
          ),
          BarChartGroupData(
            x: 2,
            barRods: [
              BarChartRodData(
                toY: await getTotalAmountForBusiness(uid),
                color: Colors.green,
                width: 32,
                borderRadius: BorderRadius.circular(0),
              ),
            ],
          ),
          BarChartGroupData(
            x: 3,
            barRods: [
              BarChartRodData(
                toY: await getTotalAmountForRent(uid),
                color: Colors.orange,
                width: 32,
                borderRadius: BorderRadius.circular(0),
              ),
            ],
          ),
          BarChartGroupData(
            x: 4,
            barRods: [
              BarChartRodData(
                toY: await getTotalAmountForInvestment(uid),
                color: Colors.purple,
                width: 32,
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
        maxY: this.lastDays > 28 ? 30000 : 10000,
        gridData: FlGridData(
          show: true,
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
      );
    } catch (e) {
      // Handle exceptions or errors here
      print("Error: $e");
      throw e; // Re-throw the exception if needed
    }
  }

  Future<double> getTotalAmountForFreelance(String uid) async {
    try {
      double freelanceTotal = 0.0;

      // Query expenses using a timestamp-based condition
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('user')
              .doc(uid)
              .collection('incomes')
              .get();

      DateTime startDate = DateTime.now().subtract(Duration(days: lastDays));

      querySnapshot.docs.forEach((QueryDocumentSnapshot document) {
        DateTime expenseDate = document['date'].toDate();
        if (document['category'] == 'Freelance' &&
            expenseDate.isAfter(startDate)) {
          freelanceTotal += document['amount'];
        }
      });

      return freelanceTotal;
    } catch (e) {
      // Handle exceptions or errors here
      print("Error: $e");
      throw e; // Re-throw the exception if needed
    }
  }

  Future<double> getTotalAmountForSalary(String uid) async {
    try {
      double salaryTotal = 0.0;

      // Query expenses using a timestamp-based condition
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('user')
              .doc(uid)
              .collection('incomes')
              .get();

      DateTime startDate = DateTime.now().subtract(Duration(days: lastDays));

      querySnapshot.docs.forEach((QueryDocumentSnapshot document) {
        DateTime expenseDate = document['date'].toDate();
        if (document['category'] == 'Salary' &&
            expenseDate.isAfter(startDate)) {
          salaryTotal += document['amount'];
        }
      });
      return salaryTotal;
    } catch (e) {
      // Handle exceptions or errors here
      print("Error: $e");
      throw e; // Re-throw the exception if needed
    }
  }

  Future<double> getTotalAmountForBusiness(String uid) async {
    try {
      double businessTotal = 0.0;

      // Query expenses using a timestamp-based condition
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('user')
              .doc(uid)
              .collection('incomes')
              .get();

      DateTime startDate = DateTime.now().subtract(Duration(days: lastDays));

      querySnapshot.docs.forEach((QueryDocumentSnapshot document) {
        DateTime expenseDate = document['date'].toDate();
        if (document['category'] == 'Business' &&
            expenseDate.isAfter(startDate)) {
          businessTotal += document['amount'];
        }
      });

      return businessTotal;
    } catch (e) {
      // Handle exceptions or errors here
      print("Error: $e");
      throw e; // Re-throw the exception if needed
    }
  }

  Future<double> getTotalAmountForRent(String uid) async {
    try {
      double rentTotal = 0.0;

      // Query expenses using a timestamp-based condition
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('user')
              .doc(uid)
              .collection('incomes')
              .get();

      DateTime startDate = DateTime.now().subtract(Duration(days: lastDays));

      querySnapshot.docs.forEach((QueryDocumentSnapshot document) {
        DateTime rentDate = document['date'].toDate();
        if (document['category'] == 'Rent' && rentDate.isAfter(startDate)) {
          rentTotal += document['amount'];
        }
      });

      return rentTotal;
    } catch (e) {
      // Handle exceptions or errors here
      print("Error: $e");
      throw e; // Re-throw the exception if needed
    }
  }

  Future<double> getTotalAmountForInvestment(String uid) async {
    try {
      double investmentTotal = 0.0;
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('user')
              .doc(uid)
              .collection('incomes')
              .get();

      DateTime startDate = DateTime.now().subtract(Duration(days: lastDays));

      querySnapshot.docs.forEach((QueryDocumentSnapshot document) {
        DateTime expenseDate = document['date'].toDate();
        if (document['category'] == 'Investments' &&
            expenseDate.isAfter(startDate)) {
          investmentTotal += document['amount'];
        }
      });

      return investmentTotal;
    } catch (e) {
      // Handle exceptions or errors here
      print("Error: $e");
      throw e; // Re-throw the exception if needed
    }
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w300,
      fontSize: 13,
    );
    String text;
    List<String> categories = [
      'Freelance',
      'Salary',
      'Business',
      'Rent',
      'Investments',
    ];

    if (value.toInt() >= 0 && value.toInt() < categories.length) {
      text = categories[value.toInt()];
    } else {
      text = '';
    }

    return Text(text, style: style, textAlign: TextAlign.end);
  }
}
