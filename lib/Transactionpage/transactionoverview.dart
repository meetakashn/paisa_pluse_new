import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:paisa_pluse_new/expenseswidget/expenseswidget.dart';
import 'package:paisa_pluse_new/incomewidget/incomeaddwidget.dart';
import 'package:paisa_pluse_new/transactionlistview/combinedlistview/combinedlistview.dart';
import 'package:paisa_pluse_new/transactionlistview/editinitialamount/editinitialamount.dart';
import 'package:paisa_pluse_new/transactionlistview/selectbydays/selectbydays.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';

import '../transactionlistview/recent1transaction/recenttransactionwidget.dart';
import '../transactionlistview/selectbydate/selectbydate.dart';

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
              height: 0.25.sh,
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
                        child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.search,
                              size: 0.028.sh,
                              color: Colors.white,
                            )),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Total Amount",
                            style: TextStyle(
                                fontSize: 20.0.sp,
                                color: Colors.white,
                                fontFamily: GoogleFonts.akshar().fontFamily,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 0.029.sw),
                                child: Text(
                                  "Rs.${stringtotalamount}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily:
                                          GoogleFonts.akshar().fontFamily,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 2,
                                      fontSize: 20.0.sp),
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
                                    size: 17.0.sp,
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 0.074.sh,
                        width: 0.35.sw,
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
                                      fontSize: 22.0.sp,
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
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 0.074.sh,
                        width: 0.35.sw,
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
                                      fontSize: 22.0.sp,
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
              height: 0.402.sh,
              padding: EdgeInsets.only(top: 0.01.sw, bottom: 0.01.sw),
              decoration: BoxDecoration(
                color: Colors.white60,
                borderRadius: BorderRadius.circular(15),
              ),
              child: _selectedDate != null
                  ? TransactionsListPage(
                      useruid: widget.useruid,
                      selectedDate: formattedDateString)
                  : CombinedListPage(useruid: widget.useruid),
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

    // Format the DateTime object as needed
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

    // Perform actions based on the selected option
    switch (selectedOption) {
      case 'Last 7 days':
        totalexpensedays = await totalexpenseservice.getTotalExpense(
            widget.useruid, 'Last 7 days');
        totalincomedays = await totalincomeservice.getTotalIncome(
            widget.useruid, 'Last 7 days');
        break;
      case 'Last 28 days':
        totalexpenseservice.getTotalExpense(widget.useruid, 'Last 28 days');
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

    // Update the selected option
    setState(() {
      selectedOption = newValue;
    });
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
}
