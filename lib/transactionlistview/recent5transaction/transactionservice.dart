import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:paisa_pluse_new/transactionlistview/recent5transaction/transactiondatamodel.dart';

class TransactionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<TransactionModel>> getRecentTransactions(String userUid) async {
    try {
      List<TransactionModel> transactions = [];

      // Query expenses and income collections
      QuerySnapshot expenseSnapshot = await _firestore
          .collection('user')
          .doc(userUid)
          .collection('expenses')
          .orderBy('date', descending: true)
          .limit(5)
          .get();

      QuerySnapshot incomeSnapshot = await _firestore
          .collection('user')
          .doc(userUid)
          .collection('incomes')
          .orderBy('date', descending: true)
          .limit(5)
          .get();

      // Convert snapshots to TransactionModel
      transactions.addAll(_mapQuerySnapshotToTransactions(expenseSnapshot));
      transactions.addAll(_mapQuerySnapshotToTransactions(incomeSnapshot));

      // Sort transactions by date
      transactions.sort((a, b) => b.sampledate.compareTo(a.sampledate));
      // Take the latest 5 transactions
      return transactions.take(5).toList();
    } catch (e) {
      print('Error fetching recent transactions: $e');
      return [];
    }
  }

  List<TransactionModel> _mapQuerySnapshotToTransactions(
      QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      String formattedDate = DateFormat.yMMMMd()
          .add_jm()
          .format((data['date'] as Timestamp).toDate());
      return TransactionModel(
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
