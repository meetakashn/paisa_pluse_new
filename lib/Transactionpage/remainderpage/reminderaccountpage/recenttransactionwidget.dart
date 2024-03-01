import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paisa_pluse_new/transactionlistview/recent5transaction/transactiondatamodel.dart';
import 'package:paisa_pluse_new/utils/routes.dart';

import 'editremainder.dart';
import 'transactiondatamodel.dart';
import 'transactionservice.dart';

class RemainderList extends StatelessWidget {
  final String userUid;

  RemainderList({required this.userUid});

  final TransactionRemainderAccountService transactionService =
      TransactionRemainderAccountService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: transactionService.getRecentTransactions(userUid),
      builder: (context, AsyncSnapshot<List<TransactionReminderModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No recent remainders.'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length + 1,
            itemBuilder: (context, index) {
              if (index < snapshot.data!.length) {
                TransactionReminderModel transaction = snapshot.data![index];
                bool isIncome = transaction.type == 'income';
                IconData categoryIcon =
                    categoryIcons[transaction.category] ?? Icons.category;
                return Container(
                  width: 1.sw,
                  height: 0.11.sh,
                  margin: EdgeInsets.only(
                      left: 0.015.sw, right: 0.020.sw, bottom: 0.005.sw, top: 0.01.sw),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(15.0),
                    color: isIncome ? Colors.green : Colors.red,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: 0.02.sw,
                                top: transaction.category == 'Initial Amount' ? 0.015.sh : 0,
                                bottom:
                                transaction.category == 'Initial Amount' ? 0.004.sh : 0),
                            child: Text(isIncome ? "Credit alert:" : "Debit alert:",
                                style: TextStyle(
                                    color: isIncome ? Colors.white60 : Colors.white70,
                                    fontSize: 15.0.sp,
                                    fontFamily: GoogleFonts.akshar().fontFamily,
                                    letterSpacing: 1)),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 0.02.sw,
                                top: transaction.category== 'Initial Amount' ? 0.015.sh : 0,
                                bottom:
                                transaction.category == 'Initial Amount' ? 0.004.sh : 0),
                            child: Icon(
                              categoryIcon,
                              color: Colors.white,
                              size: 16.0.sp,
                            ),
                          ),
                          SizedBox(
                            width: 0.011.sw,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: transaction.category== 'Initial Amount' ? 0.015.sh : 0,
                                bottom:
                                transaction.category == 'Initial Amount' ? 0.004.sh : 0),
                            child: Text('${transaction.category}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.0.sp,
                                    fontFamily: GoogleFonts.akshar().fontFamily,
                                    letterSpacing: 2)),
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                left: 0.02.sw,
                              ),
                              child:transaction.category== 'Initial Amount'
                                  ? null
                                  : IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                      EditRemainder(useruid: userUid,
                                        amount: transaction.amount,
                                        category: transaction.category,
                                        date: transaction.sampledate,
                                        note: transaction.notes,
                                        paymentMethod: transaction.paymentMethod,
                                        type: transaction.type,
                                        documentId: transaction.documentid,),
                                    );
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    size: 0.04.sw,
                                    color: Colors.white,
                                  ))),
                          if (transaction.category == 'Initial Amount')
                            const SizedBox.shrink()
                          else
                            IconButton(
                                onPressed: () async {
                                  bool confirmDelete = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Confirm Deletion'),
                                        content: const Text('Are you sure you want to delete this reminder?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(false); // Cancel the deletion
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(true); // Confirm the deletion
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  if (confirmDelete == true) {
                                    await deleteReminder(userUid, transaction.documentid);
                                    // Show a success alert box
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) => AlertDialog(
                                          title: const Text('Reminder Deleted'),
                                          content: const Text('The reminder has been successfully deleted.'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pushReplacementNamed(context, MyRoutes.reminderpage); // Close the alert box
                                              },
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        ),
                                    );
                                  }
                                },
                                icon: Icon(
                                  Icons.delete,
                                  size: 0.04.sw,
                                  color: Colors.yellow,
                                )),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 0.02.sw),
                            child: Text(
                              '${transaction.paymentMethod}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          Text(
                            "(${transaction.dateTime})",
                            style: TextStyle(color: Colors.white70, fontSize: 11.0.sp),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 0.05.sw),
                            child: Text('${isIncome ? '+' : '-'}${transaction.amount}',
                                style: TextStyle(
                                    fontSize: 17.0.sp,
                                    color: isIncome ? Colors.white : Colors.white)),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 0.02.sw),
                            child: Text(
                              'Note: ${transaction.notes}',
                              style: TextStyle(color: Colors.white, fontSize: 12.0.sp),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              } else {
                // Display a message when there is no more data to show
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      'No more remainder to show',
                      style: TextStyle(
                        fontSize: 10.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }
            },
          );
        }
      },
    );
  }

  final Map<String, IconData> categoryIcons = {
    'Groceries': Icons.shopping_cart,
    'Utilities': Icons.settings,
    'Transportation': Icons.directions_car,
    'Healthcare': Icons.local_hospital,
    'Entertainment': Icons.movie,
    'Dining Out': Icons.restaurant,
    'Shopping': Icons.shopping_bag,
    'Home Maintenance': Icons.home_repair_service,
    'Travel': Icons.airplane_ticket,
    'Miscellaneous': Icons.category,
    'Education': Icons.book,
    'Salary': Icons.attach_money,
    'Freelance': Icons.work,
    'Business': Icons.business,
    'Investments': Icons.trending_up,
    'Gifts': Icons.card_giftcard,
    'Rent': Icons.home,
    'Side Hustle': Icons.star,
    'Refunds': Icons.refresh,
    'Other': Icons.category,
    'Initial Amount': Icons.account_balance,
  };

  Future<void> deleteReminder(String userUid, String documentId) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    try {
      await _firestore
          .collection('user')
          .doc(userUid)
          .collection('remainder')
          .doc(documentId)
          .delete();
    } catch (e) {
      print('Error deleting reminder: $e');
      // Handle the error as needed
    }
  }
}
