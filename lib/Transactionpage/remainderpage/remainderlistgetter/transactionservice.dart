import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:paisa_pluse_new/transactionlistview/recent5transaction/transactiondatamodel.dart';

class TransactionRemainderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<TransactionModel>> getRecentTransactions(String userUid) async {
    try {
      List<TransactionModel> transactions = [];
// Get the current date and time
      DateTime currentDate = DateTime.now();
      // Query expenses and income collections
      QuerySnapshot remainderSnapshot = await _firestore
          .collection('user')
          .doc(userUid)
          .collection('remainder')
          .where('date', isGreaterThanOrEqualTo: currentDate)
          .orderBy('date', descending: false)
          .get();

      // Convert snapshots to TransactionModel
// Convert snapshots to TransactionModel
      var mappedTransactions = _mapQuerySnapshotToTransactions(remainderSnapshot);
      transactions.addAll(mappedTransactions);

      // Take the latest 5 transactions
      return transactions.toList();
    } catch (e) {
      print('Error fetching recent transactions: $e');
      return [];
    }
  }

  List<TransactionModel> _mapQuerySnapshotToTransactions(QuerySnapshot? snapshot) {
    if (snapshot == null) {
      return [];
    }

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
