import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../expenseswidget/editexpensewidget.dart';
import '../../incomewidget/deleteincomewidget.dart';
import '../../incomewidget/editincomewidget.dart';

class TransactionsListPage extends StatefulWidget {
  final String selectedDate;
  final String useruid;

  TransactionsListPage({required this.useruid, required this.selectedDate});

  @override
  _TransactionsListPageState createState() => _TransactionsListPageState();
}

class _TransactionsListPageState extends State<TransactionsListPage> {
  List<Map<String, dynamic>> transactions = [];
  List<Map<String, dynamic>> expenseList = [];
  List<Map<String, dynamic>> incomeList = [];
  late Future<void> fetchDataFuture;

  @override
  void initState() {
    super.initState();
    fetchDataFuture = _fetchTransactions();
  }

  Future<void> _fetchTransactions() async {
    // Convert formatted date string to DateTime
    DateTime selectedDateTime =
        DateFormat('MMMM d, yyyy').parse(widget.selectedDate);

    QuerySnapshot<Map<String, dynamic>> expenseSnapshot =
        await FirebaseFirestore.instance
            .collection('user')
            .doc(widget.useruid)
            .collection('expenses')
            .where('date',
                isGreaterThanOrEqualTo:
                    Timestamp.fromDate(selectedDateTime.toUtc()))
            .where('date',
                isLessThan: Timestamp.fromDate(
                    selectedDateTime.add(Duration(days: 1)).toUtc()))
            .get();

    QuerySnapshot<Map<String, dynamic>> incomeSnapshot = await FirebaseFirestore
        .instance
        .collection('user')
        .doc(widget.useruid)
        .collection('incomes')
        .where('date',
            isGreaterThanOrEqualTo:
                Timestamp.fromDate(selectedDateTime.toUtc()))
        .where('date',
            isLessThan: Timestamp.fromDate(
                selectedDateTime.add(Duration(days: 1)).toUtc()))
        .get();

    List<Map<String, dynamic>> expenses = expenseSnapshot.docs
        .map((doc) => {...doc.data(), 'id': doc.id})
        .toList();

    List<Map<String, dynamic>> incomes = incomeSnapshot.docs
        .map((doc) => {...doc.data(), 'id': doc.id})
        .toList();

    transactions = [...expenses, ...incomes];
    transactions.sort(
      (a, b) => (b['date'] as Timestamp).compareTo(a['date'] as Timestamp),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: fetchDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(
            color: Colors.white,
          ));
        } else if (transactions.isEmpty) {
          print(snapshot);
          return Center(
              child: Text(
            "No data found",
            style: TextStyle(color: Colors.white),
          ));
        } else if (snapshot.hasError) {
          return Center(
              child: Text(
            "Error found",
            style: TextStyle(color: Colors.white),
          ));
        } else
          return _buildTransactionList();
      },
    );
  }

  Widget _buildTransactionList() {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.all(0.01.sw),
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> transaction = transactions[index];
          String documentId = transactions[index]['id'];
          bool isIncome = transaction['type'] == 'income';
          String formattedDate = DateFormat.yMMMMd()
              .add_jm()
              .format((transaction['date'] as Timestamp).toDate());
          return Container(
            width: 1.sw,
            height: 0.16.sh,
            margin:
                EdgeInsets.only(left: 0.020.sw, right: 0.020.sw, top: 0.02.sw),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(15.0),
              color: isIncome ? Colors.green.shade500 : Colors.red.shade500,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        right: transaction['category'] == 'Initial Amount'
                            ? 0.21.sw
                            : 0.00.sw,
                        bottom: transaction['category'] == 'Initial Amount'
                            ? 0.04.sw
                            : 0,
                        top: transaction['category'] == 'Initial Amount'
                            ? 0.04.sw
                            : 0,
                      ),
                      child: Text(
                        "${formattedDate}",
                        style:
                            TextStyle(color: Colors.white70, fontSize: 11.0.sp),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 0.33.sw),
                        child: transaction['category'] == 'Initial Amount'
                            ? null
                            : IconButton(
                                onPressed: () {
                                  if (transaction['type'] == 'income') {
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                          EditIncomeTransactionDialog(
                                        useruid: widget.useruid,
                                        transactionData: transaction,
                                        documentId: documentId,
                                      ),
                                    );
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                          EditExpenseTransactionDialog(
                                        useruid: widget.useruid,
                                        transactionData: transaction,
                                        documentId: documentId,
                                      ),
                                    );
                                  }
                                },
                                icon: Icon(
                                  Icons.edit,
                                  size: 0.04.sw,
                                  color: Colors.white,
                                ))),
                    if (transaction['category'] == 'Initial Amount')
                      SizedBox.shrink()
                    else
                      IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return DeleteIncomeExpense(
                                    transactionData: transaction,
                                    useruid: widget.useruid,
                                    documentId: documentId,
                                  );
                                });
                          },
                          icon: Icon(
                            Icons.delete,
                            size: 0.04.sw,
                            color: Colors.yellow,
                          )),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 0.02.sw),
                      child: Text(isIncome ? "Received from:" : "Paid for:",
                          style: TextStyle(
                              color: isIncome ? Colors.white60 : Colors.white70,
                              fontSize: 15.0.sp,
                              fontFamily: GoogleFonts.akshar().fontFamily,
                              letterSpacing: 1)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 0.02.sw),
                      child: Icon(
                        categoryIcons[transaction['category']],
                        color: Colors.white,
                        size: 16.0.sp,
                      ),
                    ),
                    SizedBox(
                      width: 0.011.sw,
                    ),
                    Text('${transaction['category']}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0.sp,
                            fontFamily: GoogleFonts.akshar().fontFamily,
                            letterSpacing: 2)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 0.02.sw),
                      child: Text(
                        '${transaction['paymentmethod']}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 0.05.sw),
                      child: Text(
                          '${isIncome ? '+' : '-'}${transaction['amount']}',
                          style: TextStyle(
                              fontSize: 17.0.sp,
                              color: isIncome ? Colors.white : Colors.white)),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 0.02.sw),
                  child: Text(
                    'Note: ${transaction['note']}',
                    style: TextStyle(color: Colors.white, fontSize: 12.0.sp),
                  ),
                ),

                // Add more fields based on your data structure
              ],
            ),
          );
        },
      ),
    );
  }

  // Map of category icons
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
}
