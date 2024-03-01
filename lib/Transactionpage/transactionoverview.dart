import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:paisa_pluse_new/Transactionpage/remainderpage/setremainder.dart';
import 'package:paisa_pluse_new/expenseswidget/expenseswidget.dart';
import 'package:paisa_pluse_new/incomewidget/incomeaddwidget.dart';
import 'package:paisa_pluse_new/transactionlistview/combinedlistview/combinedlistview.dart';
import 'package:paisa_pluse_new/transactionlistview/editinitialamount/editinitialamount.dart';
import 'package:paisa_pluse_new/transactionlistview/selectbydays/selectbydays.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';

import '../transactionlistview/recent1transaction/recenttransactionwidget.dart';

class TransactionOverview extends StatefulWidget {
  String useruid = "";

  TransactionOverview({required this.useruid});

  @override
  State<TransactionOverview> createState() => _TransactionOverviewState();
}

class _TransactionOverviewState extends State<TransactionOverview>
    with SingleTickerProviderStateMixin {
  TotalExpenseService totalexpenseservice = new TotalExpenseService();
  TotalIncomeService totalincomeservice = new TotalIncomeService();
  List<Map<String, dynamic>> transactions = [];
  List<Map<String, dynamic>> expenseList = [];
  List<Map<String, dynamic>> incomeList = [];
  late AnimationController _animationController;
  DateTime? _selectedDate;
  String formattedDateString = "";
  int totalamount = 0;
  String stringtotalamount = "loading..";
  bool showbydate = false;
  String selectedOption = 'Last 28 days';
  int totalexpensedays = 0;
  int totalincomedays = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    fetchData();
    _fetchdataofselecteddate();
  }

  @override
  void dispose() {
    // Dispose of the AnimationController
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF003366),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: 1.sw,
              height: 0.18.sh,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[Color(0XFFff9f00), Color(0XFFff7f00)],
                ),
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(35),
                    bottomRight: Radius.circular(35)),
                border: Border(
                    bottom: BorderSide(width: 1, color: Colors.white),
                    top: BorderSide(width: 1, color: Colors.white)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 0.03.sw),
                        child: DropdownButton<String>(
                          dropdownColor: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          icon: Icon(
                            Icons.arrow_drop_down_outlined,
                            color: Colors.black,
                            size: 25.0.sp,
                          ),
                          underline: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: <Color>[
                                  Color(0XFFff9f00),
                                  Color(0XFFff7f00)
                                ],
                              ),
                            ),
                          ),
                          value: selectedOption,
                          items: <String>[
                            'Last 7 days',
                            'Last 28 days',
                            'Last 90 days'
                          ]
                              .map<DropdownMenuItem<String>>(
                                (String value) => DropdownMenuItem<String>(
                                  value: value,
                                  alignment: Alignment.center,
                                  child: Text(value,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15.0.sp)),
                                ),
                              )
                              .toList(),
                          onChanged: (String? newValue) {
                            _handleSelectedOption(newValue!);
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 0.01.sw),
                        child: TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return SetRemainder(
                                      useruid: widget
                                          .useruid); // Show the AddIncomeDialog
                                },
                              );
                            },
                            child: Row(
                              children: [
                                Text("Set Reminder ",
                                    style: TextStyle(color: Colors.white)),
                                Icon(Icons.notification_add),
                              ],
                            )),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 0.02.sw),
                        child: Text(
                          "Account balance:",
                          style: TextStyle(
                              fontSize: 15.0.sp,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              fontFamily: GoogleFonts.akshar().fontFamily,
                              letterSpacing: 1),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 0.029.sw),
                        child: Text(
                          "Rs. ${stringtotalamount}",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: GoogleFonts.akshar().fontFamily,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                              fontSize: 17.0.sp),
                        ),
                      ),
                      IconButton(
                          alignment: Alignment.topCenter,
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return EditInitialAmount(
                                      useruid: widget.useruid);
                                });
                          },
                          icon: Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 13.0.sp,
                          )),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.red.shade400,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(35),
                          ),
                        ),
                        height: 0.07.sh,
                        width: 0.50.sw,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              child: Image.asset("assets/images/down.png",
                                  width: 0.02.sw, color: Colors.redAccent),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              width: 0.07.sw,
                              height: 0.032.sh,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Expense",
                                  style: TextStyle(
                                      fontSize: 19.0.sp,
                                      color: Colors.white,
                                      fontFamily:
                                          GoogleFonts.akshar().fontFamily,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1),
                                ),
                                Text(
                                  "Rs.${totalexpensedays}",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily:
                                          GoogleFonts.akshar().fontFamily,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 2,
                                      fontSize: 18.0.sp),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.green.shade400,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(35)),
                        ),
                        height: 0.070.sh,
                        width: 0.50.sw,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              child: Image.asset("assets/images/arrow.png",
                                  width: 0.02.sw, color: Colors.green),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              width: 0.07.sw,
                              height: 0.032.sh,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Income",
                                  style: TextStyle(
                                      fontSize: 19.0.sp,
                                      color: Colors.white,
                                      fontFamily:
                                          GoogleFonts.akshar().fontFamily,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1),
                                ),
                                Text(
                                  "Rs.${totalincomedays}",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily:
                                          GoogleFonts.akshar().fontFamily,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 2,
                                      fontSize: 18.0.sp),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 0.01.sh,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 0.01.sw),
                  child: const Text(
                    "Recent transaction",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            Container(
              width: 1.sw,
              height: 0.11.sh,
              decoration: BoxDecoration(
                color: Colors.white60,
                borderRadius: BorderRadius.circular(15),
              ),
              child: RecentTransactionsWidget(userUid: widget.useruid),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedDate = null;
                    });
                  },
                  child: const Text(
                    'Show All',
                    style: TextStyle(fontSize: 10.0, color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedDate = null;
                    });
                    _selectDate(context);
                  },
                  child: Text(
                    '${_selectedDate != null ? "${_selectedDate!.day}-${_selectedDate!.month}-${_selectedDate!.year}" : "Select by date"}',
                    style: const TextStyle(fontSize: 10.0, color: Colors.white),
                  ),
                ),
              ],
            ),
            Container(
              width: 1.sw,
              height: 0.385.sh,
              padding: EdgeInsets.only(top: 0.01.sw, bottom: 0.01.sw),
              decoration: BoxDecoration(
                color: Colors.white60,
                borderRadius: BorderRadius.circular(15),
              ),
              child: FutureBuilder(
                future: _selectedDate != null
                    ? fetchTransactionsByDate()
                    : fetchAllTransactionData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: CircularProgressIndicator(
                      color: Colors.white,
                    ));
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text(
                      'Error: ${snapshot.error}',
                      style: TextStyle(color: Colors.white),
                    ));
                  } else if (!snapshot.hasData) {
                    return Center(
                        child: Text('Nothing to show.',
                            style: TextStyle(color: Colors.white)));
                  } else {
                    return ListView.builder(
                      itemCount: transactions.length + 1,
                      itemBuilder: (context, index) {
                        // Customize the ListTile based on your data structure
                        if (index < transactions.length) {
                          return CombinedListItem(
                            data: transactions[index],
                            documentId: transactions[index]['id'],
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
                                  color: Colors.white,
                                  fontSize: 10.0,
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        controller: _animationController,
        closedForegroundColor: Colors.black,
        openForegroundColor: Colors.black,
        closedBackgroundColor: Colors.white,
        openBackgroundColor: Colors.yellow,
        labelsBackgroundColor: Colors.white,
        labelsStyle: TextStyle(color: Colors.black, fontSize: 13.0.sp),
        speedDialChildren: [
          SpeedDialChild(
            child: const Icon(Icons.arrow_upward),
            foregroundColor: Colors.green,
            backgroundColor: Colors.white,
            label: 'Add income',
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return IncomeAddWidget(
                    useruid: widget.useruid,
                  ); // Show the AddIncomeDialog
                },
              );
            },
            closeSpeedDialOnPressed: true,
          ),
          SpeedDialChild(
            child: const Icon(Icons.arrow_downward),
            foregroundColor: Colors.red,
            backgroundColor: Colors.white,
            label: 'Add expense',
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ExpensesWidget(
                    useruid: widget.useruid,
                  ); // Show the AddIncomeDialog
                },
              );
            },
            closeSpeedDialOnPressed: true,
          ),
        ],
        child: Icon(
          Icons.add,
          size: 30.0.sp,
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialDatePickerMode: DatePickerMode.day,
      initialEntryMode: DatePickerEntryMode.calendar,
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        formattedDateString = DateFormat.yMMMMd().format(_selectedDate!);
        showbydate = true;
      });
    }
    setState(() {
      FocusScope.of(context).unfocus();
    });
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDocument(
      FirebaseFirestore firestore, String useruid) async {
    return await firestore.collection('user').doc(useruid).get();
  }

  Future<void> fetchData() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await getUserDocument(FirebaseFirestore.instance, widget.useruid);
      if (userDoc.exists) {
        setState(() {
          totalamount = userDoc.get('totalamount');
        });
      }
      stringtotalamount = formatAmount(totalamount);
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  String formatAmount(int amount) {
    final formatter = NumberFormat("#,###");
    String formattedAmount;

    if (amount >= 100000) {
      // If the amount is greater than or equal to 1 lakh, format as lakh
      double lakhAmount = amount / 100000;
      formattedAmount = NumberFormat("#,###.##").format(lakhAmount) + " Lakh";
    } else {
      // If the amount is less than 1 lakh, format normally
      formattedAmount = formatter.format(amount);
    }
    return formattedAmount;
  }

  void _handleSelectedOption(String newValue) async {
    TotalExpenseService totalexpenseservice = new TotalExpenseService();
    TotalIncomeService totalincomeservice = new TotalIncomeService();
    // Update the selected option
    setState(() {
      selectedOption = newValue;
    });
    // Perform actions based on the selected option
    switch (selectedOption) {
      case 'Last 7 days':
        totalexpensedays = await totalexpenseservice.getTotalExpense(
            widget.useruid, 'Last 7 days');
        totalincomedays = await totalincomeservice.getTotalIncome(
            widget.useruid, 'Last 7 days');
        break;
      case 'Last 28 days':
        totalexpensedays = await totalexpenseservice.getTotalExpense(
            widget.useruid, 'Last 28 days');
        totalincomedays = await totalincomeservice.getTotalIncome(
            widget.useruid, 'Last 28 days');
        break;
      case 'Last 90 days':
        totalexpensedays = await totalexpenseservice.getTotalExpense(
            widget.useruid, 'Last 90 days');
        totalincomedays = await totalincomeservice.getTotalIncome(
            widget.useruid, 'Last 90 days');
        break;
    }
    setState(() {});
  }

  void _fetchdataofselecteddate() async {
    TotalExpenseService totalexpenseservice = new TotalExpenseService();
    TotalIncomeService totalincomeservice = new TotalIncomeService();

    // Perform actions based on the selected option
    totalexpensedays = await totalexpenseservice.getTotalExpense(
        widget.useruid, 'Last 28 days');
    totalincomedays =
        await totalincomeservice.getTotalIncome(widget.useruid, 'Last 28 days');
    setState(() {});
  }

  //Fetching all the expense and income by date in combined
  Future<List<Map<String, dynamic>>> fetchTransactionsByDate() async {
    try {
      if (_selectedDate != null) {
        DateTime selectedDateTime =
            DateFormat('MMMM d, yyyy').parse(formattedDateString);

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
                        _selectedDate!.add(Duration(days: 1)).toUtc()))
                .get();

        QuerySnapshot<Map<String, dynamic>> incomeSnapshot =
            await FirebaseFirestore
                .instance
                .collection('user')
                .doc(widget.useruid)
                .collection('incomes')
                .where(
                    'date',
                    isGreaterThanOrEqualTo: Timestamp.fromDate(selectedDateTime
                        .toUtc()))
                .where(
                    'date',
                    isLessThan: Timestamp.fromDate(
                        _selectedDate!.add(Duration(days: 1)).toUtc()))
                .get();

        List<Map<String, dynamic>> expenses = expenseSnapshot.docs
            .map((doc) => {...doc.data(), 'id': doc.id})
            .toList();

        List<Map<String, dynamic>> incomes = incomeSnapshot.docs
            .map((doc) => {...doc.data(), 'id': doc.id})
            .toList();

        transactions = [...expenses, ...incomes];
        transactions.sort((a, b) =>
            (b['date'] as Timestamp).compareTo(a['date'] as Timestamp));

        return transactions;
      } else {
        return []; // Return an empty list if _selectedDate is null
      }
    } catch (e) {
      print('Error fetching transactions by date: $e');
      return [];
    }
  }

  //Fetching all the expense and income in combined
  Future<List<Map<String, dynamic>>> fetchAllTransactionData() async {
    try {
      // Retrieve expense data
      QuerySnapshot<Map<String, dynamic>> expenseSnapshot =
          await FirebaseFirestore.instance
              .collection('user')
              .doc(widget.useruid)
              .collection('expenses')
              .orderBy('date', descending: true)
              .get();
      List<Map<String, dynamic>> expenseList = expenseSnapshot.docs
          .map((doc) => {...doc.data(), 'id': doc.id})
          .toList();

      // Retrieve income data
      QuerySnapshot<Map<String, dynamic>> incomeSnapshot =
          await FirebaseFirestore.instance
              .collection('user')
              .doc(widget.useruid)
              .collection('incomes')
              .orderBy('date', descending: true)
              .get();
      List<Map<String, dynamic>> incomeList = incomeSnapshot.docs
          .map((doc) => {...doc.data(), 'id': doc.id})
          .toList();

      // Combine and sort the data
      transactions = [...expenseList, ...incomeList];
      transactions.sort(
        (a, b) => (b['date'] as Timestamp).compareTo(a['date'] as Timestamp),
      );

      return transactions;
    } catch (e) {
      print('Error fetching all transaction data: $e');
      return [];
    }
  }
}
