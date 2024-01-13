import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<Map<String, dynamic>>> fetchExpenseData(String userId) async {
  try {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('user')
        .doc(userId)
        .collection('expenses')
        .get();

    return querySnapshot.docs.map((DocumentSnapshot<Map<String, dynamic>> doc) {
      return doc.data()!;
    }).toList();
  } catch (e) {
    print('Error fetching expense data: $e');
    return [];
  }
}
