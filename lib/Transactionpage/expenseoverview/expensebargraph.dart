import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ExpenseOverviewBarGraph {
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
                toY: await getTotalAmountForUtilities(uid),
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
                toY: await getTotalAmountForEducation(uid),
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
                toY: await getTotalAmountForGroceries(uid),
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
                toY: await getTotalAmountForShopping(uid),
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
                toY: await getTotalAmountForHealthcare(uid),
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

  Future<double> getTotalAmountForUtilities(String uid) async {
    try {
      double utilitiesTotal = 0.0;

      // Query expenses using a timestamp-based condition
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('user')
              .doc(uid)
              .collection('expenses')
              .get();

      DateTime startDate = DateTime.now().subtract(Duration(days: lastDays));

      querySnapshot.docs.forEach((QueryDocumentSnapshot document) {
        DateTime expenseDate = document['date'].toDate();
        if (document['category'] == 'Utilities' &&
            expenseDate.isAfter(startDate)) {
          utilitiesTotal += document['amount'];
        }
      });

      return utilitiesTotal;
    } catch (e) {
      // Handle exceptions or errors here
      print("Error: $e");
      throw e; // Re-throw the exception if needed
    }
  }

  Future<double> getTotalAmountForEducation(String uid) async {
    try {
      double educationTotal = 0.0;

      // Query expenses using a timestamp-based condition
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('user')
              .doc(uid)
              .collection('expenses')
              .get();

      DateTime startDate = DateTime.now().subtract(Duration(days: lastDays));

      querySnapshot.docs.forEach((QueryDocumentSnapshot document) {
        DateTime expenseDate = document['date'].toDate();
        if (document['category'] == 'Utilities' &&
            expenseDate.isAfter(startDate)) {
          educationTotal += document['amount'];
        }
      });

      return educationTotal;
    } catch (e) {
      // Handle exceptions or errors here
      print("Error: $e");
      throw e; // Re-throw the exception if needed
    }
  }

  Future<double> getTotalAmountForGroceries(String uid) async {
    try {
      double groceriesTotal = 0.0;

      // Query expenses using a timestamp-based condition
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('user')
              .doc(uid)
              .collection('expenses')
              .get();

      DateTime startDate = DateTime.now().subtract(Duration(days: lastDays));

      querySnapshot.docs.forEach((QueryDocumentSnapshot document) {
        DateTime expenseDate = document['date'].toDate();
        if (document['category'] == 'Groceries' &&
            expenseDate.isAfter(startDate)) {
          groceriesTotal += document['amount'];
        }
      });
      return groceriesTotal;
    } catch (e) {
      // Handle exceptions or errors here
      print("Error: $e");
      throw e; // Re-throw the exception if needed
    }
  }

  Future<double> getTotalAmountForShopping(String uid) async {
    try {
      double shoppingTotal = 0.0;

      // Query expenses using a timestamp-based condition
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('user')
              .doc(uid)
              .collection('expenses')
              .get();

      DateTime startDate = DateTime.now().subtract(Duration(days: lastDays));

      querySnapshot.docs.forEach((QueryDocumentSnapshot document) {
        DateTime expenseDate = document['date'].toDate();
        if (document['category'] == 'Shopping' &&
            expenseDate.isAfter(startDate)) {
          shoppingTotal += document['amount'];
        }
      });

      return shoppingTotal;
    } catch (e) {
      // Handle exceptions or errors here
      print("Error: $e");
      throw e; // Re-throw the exception if needed
    }
  }

  Future<double> getTotalAmountForHealthcare(String uid) async {
    try {
      double healthcareTotal = 0.0;
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('user')
              .doc(uid)
              .collection('expenses')
              .get();

      DateTime startDate = DateTime.now().subtract(Duration(days: lastDays));

      querySnapshot.docs.forEach((QueryDocumentSnapshot document) {
        DateTime expenseDate = document['date'].toDate();
        if (document['category'] == 'Healthcare' &&
            expenseDate.isAfter(startDate)) {
          healthcareTotal += document['amount'];
        }
      });

      return healthcareTotal;
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
      'Utilities',
      'Education',
      'Groceries',
      'Shopping',
      'Healthcare',
    ];

    if (value.toInt() >= 0 && value.toInt() < categories.length) {
      text = categories[value.toInt()];
    } else {
      text = '';
    }

    return Text(text, style: style, textAlign: TextAlign.end);
  }
}
