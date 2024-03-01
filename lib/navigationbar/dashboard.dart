import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:paisa_pluse_new/graph/dashbargraph.dart';
import 'package:paisa_pluse_new/graph/dashgraph.dart';
import 'package:paisa_pluse_new/transactionlistview/recent5transaction/recenttransactionwidget.dart';
import 'package:paisa_pluse_new/utils/routes.dart';

import '../Transactionpage/remainderpage/remainderlistgetter/recenttransactionwidget.dart';
import '../fetchingdatafirebase/fetchingexpensecollection.dart';
import '../transactionlistview/selectbydays/selectbydays.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  DashboardLineGraph dashboardGraph = new DashboardLineGraph();

  final FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  List<Map<String, dynamic>> expenseData = [];
  var Username = "loading...";
  var imageurl = "";
  int totalamount = 0;
  String formattedAmount = "loading...";
  String totalincome = "";
  String totalexpense = "";
  int? amount;
  DashboardBarGraph dashboardbargraph = new DashboardBarGraph();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = auth.currentUser;
    fetchData();
    ExpenseandIncomeDays();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) {
          if (didPop) {
            return;
          }
          SystemNavigator.pop();
        },
        child: Scaffold(
          backgroundColor: const Color(0xFF003366),
          body: ListView(
            children: [
              Column(
                children: [
                  Container(
                    width: 1.sw,
                    height: 0.11.sh,
                    decoration: BoxDecoration(
                        color: Colors.orange.shade300,
                        border: const Border(
                          bottom: BorderSide(width: 1, color: Colors.white),
                          top: BorderSide.none,
                          right: BorderSide.none,
                          left: BorderSide.none,
                        )),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 0.03.sw),
                          child: Container(
                            width: 0.2.sw, // Adjust the width as needed
                            height: 0.09.sh, // Adjust the height as needed
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(width: 1)),
                            child: buildProfileImage(),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 0.0145.sh, left: 0.018.sw),
                              child: Text(
                                "$Username",
                                style: TextStyle(
                                    fontSize: 16.0.sp,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: GoogleFonts.akshar().fontFamily,
                                    letterSpacing: 2),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 0.018.sw),
                              child: Text(
                                "Rs.$formattedAmount",
                                style: TextStyle(
                                    fontSize: 20.0.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: GoogleFonts.akshar().fontFamily,
                                    letterSpacing: 2),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 0.018.sw),
                              child: Text(
                                "Current balance",
                                style: TextStyle(
                                    fontSize: 16.0.sp,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: GoogleFonts.akshar().fontFamily,
                                    letterSpacing: 2),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 0.010.sh, left: 0.013.sw),
                        child: Text(
                          "Transaction overview",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.0.sp,
                              fontFamily: GoogleFonts.akshar().fontFamily),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(top: 0.0165.sh, right: 0.019.sw),
                        child: Text(
                          "Last 28 days",
                          style: TextStyle(
                              color: Colors.white60,
                              fontSize: 15.0.sp,
                              fontFamily: GoogleFonts.akshar().fontFamily),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 1.sw,
                    height: 0.085.sh,
                    //color: Colors.green,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: 0.001.sh, bottom: 0.001.sh, left: 0.01.sw),
                          child: Container(
                            width: 0.48.sw,
                            height: 0.09.sh,
                            decoration: BoxDecoration(
                                color: Colors.white60,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                border: Border.all(width: 1)),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 0.02.sw, top: 0.005.sh),
                                      child: Text(
                                        "Expenses",
                                        style: TextStyle(
                                          color: const Color(0xFF003366),
                                          fontSize: 18.0.sp,
                                          fontFamily:
                                              GoogleFonts.lato().fontFamily,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 0.08.sw,
                                    ),
                                    Text(
                                      "- $totalexpense",
                                      style: TextStyle(
                                          fontSize: 20.0.sp,
                                          color: Colors.white),
                                    ),
                                    SizedBox(
                                      width: 0.03.sw,
                                    ),
                                    Image.asset(
                                      "assets/images/down.png",
                                      width: 0.06.sw,
                                      height: 0.04.sh,
                                      color: Colors.red.shade600,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 0.001.sh,
                              bottom: 0.001.sh,
                              left: 0.01.sw,
                              right: 0.01.sw),
                          child: Container(
                            width: 0.48.sw,
                            height: 0.09.sh,
                            decoration: BoxDecoration(
                              color: Colors.white60,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              border: Border.all(width: 1),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 0.02.sw, top: 0.005.sh),
                                      child: Text(
                                        "Income",
                                        style: TextStyle(
                                          color: const Color(0xFF003366),
                                          fontSize: 18.0.sp,
                                          fontFamily:
                                              GoogleFonts.lato().fontFamily,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 0.08.sw,
                                    ),
                                    Text(
                                      "+ $totalincome",
                                      style: TextStyle(
                                          fontSize: 20.0.sp,
                                          color: Colors.white),
                                    ),
                                    SizedBox(
                                      width: 0.03.sw,
                                    ),
                                    Image.asset(
                                      "assets/images/arrow.png",
                                      width: 0.06.sw,
                                      height: 0.04.sh,
                                      color: Colors.green.shade600,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: 0.010.sh, left: 0.013.sw, bottom: 0.001.sh),
                        child: Text(
                          "Recent Transaction",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.0.sp,
                              fontFamily: GoogleFonts.akshar().fontFamily),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(top: 0.0165.sh, right: 0.019.sw),
                        child: Text(
                          "Last 5",
                          style: TextStyle(
                              color: Colors.white60,
                              fontSize: 15.0.sp,
                              fontFamily: GoogleFonts.akshar().fontFamily),
                        ),
                      ),
                    ],
                  ),
                  Container(
                      width: 0.95.sw,
                      height: 0.356.sh,
                      decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white)),
                      child: RecentTransactionsWidget(
                        userUid: user!.uid,
                      )),
                  SizedBox(
                    height: 0.01.sh,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: 0.005.sh, left: 0.013.sw, bottom: 0.001.sh),
                        child: Text(
                          "Expense Analysis",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.0.sp,
                              fontFamily: GoogleFonts.akshar().fontFamily),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(top: 0.0165.sh, right: 0.019.sw),
                        child: Text(
                          "Last 10 days",
                          style: TextStyle(
                              color: Colors.white60,
                              fontSize: 15.0.sp,
                              fontFamily: GoogleFonts.akshar().fontFamily),
                        ),
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
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 1, color: Colors.white),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: 0.018.sh, right: 17),
                      child: FutureBuilder<void>(
                        // Set the future to null since we don't need to return anything
                        future: fetchExpenseData(user!.uid),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            // Display a circular progress indicator while data is being fetched
                            return Center(
                                child: CircularProgressIndicator(
                              color: Colors.white,
                            ));
                          } else if (snapshot.hasError) {
                            // Handle errors
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if(!snapshot.hasData){return Center(child: Text("No data found for Last 10 Days"),);}else {
                            // Data fetched successfully, display your LineChart
                            return LineChart(
                              dashboardGraph.mainData(expenseData),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: 0.015.sh, left: 0.013.sw, bottom: 0.001.sh),
                        child: Text(
                          "Top Expense Categories",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.0.sp,
                              fontFamily: GoogleFonts.akshar().fontFamily),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(top: 0.0165.sh, right: 0.019.sw),
                        child: Text(
                          "Last 28 days",
                          style: TextStyle(
                              color: Colors.white60,
                              fontSize: 15.0.sp,
                              fontFamily: GoogleFonts.akshar().fontFamily),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 0.95.sw,
                    height: 0.31.sh,
                    decoration: BoxDecoration(
                      color: Colors.white70,
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
                        future: DashboardBarGraph().mainData(user!.uid),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            // While the future is still running, show a loading indicator
                            return Center(
                                child: CircularProgressIndicator(
                                    color: Colors.black));
                          } else if (snapshot.hasError) {
                            // If there was an error in the future, show an error message
                            return Center(
                                child: Text("Error: ${snapshot.error}"));
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: 0.015.sh, left: 0.015.sw, bottom: 0.001.sh),
                        child: Text(
                          "Reminders",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.0.sp,
                              fontFamily: GoogleFonts.akshar().fontFamily),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      width: 0.95.sw,
                      height: 0.28.sh,
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        /* gradient: LinearGradient(colors: <Color>[
                          Color(0xFF75754),
                          Color(0xFF6445454)
                        ]),*/
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 1, color: Colors.white),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(top: 0.005.sh),
                        child: RemainderListDash(userUid: user!.uid),
                      ),
                    ),
                    onTap: () {
                      Navigator.pushReplacementNamed(
                          context, MyRoutes.reminderpage);
                    },
                  ),
                  SizedBox(height: 0.01.sh),
                ],
              ),
            ],
          ),
        ));
  }

  Future<void> fetchData() async {
    expenseData = await fetchExpenseData(user!.uid);
    try {
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await getUserDocument(FirebaseFirestore.instance, user!.uid);
      if (userDoc.exists) {
        setState(() {
          Username = userDoc.get('username');
          imageurl = userDoc.get('profileurl');
          totalamount = userDoc.get('totalamount');
          formattedAmount = formatAmount(totalamount);
        });
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDocument(
      FirebaseFirestore firestore, String useruid) async {
    return await firestore.collection('user').doc(useruid).get();
  }

  Widget buildProfileImage() {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: getUserDocument(FirebaseFirestore.instance, user!.uid),
      builder: (BuildContext context,
          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error fetching data: ${snapshot.error}'));
        } else {
          DocumentSnapshot userDoc = snapshot.data!;
          String imageUrl = userDoc.get('profileurl');
          return CircleAvatar(
            radius: 80,
            backgroundImage: NetworkImage(imageUrl, scale: 1.0),
          );
        }
      },
    );
  }

  Future<void> ExpenseandIncomeDays() async {
    TotalExpenseService totalexpenseservice = new TotalExpenseService();
    TotalIncomeService totalincomeservice = new TotalIncomeService();
    int totalexpenseint =
        await totalexpenseservice.getTotalExpense(user!.uid, 'Last 28 days');
    int totalincomeint =
        await totalincomeservice.getTotalIncome(user!.uid, 'Last 28 days');
    totalincome = formatAmount(totalincomeint);
    totalexpense = formatAmount(totalexpenseint);
    setState(() {});
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
}
