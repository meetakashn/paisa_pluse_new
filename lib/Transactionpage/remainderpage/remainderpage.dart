import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paisa_pluse_new/Transactionpage/remainderpage/pastreminderpage/recenttransactionwidget.dart';
import 'package:paisa_pluse_new/homepage/homepage.dart';

import '../../utils/routes.dart';
import 'reminderaccountpage/recenttransactionwidget.dart';
import 'setremainder.dart';

class ReminderPage extends StatefulWidget {
  String useruid = "";
  ReminderPage({required this.useruid});

  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  int totalIncomeAmount = 0;
  int totalExpenseAmount = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTotalIncomeAmount(widget.useruid);
    getTotalExpenseAmount(widget.useruid);
  }
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }
        Navigator.pushReplacementNamed(context, MyRoutes.accountpage);
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF003366),
        appBar: AppBar(
          backgroundColor: const Color(0xFF003366),
          elevation: 1,
          toolbarHeight: 0.05.sh,
          // Set the toolbar height
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, MyRoutes.accountpage);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
          title: Padding(
            padding: EdgeInsets.only(top: 0.003.sh),
            child: RichText(
              text: TextSpan(children: <TextSpan>[
                TextSpan(
                  text: "Paisa",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 28.0.sp,
                      fontFamily: GoogleFonts.akshar().fontFamily,
                      fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: " Pulse",
                  style: TextStyle(
                      color: Colors.orange,
                      fontSize: 28.0.sp,
                      fontFamily: GoogleFonts.akshar().fontFamily,
                      fontWeight: FontWeight.bold),
                )
              ]),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 0.115.sh,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.orange.shade300,
                    border: const Border(bottom: BorderSide(color: Colors.white))),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Reminder Page",
                          style: TextStyle(fontSize: 20.0.sp,color: Colors.black,fontWeight: FontWeight.bold),
                        ),
                    TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return SetRemainder(
                                  useruid:
                                      widget.useruid); // Show the AddIncomeDialog
                            },
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.only(left: 0.05.sw),
                          child: Row(
                            children: [
                              Text("Set Reminder ",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 11.0.sp)),
                              Icon(
                                Icons.notification_add,
                                color: Colors.black,
                                size: 11.0.sp,
                              ),
                            ],
                          ),
                        )),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("To Receive",
                                style: TextStyle(
                                    fontSize: 16.0.sp,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: GoogleFonts.akshar().fontFamily,
                                    letterSpacing: 2,
                                    color: Colors.black)),
                            Text(
                              "Rs,${totalIncomeAmount}",
                              style: TextStyle(
                                  fontSize: 16.0.sp,
                                  fontFamily: GoogleFonts.akshar().fontFamily,
                                  color: Colors.black87),
                            )
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("To Pay",
                                style: TextStyle(
                                    fontSize: 16.0.sp,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: GoogleFonts.akshar().fontFamily,
                                    letterSpacing: 2,
                                    color: Colors.black)),
                            Text(
                              "Rs,${totalExpenseAmount}",
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 16.0.sp,
                                  fontFamily: GoogleFonts.akshar().fontFamily),
                            )
                          ],
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
                    padding: EdgeInsets.only(
                        top: 0.015.sh, left: 0.028.sw, bottom: 0.001.sh),
                    child: Text(
                      "Current Reminders:${getMonthName(DateTime.now().month)},${DateTime.now().year}",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0.sp,
                          fontFamily: GoogleFonts.lato().fontFamily),
                    ),
                  ),
                ],
              ),
              Container(
                width: 0.95.sw,
                height: 0.36.sh,
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1, color: Colors.white),
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 0.005.sh),
                  child: RemainderList(userUid: widget.useruid),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: 0.015.sh, left: 0.028.sw, bottom: 0.001.sh),
                    child: Text(
                      "Past Reminders:",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0.sp,
                          fontFamily: GoogleFonts.lato().fontFamily),
                    ),
                  ),
                ],
              ),
              Container(
                width: 0.95.sw,
                height: 0.34.sh,
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1, color: Colors.white),
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 0.005.sh),
                  child: PastReminderList(userUid: widget.useruid),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getMonthName(int month) {
    if (month >= 1 && month <= 12) {
      switch (month) {
        case 1:
          return 'January';
        case 2:
          return 'February';
        case 3:
          return 'March';
        case 4:
          return 'April';
        case 5:
          return 'May';
        case 6:
          return 'June';
        case 7:
          return 'July';
        case 8:
          return 'August';
        case 9:
          return 'September';
        case 10:
          return 'October';
        case 11:
          return 'November';
        case 12:
          return 'December';
        default:
          return '';
      }
    } else {
      return getMonthName(month + 12);
    }
  }

  Future<void> getTotalIncomeAmount(String userUid) async {
    try {
      int totalAmount = 0;
      // Query the remainder collection based on the type (income or expense)
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      DateTime currentDate = DateTime.now();
      QuerySnapshot remainderSnapshot = await _firestore
          .collection('user')
          .doc(userUid)
          .collection('remainder')
          .where('type', isEqualTo: 'income')
          .get();
      List<QueryDocumentSnapshot> filteredDocuments = remainderSnapshot.docs
          .where((doc) {
        DateTime currentDate = DateTime.now();
        DateTime documentDate = (doc['date'] as Timestamp).toDate();

        // Compare documentDate with currentDate
        return documentDate.isAfter(currentDate) || documentDate.isAtSameMomentAs(currentDate);
      })
          .toList();

      // Sum up the amounts
      filteredDocuments.forEach((doc) {
        totalAmount += doc['amount'] as int;
      });
      setState(() {
        totalIncomeAmount=totalAmount;
      });

    } catch (e) {
      print('Error fetching total amount: $e');

    }
  }
  Future<void> getTotalExpenseAmount(String userUid) async {
    try {
      int totalAmount = 0;
      // Query the remainder collection based on the type (income or expense)
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      DateTime currentDate = DateTime.now();
      QuerySnapshot remainderSnapshot = await _firestore
          .collection('user')
          .doc(userUid)
          .collection('remainder')
          .where('type', isEqualTo: 'expense')
          .get();
      List<QueryDocumentSnapshot> filteredDocuments = remainderSnapshot.docs
          .where((doc) {
        DateTime currentDate = DateTime.now();
        DateTime documentDate = (doc['date'] as Timestamp).toDate();

        // Compare documentDate with currentDate
        return documentDate.isAfter(currentDate) || documentDate.isAtSameMomentAs(currentDate);
      })
          .toList();

      // Sum up the amounts
      filteredDocuments.forEach((doc) {
        totalAmount += doc['amount'] as int;
      });
      setState(() {
        totalExpenseAmount=totalAmount;
      });

    } catch (e) {
      print('Error fetching total amount: $e');

    }
  }
}
