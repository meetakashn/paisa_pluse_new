import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../expenseswidget/expenseswidget.dart';
import '../../transactionlistview/combinedlistview/combinedlistview.dart';
import '../../transactionlistview/selectbydays/selectbydays.dart';
import 'expensebargraph.dart';
import 'expenselinegraph.dart';

class ExpenseOverview extends StatefulWidget {
  String useruid = "";

  ExpenseOverview({super.key, required this.useruid});

  @override
  State<ExpenseOverview> createState() => _ExpenseOverviewState();
}

class _ExpenseOverviewState extends State<ExpenseOverview> {
  List<Map<String, dynamic>> expenseList = [];
  List<Map<String, dynamic>> expenselinegraph = [];
  ExpenseOverviewLineGraph ExpenseOverviewlinegraph =
      new ExpenseOverviewLineGraph();
  ExpenseOverviewBarGraph ExpenseOverviewbargraph =
      new ExpenseOverviewBarGraph();

  String selectedOption = 'Last 28 days';
  String selectedExpenseDate = 'Last 28 days';
  String selectingExpenseBarDays = 'Last 28 days';
  String selectedExpenseCategory = "Groceries";
  String highestExpenseCategory = "Loading..";
  int totalExpenseDays = 0;
  DateTime? _selectedDate;
  String formattedDateString = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchdataofselecteddate();
    _handleSelectedOption("Last 28 days");
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
              height: 0.127.sh,
              decoration: const BoxDecoration(
                color: Colors.red,
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
                  Column(
                    children: [
                      // selecting days and adding expenses
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 0.02.sw),
                            child: DropdownButton<String>(
                              dropdownColor: Colors.black,
                              borderRadius: BorderRadius.circular(10),
                              icon: Icon(
                                Icons.arrow_drop_down_outlined,
                                color: Colors.white,
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
                                              color: Colors.white,
                                              fontSize: 15.0.sp)),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (String? newValue) {
                                _handleSelectedOption(newValue!);
                              },
                            ),
                          ),
                          TextButton(
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
                            child: Text('expense  +',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0.sp,
                                )),
                          ),
                        ],
                      ),
                      // total expense and most expense
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.orangeAccent,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(35),
                                ),
                                border: Border(
                                    top: BorderSide(color: Colors.black),
                                    right: BorderSide(color: Colors.black))),
                            height: 0.07.sh,
                            width: 0.50.sw,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  child: Image.asset(
                                      "assets/images/initialamount.png",
                                      width: 0.01.sw),
                                  width: 0.11.sw,
                                  height: 0.05.sh,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Highest Expense",
                                      style: TextStyle(
                                          fontSize: 15.0.sp,
                                          color: Colors.white,
                                          fontFamily:
                                              GoogleFonts.akshar().fontFamily,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1),
                                    ),
                                    Text(
                                      "- ${highestExpenseCategory}",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily:
                                              GoogleFonts.akshar().fontFamily,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 2,
                                          fontSize: 14.0.sp),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.orangeAccent,
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(35)),
                                border: Border(
                                    top: BorderSide(color: Colors.black),
                                    right: BorderSide(color: Colors.black))),
                            height: 0.070.sh,
                            width: 0.50.sw,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  child: Image.asset("assets/images/down.png",
                                      width: 0.02.sw, color: Colors.red),
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
                                      "Total Expenses",
                                      style: TextStyle(
                                          fontSize: 15.0.sp,
                                          color: Colors.white,
                                          fontFamily:
                                              GoogleFonts.akshar().fontFamily,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1),
                                    ),
                                    Text(
                                      "Rs.${totalExpenseDays}",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily:
                                              GoogleFonts.akshar().fontFamily,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 2,
                                          fontSize: 14.0.sp),
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
                ],
              ),
            ),
            //for line graph
            SizedBox(
              height: 0.05.sw,
            ),
            Divider(color: Colors.white54),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 0.025.sw),
                  child: Text(
                    "Category Analysis",
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 15.0.sp,
                        fontFamily: GoogleFonts.akshar().fontFamily),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 0.17.sw),
                  child: DropdownButton<String>(
                    dropdownColor: Colors.black,
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(left: 0.01.sw),
                    borderRadius: BorderRadius.circular(10),
                    icon: Icon(
                      Icons.arrow_drop_down_outlined,
                      color: Colors.white,
                      size: 18.0.sp,
                    ),
                    underline: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[Color(0XFFff9f00), Color(0XFFff7f00)],
                        ),
                      ),
                    ),
                    value: selectedExpenseCategory,
                    items: <String>[
                      'Groceries',
                      'Utilities',
                      'Transportation',
                      'Healthcare',
                      'Entertainment',
                      'Dining Out',
                      'Shopping',
                      'Home Maintenance',
                      'Travel',
                      'Miscellaneous',
                      'Education',
                    ]
                        .map<DropdownMenuItem<String>>(
                          (String value) => DropdownMenuItem<String>(
                            value: value,
                            alignment: Alignment.center,
                            child: Text(value,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 10.0.sp)),
                          ),
                        )
                        .toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedExpenseCategory = newValue!;
                      });
                    },
                  ),
                ),
                DropdownButton<String>(
                  dropdownColor: Colors.black,
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(right: 0.015.sw),
                  borderRadius: BorderRadius.circular(10),
                  icon: Icon(
                    Icons.arrow_drop_down_outlined,
                    color: Colors.white,
                    size: 18.0.sp,
                  ),
                  underline: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[Color(0XFFff9f00), Color(0XFFff7f00)],
                      ),
                    ),
                  ),
                  value: selectedExpenseDate,
                  items: <String>['Last 7 days', 'Last 28 days', 'Last 90 days']
                      .map<DropdownMenuItem<String>>(
                        (String value) => DropdownMenuItem<String>(
                          value: value,
                          alignment: Alignment.center,
                          child: Text(value,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 10.0.sp)),
                        ),
                      )
                      .toList(),
                  onChanged: (String? newValue) {
                    print(newValue!);
                    setState(() {
                      selectedExpenseDate = newValue;
                    });
                  },
                ),
              ],
            ),
            Container(
              width: 0.95.sw,
              height: 0.31.sh,
              decoration: BoxDecoration(
                /*gradient: const LinearGradient(colors: <Color>[
                        Color(0xFF002147),
                        Color(0xFF002366)
                      ]),*/
                color: Colors.white54,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 1, color: Colors.white),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 0.018.sh, right: 17),
                child: FutureBuilder<void>(
                  // Set the future to null since we don't need to return anything
                  future: fetchExpenseDataForLineGraph(widget.useruid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Display a circular progress indicator while data is being fetched
                      return Center(
                          child: CircularProgressIndicator(
                        color: Colors.white,
                      ));
                    } else if (snapshot.hasError) {
                      // Handle errors
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (expenselinegraph.isEmpty) {
                      // Data fetched successfully, display your LineChart
                      return Center(
                        child: Text(
                            "No Expense data found for $selectedExpenseCategory on $selectedExpenseDate",
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center),
                      );
                    } else {
                      return LineChart(
                        ExpenseOverviewlinegraph.mainData(expenselinegraph),
                      );
                    }
                  },
                ),
              ),
            ),
            //for bar graph
            SizedBox(
              height: 0.05.sw,
            ),
            Divider(color: Colors.white54),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 0.025.sw),
                  child: Text(
                    "Top Expense Category",
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 15.0.sp,
                        fontFamily: GoogleFonts.akshar().fontFamily),
                  ),
                ),
                DropdownButton<String>(
                  dropdownColor: Colors.black,
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(right: 0.015.sw),
                  borderRadius: BorderRadius.circular(10),
                  icon: Icon(
                    Icons.arrow_drop_down_outlined,
                    color: Colors.white,
                    size: 18.0.sp,
                  ),
                  underline: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[Color(0XFFff9f00), Color(0XFFff7f00)],
                      ),
                    ),
                  ),
                  value: selectingExpenseBarDays,
                  items: <String>['Last 7 days', 'Last 28 days', 'Last 90 days']
                      .map<DropdownMenuItem<String>>(
                        (String value) => DropdownMenuItem<String>(
                          value: value,
                          alignment: Alignment.center,
                          child: Text(value,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 10.0.sp)),
                        ),
                      )
                      .toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectingExpenseBarDays = newValue!;
                    });
                  },
                ),
              ],
            ),
            Container(
              width: 0.95.sw,
              height: 0.31.sh,
              decoration: BoxDecoration(
                color: Colors.white54,
                /*   gradient: LinearGradient(colors: <Color>[
                        Color(0xFFfdfd96),
                        Color(0xFFfffacd)
                      ]),*/
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 1, color: Colors.white),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 0.01.sh, right: 0.03.sw),
                child: FutureBuilder<BarChartData>(
                  future: ExpenseOverviewbargraph.mainData(
                      widget.useruid, selectingExpenseBarDays),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // While the future is still running, show a loading indicator
                      return Center(
                          child:
                              CircularProgressIndicator(color: Colors.black));
                    } else if (snapshot.hasError) {
                      // If there was an error in the future, show an error message
                      return Center(child: Text("Error: ${snapshot.error}"));
                    } else if (!snapshot.hasData) {
                      // If the future completed successfully but did not return data, handle it here
                      return Center(child: Text("No data available"));
                    } else {
                      // If the future completed successfully and returned data, build your UI with the data
                      return BarChart(snapshot.data!);
                    }
                  },
                ),
              ),
            ),
            //all income data by date and show all
            SizedBox(
              height: 0.05.sw,
            ),
            Divider(color: Colors.white54),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 0.021.sw),
                  child: Text(
                    "Overall Expense List",
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 15.0.sp,
                        fontFamily: GoogleFonts.akshar().fontFamily),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 0.25.sw),
                  child: TextButton(
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
                ),
                TextButton(
                  onPressed: () {
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
              height: 0.35.sh,
              margin: EdgeInsets.only(left: 0.02.sw, right: 0.02.sw),
              decoration: BoxDecoration(
                color: Colors.white54,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 1, color: Colors.white),
              ),
              child: FutureBuilder(
                future: _selectedDate != null
                    ? fetchAndDisplayexpenseDatabydate()
                    : fetchAndDisplayexpenseData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: Colors.white,
                    ));
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.white),
                    ));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text('Nothing to show.',
                            style: TextStyle(color: Colors.white)));
                  } else {
                    // Display the income data in a ListView
                    return ListView.builder(
                      itemCount: expenseList.length + 1,
                      itemBuilder: (context, index) {
                        // Customize the ListTile based on your data structure
                        if (index < expenseList.length) {
                          return CombinedListItem(
                            data: expenseList[index],
                            documentId: expenseList[index]['id'],
                            useruid: widget.useruid,
                          );
                        } else {
                          // Display a message when there is no more data to show
                          return const Padding(
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
    );
  }

  void _handleSelectedOption(String newValue) async {
    TotalExpenseService totalexpenseservice = new TotalExpenseService();
    HighestExpenseCategory mostexpensecategory = new HighestExpenseCategory();
    // Update the selected option
    setState(() {
      selectedOption = newValue;
    });
    // Perform actions based on the selected option
    switch (selectedOption) {
      case 'Last 7 days':
        totalExpenseDays = await totalexpenseservice.getTotalExpense(
            widget.useruid, 'Last 7 days');
        highestExpenseCategory = await mostexpensecategory
            .getHighestExpenseCategory(widget.useruid, 'Last 7 days');
        break;
      case 'Last 28 days':
        totalExpenseDays = await totalexpenseservice.getTotalExpense(
            widget.useruid, 'Last 28 days');
        highestExpenseCategory = await mostexpensecategory
            .getHighestExpenseCategory(widget.useruid, 'Last 28 days');
        break;
      case 'Last 90 days':
        totalExpenseDays = await totalexpenseservice.getTotalExpense(
            widget.useruid, 'Last 90 days');
        highestExpenseCategory = await mostexpensecategory
            .getHighestExpenseCategory(widget.useruid, 'Last 90 days');
        break;
    }
    setState(() {});
  }

  void _fetchdataofselecteddate() async {
    TotalExpenseService totalexpenseservice = new TotalExpenseService();
    totalExpenseDays = await totalexpenseservice.getTotalExpense(
        widget.useruid, 'Last 28 days');
    setState(() {});
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
      });
    }
    setState(() {
      FocusScope.of(context).unfocus();
    });

    // Format the DateTime object as needed
  }

  Future<List<Map<String, dynamic>>> fetchAndDisplayexpenseData() async {
    try {
      // Fetch income documents from Firebase based on the selected category
      QuerySnapshot<Map<String, dynamic>> expenseSnapshot =
          await FirebaseFirestore.instance
              .collection('user')
              .doc(widget.useruid)
              .collection('expenses')
              .get();

      // Extract data from documents
      List<Map<String, dynamic>> expenseData = expenseSnapshot.docs
          .map((doc) => {...doc.data(), 'id': doc.id})
          .toList();

      // Sort the data by date in descending order
      expenseData.sort((a, b) {
        DateTime dateA = (a['date'] as Timestamp).toDate();
        DateTime dateB = (b['date'] as Timestamp).toDate();
        return dateB.compareTo(
            dateA); // Use dateB.compareTo(dateA) for descending order
      });

      // Update the expenseList
      expenseList = expenseData.map((income) {
        return {'id': income['id'], ...income};
      }).toList();

      return expenseData;
    } catch (e) {
      print('Error fetching income data: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchAndDisplayexpenseDatabydate() async {
    try {
      // Convert formatted date string to DateTime
      DateTime selectedDateTime =
          DateFormat('MMMM d, yyyy').parse(formattedDateString);

      QuerySnapshot<Map<String, dynamic>> expenseSnapshot =
          await FirebaseFirestore.instance
              .collection('user')
              .doc(widget.useruid)
              .collection('expenses')
              .get();

      expenseList = expenseSnapshot.docs
          .where((doc) {
            DateTime expenseDate = (doc['date'] as Timestamp).toDate();
            DateTime expenseDateWithoutTime =
                DateTime(expenseDate.year, expenseDate.month, expenseDate.day);
            DateTime selectedDateWithoutTime = DateTime(selectedDateTime.year,
                selectedDateTime.month, selectedDateTime.day);
            return expenseDateWithoutTime
                .isAtSameMomentAs(selectedDateWithoutTime);
          })
          .map((doc) => {...doc.data(), 'id': doc.id})
          .toList();
      // If you also need the unfiltered data, you can use the following
      List<Map<String, dynamic>> expenseData = expenseSnapshot.docs
          .map((doc) => {...doc.data(), 'id': doc.id})
          .toList();

      return expenseData;
    } catch (e) {
      print('Error fetching expense data: $e');
      return [];
    }
  }

  Future<void> fetchExpenseDataForLineGraph(String userId) async {
    print("$selectedExpenseDate $selectedExpenseCategory");
    try {
      DateTime currentDate = DateTime.now();
      DateTime startDate;

      switch (selectedExpenseDate) {
        case 'Last 7 days':
          startDate = currentDate.subtract(Duration(days: 7));
          break;
        case 'Last 28 days':
          startDate = currentDate.subtract(Duration(days: 28));
          break;
        case 'Last 90 days':
          startDate = currentDate.subtract(Duration(days: 90));
          break;
        default:
          // Handle other cases or set a default start date
          startDate = currentDate.subtract(Duration(days: 7));
          break;
      }
      QuerySnapshot<Map<String, dynamic>> expenseSnapshot =
          await FirebaseFirestore.instance
              .collection('user')
              .doc(userId)
              .collection('expenses')
              .where('category', isEqualTo: selectedExpenseCategory)
              .get();
      expenselinegraph = expenseSnapshot.docs
          .where((doc) {
            DateTime expenseDate = (doc['date'] as Timestamp).toDate();
            return expenseDate.isAfter(startDate) &&
                expenseDate.isBefore(currentDate);
          })
          .map((doc) => doc.data())
          .toList();
    } catch (e) {
      print('Error fetching expense data: $e');
    }
  }
}
