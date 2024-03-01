import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../incomewidget/incomeaddwidget.dart';
import '../../transactionlistview/combinedlistview/combinedlistview.dart';
import '../../transactionlistview/selectbydays/selectbydays.dart';
import 'dashgraph.dart';
import 'incomebargraph.dart';

class IncomeOverview extends StatefulWidget {
  String useruid = "";

  IncomeOverview({super.key, required this.useruid});

  @override
  State<IncomeOverview> createState() => _IncomeOverviewState();
}
class _IncomeOverviewState extends State<IncomeOverview> {
  List<Map<String, dynamic>> incomeList = [];
  List<Map<String, dynamic>> incomelinegraph = [];
  IncomeOverviewLineGraph incomeoverviewlinegraph =
      new IncomeOverviewLineGraph();
  IncomeOverviewBarGraph incomeoverviewbargraph = new IncomeOverviewBarGraph();

  String selectedOption = 'Last 28 days';
  String selectedIncomeDate = 'Last 28 days';
  String selectingIncomeBarDays = 'Last 28 days';
  String selectedIncomeCategory = "Salary";
  String highestIncomeCategory = "Loading..";
  int totalincomedays = 0;
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
                color: Colors.green,
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
                      // selecting days and adding income
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 0.02.sw),
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
                          TextButton(
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
                            child: Text('income  +',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.0.sp,
                                )),
                          ),
                        ],
                      ),
                      // total income and most income
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
                                      "Highest Income",
                                      style: TextStyle(
                                          fontSize: 15.0.sp,
                                          color: Colors.white,
                                          fontFamily:
                                              GoogleFonts.akshar().fontFamily,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1),
                                    ),
                                    Text(
                                      "- ${highestIncomeCategory}",
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
                                      "Total Income",
                                      style: TextStyle(
                                          fontSize: 15.0.sp,
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
                  padding: EdgeInsets.only(left: 0.21.sw),
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
                    value: selectedIncomeCategory,
                    items: <String>[
                      'Salary',
                      'Freelance',
                      'Business',
                      'Investments',
                      'Gifts',
                      'Rent',
                      'Side Hustle',
                      'Refunds',
                      'Other'
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
                        selectedIncomeCategory = newValue!;
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
                  value: selectedIncomeDate,
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
                      selectedIncomeDate = newValue;
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
                  future: fetchIncomeDataForLineGraph(widget.useruid),
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
                    } else if (incomelinegraph.isEmpty) {
                      // Data fetched successfully, display your LineChart
                      return Center(
                        child: Text(
                            "No income data found for $selectedIncomeCategory on $selectedIncomeDate",
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center),
                      );
                    } else {
                      return LineChart(
                        incomeoverviewlinegraph.mainData(incomelinegraph),
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
                    "Top Income Category",
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
                  value: selectingIncomeBarDays,
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
                      selectingIncomeBarDays = newValue!;
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
                  future: incomeoverviewbargraph.mainData(
                      widget.useruid, selectingIncomeBarDays),
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
                    "Overall Income List",
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
                    ? fetchAndDisplayIncomeDatabydate()
                    : fetchAndDisplayIncomeData(),
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
                      itemCount: incomeList.length + 1,
                      itemBuilder: (context, index) {
                        // Customize the ListTile based on your data structure
                        if (index < incomeList.length) {
                          return CombinedListItem(
                            data: incomeList[index],
                            documentId: incomeList[index]['id'],
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
    TotalIncomeService totalincomeservice = new TotalIncomeService();
    HighestIncomeCategory mostincomecategory = new HighestIncomeCategory();
    // Update the selected option
    setState(() {
      selectedOption = newValue;
    });
    // Perform actions based on the selected option
    switch (selectedOption) {
      case 'Last 7 days':
        totalincomedays = await totalincomeservice.getTotalIncome(
            widget.useruid, 'Last 7 days');
        highestIncomeCategory = await mostincomecategory
            .getHighestIncomeCategory(widget.useruid, 'Last 7 days');
        break;
      case 'Last 28 days':
        totalincomedays = await totalincomeservice.getTotalIncome(
            widget.useruid, 'Last 28 days');
        highestIncomeCategory = await mostincomecategory
            .getHighestIncomeCategory(widget.useruid, 'Last 28 days');
        break;
      case 'Last 90 days':
        totalincomedays = await totalincomeservice.getTotalIncome(
            widget.useruid, 'Last 90 days');
        highestIncomeCategory = await mostincomecategory
            .getHighestIncomeCategory(widget.useruid, 'Last 90 days');
        break;
    }
    setState(() {});
  }

  void _fetchdataofselecteddate() async {
    TotalIncomeService totalincomeservice = new TotalIncomeService();
    totalincomedays =
        await totalincomeservice.getTotalIncome(widget.useruid, 'Last 28 days');
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

  Future<List<Map<String, dynamic>>> fetchAndDisplayIncomeData() async {
    try {
      // Fetch income documents from Firebase based on the selected category
      QuerySnapshot<Map<String, dynamic>> incomeSnapshot =
          await FirebaseFirestore.instance
              .collection('user')
              .doc(widget.useruid)
              .collection('incomes')
              .get();

      // Extract data from documents
      List<Map<String, dynamic>> incomeData = incomeSnapshot.docs
          .map((doc) => {...doc.data(), 'id': doc.id})
          .toList();

      // Sort the data by date in descending order
      incomeData.sort((a, b) {
        DateTime dateA = (a['date'] as Timestamp).toDate();
        DateTime dateB = (b['date'] as Timestamp).toDate();
        return dateB.compareTo(
            dateA); // Use dateB.compareTo(dateA) for descending order
      });

      // Update the incomeList
      incomeList = incomeData.map((income) {
        return {'id': income['id'], ...income};
      }).toList();

      return incomeData;
    } catch (e) {
      print('Error fetching income data: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchAndDisplayIncomeDatabydate() async {
    try {
      // Convert formatted date string to DateTime
      DateTime selectedDateTime =
          DateFormat('MMMM d, yyyy').parse(formattedDateString);

      QuerySnapshot<Map<String, dynamic>> incomeSnapshot =
          await FirebaseFirestore.instance
              .collection('user')
              .doc(widget.useruid)
              .collection('incomes')
              .get();

      incomeList = incomeSnapshot.docs
          .where((doc) {
            DateTime incomeDate = (doc['date'] as Timestamp).toDate();
            DateTime incomeDateWithoutTime =
                DateTime(incomeDate.year, incomeDate.month, incomeDate.day);
            DateTime selectedDateWithoutTime = DateTime(selectedDateTime.year,
                selectedDateTime.month, selectedDateTime.day);
            return incomeDateWithoutTime
                .isAtSameMomentAs(selectedDateWithoutTime);
          })
          .map((doc) => {...doc.data(), 'id': doc.id})
          .toList();
      // If you also need the unfiltered data, you can use the following
      List<Map<String, dynamic>> incomeData = incomeSnapshot.docs
          .map((doc) => {...doc.data(), 'id': doc.id})
          .toList();

      return incomeData;
    } catch (e) {
      print('Error fetching income data: $e');
      return [];
    }
  }

  Future<void> fetchIncomeDataForLineGraph(String userId) async {
    try {
      DateTime currentDate = DateTime.now();
      DateTime startDate;

      switch (selectedIncomeDate) {
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
      QuerySnapshot<Map<String, dynamic>> incomeSnapshot =
          await FirebaseFirestore.instance
              .collection('user')
              .doc(userId)
              .collection('incomes')
              .where('category', isEqualTo: selectedIncomeCategory)
              .get();
      incomelinegraph = incomeSnapshot.docs
          .where((doc) {
            DateTime incomeDate = (doc['date'] as Timestamp).toDate();
            return incomeDate.isAfter(startDate) &&
                incomeDate.isBefore(currentDate);
          })
          .map((doc) => doc.data())
          .toList();
    } catch (e) {
      print('Error fetching expense data: $e');
    }
  }
}
