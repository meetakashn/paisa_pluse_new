import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:paisa_pluse_new/incomewidget/deleteincomewidget.dart';

import '../../expenseswidget/editexpensewidget.dart';
import '../../incomewidget/editincomewidget.dart';

class CombinedListPage extends StatefulWidget {
  final String useruid;

  const CombinedListPage({super.key, required this.useruid});

  @override
  _CombinedListPageState createState() => _CombinedListPageState();
}

class _CombinedListPageState extends State<CombinedListPage> {
  List<Map<String, dynamic>> combinedList = [];
  List<Map<String, dynamic>> expenseList = [];
  List<Map<String, dynamic>> incomeList = [];
  late Future<void> fetchDataFuture;

  @override
  void initState() {
    super.initState();
    fetchDataFuture = fetchData();
  }

  Future<void> fetchData() async {
    // Retrieve expense data
    QuerySnapshot<Map<String, dynamic>> expenseSnapshot =
        await FirebaseFirestore.instance
            .collection('user')
            .doc(widget.useruid)
            .collection('expenses')
            .orderBy('date', descending: true)
            .get();
    expenseList = expenseSnapshot.docs.map((doc) {
      return {
        'id': doc.id,
        ...doc.data()
      }; // Add 'id' field to store document ID
    }).toList();
    // Retrieve income data
    QuerySnapshot<Map<String, dynamic>> incomeSnapshot = await FirebaseFirestore
        .instance
        .collection('user')
        .doc(widget.useruid)
        .collection('incomes')
        .orderBy('date', descending: true)
        .get();
    incomeList = incomeSnapshot.docs.map((doc) {
      return {
        'id': doc.id,
        ...doc.data()
      }; // Add 'id' field to store document ID
    }).toList();
    // Combine and sort the data
    List<Map<String, dynamic>> expenses = expenseSnapshot.docs
        .map((doc) => {...doc.data(), 'id': doc.id})
        .toList();
    List<Map<String, dynamic>> incomes = incomeSnapshot.docs
        .map((doc) => {...doc.data(), 'id': doc.id})
        .toList();

    combinedList = [...expenses, ...incomes];
    combinedList.sort(
        (a, b) => (b['date'] as Timestamp).compareTo(a['date'] as Timestamp));

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: fetchDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Display a CircularProgressIndicator while waiting for data
          return Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        } else if (snapshot.hasError) {
          // Handle errors
          return Center(
            child: Text('Error loading data'),
          );
        } else {
          // Display the ListView when data is available
          return ListView.builder(
            padding: EdgeInsets.all(0.01.sw),
            itemCount: combinedList.length + 1,
            itemBuilder: (context, index) {
              if (index < combinedList.length) {
                return CombinedListItem(
                  data: combinedList[index],
                  documentId: combinedList[index]['id'],
                  useruid: widget.useruid,
                );
              } else {
                // Display a message when there is no more data to show
                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      'No more data to show',
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
}

class CombinedListItem extends StatelessWidget {
  final Map<String, dynamic> data;
  final String documentId;
  final String useruid;

  CombinedListItem({
    required this.data,
    required this.documentId,
    required this.useruid,
  });

  @override
  Widget build(BuildContext context) {
    // You can customize the appearance of each list item here
    String formattedDate = DateFormat.yMMMMd()
        .add_jm()
        .format((data['date'] as Timestamp).toDate());
    String type =
        data['type']; // Assuming 'type' is either 'income' or 'expense'
    bool isIncome = type == 'income';
    IconData categoryIcon = categoryIcons[data['category']] ??
        Icons.category; // Default icon if not found
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
                    top: data['category'] == 'Initial Amount' ? 0.015.sh : 0,
                    bottom:
                        data['category'] == 'Initial Amount' ? 0.004.sh : 0),
                child: Text(isIncome ? "Received from:" : "Paid for:",
                    style: TextStyle(
                        color: isIncome ? Colors.white60 : Colors.white70,
                        fontSize: 15.0.sp,
                        fontFamily: GoogleFonts.akshar().fontFamily,
                        letterSpacing: 1)),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 0.02.sw,
                    top: data['category'] == 'Initial Amount' ? 0.015.sh : 0,
                    bottom:
                        data['category'] == 'Initial Amount' ? 0.004.sh : 0),
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
                    top: data['category'] == 'Initial Amount' ? 0.015.sh : 0,
                    bottom:
                        data['category'] == 'Initial Amount' ? 0.004.sh : 0),
                child: Text('${data['category']}',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0.sp,
                        fontFamily: GoogleFonts.akshar().fontFamily,
                        letterSpacing: 2)),
              ),
              Padding(
                  padding: EdgeInsets.only(
                    left: 0.05.sw,
                  ),
                  child: data['category'] == 'Initial Amount'
                      ? null
                      : IconButton(
                          onPressed: () {
                            if (data['type'] == 'income') {
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    EditIncomeTransactionDialog(
                                  useruid: useruid,
                                  transactionData: data,
                                  documentId: documentId,
                                ),
                              );
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    EditExpenseTransactionDialog(
                                  useruid: useruid,
                                  transactionData: data,
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
              if (data['category'] == 'Initial Amount')
                SizedBox.shrink()
              else
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return DeleteIncomeExpense(
                              transactionData: data,
                              useruid: useruid,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 0.02.sw),
                child: Text(
                  '${data['paymentmethod']}',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Text(
                "(${formattedDate})",
                style: TextStyle(color: Colors.white70, fontSize: 11.0.sp),
              ),
              Padding(
                padding: EdgeInsets.only(right: 0.05.sw),
                child: Text('${isIncome ? '+' : '-'}${data['amount']}',
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
                  'Note: ${data['note']}',
                  style: TextStyle(color: Colors.white, fontSize: 12.0.sp),
                ),
              ),
            ],
          ),
        ],
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
