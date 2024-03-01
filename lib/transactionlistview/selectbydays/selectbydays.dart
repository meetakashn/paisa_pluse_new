import 'package:cloud_firestore/cloud_firestore.dart';

class TotalExpenseService {
  Future<int> getTotalExpense(String userUid, String timeRange) async {
    try {
      DateTime endDate = DateTime.now();
      DateTime startDate;

      // Set the start date based on the selected time range
      switch (timeRange) {
        case 'Last 7 days':
          startDate = endDate.subtract(Duration(days: 7));
          break;
        case 'Last 28 days':
          startDate = endDate.subtract(Duration(days: 28));
          break;
        case 'Last 90 days':
          startDate = endDate.subtract(Duration(days: 90));
          break;
        default:
          // Default to the last 7 days if the selected time range is not recognized
          startDate = endDate.subtract(Duration(days: 7));
          break;
      }

      // Fetch income documents within the specified time range
      QuerySnapshot expenseSnapshot = await FirebaseFirestore.instance
          .collection('user')
          .doc(userUid)
          .collection('expenses')
          .where('date',
              isGreaterThanOrEqualTo: startDate, isLessThanOrEqualTo: endDate)
          .get();
      // Calculate total income amount
      int totalExpense =
          expenseSnapshot.docs.fold(0, (total, doc) => doc['amount'] + total);

      return totalExpense;
    } catch (e) {
      // Handle any errors
      print('Error getting total amount: $e');
      return 0;
    }
  }
}

class TotalIncomeService {
  Future<int> getTotalIncome(String userUid, String timeRange) async {
    try {
      DateTime endDate = DateTime.now();
      DateTime startDate;

      // Set the start date based on the selected time range
      switch (timeRange) {
        case 'Last 7 days':
          startDate = endDate.subtract(Duration(days: 7));
          break;
        case 'Last 28 days':
          startDate = endDate.subtract(Duration(days: 28));
          break;
        case 'Last 90 days':
          startDate = endDate.subtract(Duration(days: 90));
          break;
        default:
          // Default to the last 7 days if the selected time range is not recognized
          startDate = endDate.subtract(Duration(days: 7));
          break;
      }

// Fetch income documents within the specified time range
      QuerySnapshot incomeSnapshot = await FirebaseFirestore.instance
          .collection('user')
          .doc(userUid)
          .collection('incomes')
          .where('date',
              isGreaterThanOrEqualTo: startDate, isLessThanOrEqualTo: endDate)
          .get();

// Filter out documents with 'category' equal to 'Initial Amount'
      List<DocumentSnapshot> filteredDocs = incomeSnapshot.docs
          .where((doc) => doc['category'] != 'Initial Amount')
          .toList();

// Calculate total income amount from filtered documents
      int totalIncome =
          filteredDocs.fold(0, (total, doc) => doc['amount'] + total);

// Calculate and return the net amount (income - expense)
      return totalIncome;
    } catch (e) {
      // Handle any errors
      print('Error getting total amount: $e');
      return 0;
    }
  }
}

class HighestIncomeCategory {
  Future<String> getHighestIncomeCategory(
      String userUid, String timeRange) async {
    try {
      DateTime endDate = DateTime.now();
      DateTime startDate;

      // Set the start date based on the selected time range
      switch (timeRange) {
        case 'Last 7 days':
          startDate = endDate.subtract(Duration(days: 7));
          break;
        case 'Last 28 days':
          startDate = endDate.subtract(Duration(days: 28));
          break;
        case 'Last 90 days':
          startDate = endDate.subtract(Duration(days: 90));
          break;
        default:
          // Default to the last 7 days if the selected time range is not recognized
          startDate = endDate.subtract(Duration(days: 7));
          break;
      }

      // Fetch income documents within the specified time range
      QuerySnapshot incomeSnapshot = await FirebaseFirestore.instance
          .collection('user')
          .doc(userUid)
          .collection('incomes')
          .where('date',
              isGreaterThanOrEqualTo: startDate, isLessThanOrEqualTo: endDate)
          .get();

      // Create a map to store total income for each category
      Map<String, int> categoryTotalMap = {};

      // Iterate through income documents and calculate total income for each category
      incomeSnapshot.docs.forEach((doc) {
        String category = doc['category'];
        int amount = doc['amount'];

        // Exclude 'Initial Amount' category
        if (category != 'Initial Amount') {
          categoryTotalMap.update(category, (value) => value + amount,
              ifAbsent: () => amount);
        }
      });

      // Find the category with the highest total income
      String highestCategory = categoryTotalMap.entries.fold(
        '',
        (previousValue, entry) =>
            entry.value > (categoryTotalMap[previousValue] ?? 0)
                ? entry.key
                : previousValue,
      );
      return highestCategory;
    } catch (e) {
      // Handle any errors
      print('Error getting highest income category: $e');
      return '';
    }
  }
}

class HighestExpenseCategory {
  Future<String> getHighestExpenseCategory(
      String userUid, String timeRange) async {
    try {
      DateTime endDate = DateTime.now();
      DateTime startDate;

      // Set the start date based on the selected time range
      switch (timeRange) {
        case 'Last 7 days':
          startDate = endDate.subtract(Duration(days: 7));
          break;
        case 'Last 28 days':
          startDate = endDate.subtract(Duration(days: 28));
          break;
        case 'Last 90 days':
          startDate = endDate.subtract(Duration(days: 90));
          break;
        default:
          // Default to the last 7 days if the selected time range is not recognized
          startDate = endDate.subtract(Duration(days: 7));
          break;
      }

      // Fetch income documents within the specified time range
      QuerySnapshot incomeSnapshot = await FirebaseFirestore.instance
          .collection('user')
          .doc(userUid)
          .collection('expenses')
          .where('date',
              isGreaterThanOrEqualTo: startDate, isLessThanOrEqualTo: endDate)
          .get();

      // Create a map to store total income for each category
      Map<String, int> categoryTotalMap = {};

      // Iterate through income documents and calculate total income for each category
      incomeSnapshot.docs.forEach((doc) {
        String category = doc['category'];
        int amount = doc['amount'];

        // Exclude 'Initial Amount' category
        if (category != 'Initial Amount') {
          categoryTotalMap.update(category, (value) => value + amount,
              ifAbsent: () => amount);
        }
      });

      // Find the category with the highest total income
      String highestCategory = categoryTotalMap.entries.fold(
        '',
        (previousValue, entry) =>
            entry.value > (categoryTotalMap[previousValue] ?? 0)
                ? entry.key
                : previousValue,
      );
      return highestCategory;
    } catch (e) {
      // Handle any errors
      print('Error getting highest income category: $e');
      return '';
    }
  }
}
