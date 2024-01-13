import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:paisa_pluse_new/transactionlistview/recent1transaction/transactiondatamodel.dart';

class RecentTransactionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<RecentTransactionModel>> getRecentTransactions(
      String userUid) async {
    try {
      List<RecentTransactionModel> transactions = [];

      // Query expenses and income collections
      QuerySnapshot expenseSnapshot = await _firestore
          .collection('user')
          .doc(userUid)
          .collection('expenses')
          .orderBy('date', descending: true)
          .limit(1)
          .get();

      QuerySnapshot incomeSnapshot = await _firestore
          .collection('user')
          .doc(userUid)
          .collection('incomes')
          .orderBy('date', descending: true)
          .limit(1)
          .get();

      // Convert snapshots to TransactionModel
      transactions.addAll(_mapQuerySnapshotToTransactions(expenseSnapshot));
      transactions.addAll(_mapQuerySnapshotToTransactions(incomeSnapshot));

      // Sort transactions by date
      transactions.sort((a, b) => b.sampledate.compareTo(a.sampledate));
      // Take the latest 5 transactions
      return transactions.take(1).toList();
    } catch (e) {
      print('Error fetching recent transactions: $e');
      return [];
    }
  }

  List<RecentTransactionModel> _mapQuerySnapshotToTransactions(
      QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      String formattedDate = DateFormat.yMMMMd()
          .add_jm()
          .format((data['date'] as Timestamp).toDate());
      return RecentTransactionModel(
        amount: data['amount'],
        category: data['category'],
        dateTime: formattedDate,
        sampledate: data['date'].toDate(),
        notes: data['note'],
        paymentMethod: data['paymentmethod'],
        type: data['type'],
      );
    }).toList();
  }
}
