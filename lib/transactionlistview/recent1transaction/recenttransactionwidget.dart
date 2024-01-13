import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:paisa_pluse_new/transactionlistview/recent1transaction/transactiondatamodel.dart';
import 'package:paisa_pluse_new/transactionlistview/recent1transaction/transactionservice.dart';

class RecentTransactionsWidget extends StatelessWidget {
  final String userUid;

  RecentTransactionsWidget({required this.userUid});

  final RecentTransactionService transactionService =
      RecentTransactionService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: transactionService.getRecentTransactions(userUid),
      builder: (context, AsyncSnapshot<List<RecentTransactionModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(
            color: Colors.white,
          ));
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
              child: Text(
            'No recent transactions.',
            style: TextStyle(color: Colors.white),
          ));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              RecentTransactionModel transaction = snapshot.data![index];
              bool isIncome = transaction.type == 'income';
              IconData categoryIcon =
                  categoryIcons[transaction.category] ?? Icons.category;
              return Center(
                child: Container(
                  width: 1.sw,
                  height: 0.11.sh,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(15.0),
                    color:
                        isIncome ? Colors.green.shade500 : Colors.red.shade500,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 0.02.sw),
                            child: Text(
                              "${transaction.dateTime}",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 11.0.sp),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 0.02.sw),
                            child: Text(
                                isIncome ? "Received from:" : "Paid for:",
                                style: TextStyle(
                                    color: isIncome
                                        ? Colors.white60
                                        : Colors.white70,
                                    fontSize: 15.0.sp,
                                    fontFamily: GoogleFonts.akshar().fontFamily,
                                    letterSpacing: 1)),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 0.02.sw),
                            child: Icon(
                              categoryIcon,
                              color: Colors.white,
                              size: 16.0.sp,
                            ),
                          ),
                          SizedBox(
                            width: 0.011.sw,
                          ),
                          Text('${transaction.category}',
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
                              '${transaction.paymentMethod}',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 0.05.sw),
                            child: Text(
                                '${isIncome ? '+' : '-'}${transaction.amount}',
                                style: TextStyle(
                                    fontSize: 17.0.sp,
                                    color: isIncome
                                        ? Colors.white
                                        : Colors.white)),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 0.02.sw),
                        child: Text(
                          'Note: ${transaction.notes}',
                          style:
                              TextStyle(color: Colors.white, fontSize: 10.0.sp),
                        ),
                      ),

                      // Add more fields based on your data structure
                    ],
                  ),
                ),
              );
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
}
