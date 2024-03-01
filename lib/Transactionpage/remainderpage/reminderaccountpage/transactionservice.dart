import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:paisa_pluse_new/transactionlistview/recent5transaction/transactiondatamodel.dart';

import 'transactiondatamodel.dart';

class TransactionRemainderAccountService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<TransactionReminderModel>> getRecentTransactions(String userUid) async {
    try {
      List<TransactionReminderModel> transactions = [];
// Get the current date and time
      DateTime currentDate = DateTime.now();
      // Query expenses and income collections
      QuerySnapshot remainderSnapshot = await _firestore
          .collection('user')
          .doc(userUid)
          .collection('remainder')
          .where('date', isGreaterThanOrEqualTo: currentDate)
          .orderBy('date', descending: true)
          .get();

      // Convert snapshots to TransactionModel
// Convert snapshots to TransactionModel
      var mappedTransactions = _mapQuerySnapshotToTransactions(remainderSnapshot);
      transactions.addAll(mappedTransactions);

      // Sort transactions by date
      transactions.sort((a, b) => b.sampledate.compareTo(a.sampledate));
      // Take the latest 5 transactions
      return transactions.toList();
    } catch (e) {
      print('Error fetching recent transactions: $e');
      return [];
    }
  }

  List<TransactionReminderModel> _mapQuerySnapshotToTransactions(QuerySnapshot? snapshot) {
    if (snapshot == null) {
      return [];
    }

    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      String formattedDate = DateFormat.yMMMMd()
          .add_jm()
          .format((data['date'] as Timestamp).toDate());
      String documentId = doc.id;
      return TransactionReminderModel(
        documentid: documentId,
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
