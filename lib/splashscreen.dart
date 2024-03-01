import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'utils/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;

  @override
  void initState() {
    super.initState();
    user = auth.currentUser;
    _navigator();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _navigator() async {
    await Future.delayed(Duration(milliseconds: 2000), () {});
    Navigator.pushReplacementNamed(
      context,
      user != null ? MyRoutes.homepage : MyRoutes.signingpage,
    );
  }

  @override
  Widget build(BuildContext context) {
    if(user!=null) keepLastThreeMonths(user!.uid);
    return Scaffold(
      body: Center(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/paisalogopng.png',
                width: 0.4.sw,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Paisa ",
                    style: TextStyle(
                        fontFamily: GoogleFonts.lato().fontFamily,
                        fontSize: 24.0.sp,
                        color: Color(0xFF003366),
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    "Pulse",
                    style: TextStyle(
                        fontFamily: GoogleFonts.lato().fontFamily,
                        fontSize: 23.0.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.orange),
                  ),
                ],
              ),
              Text(
                "Smart Spending Starts Here",
                style: TextStyle(
                    fontFamily: GoogleFonts.lato().fontFamily, fontSize: 14.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> keepLastThreeMonths(String userUid) async {
    // If month is negative, wrap around to the previous year
    String monthToDelete = getMonthName(DateTime.now().month - 4);
    CollectionReference<Map<String, dynamic>> budgetCollection =
    FirebaseFirestore.instance.collection('budget').doc(userUid).collection(monthToDelete);

    // Get all documents within the collection
    QuerySnapshot<Map<String, dynamic>> documentsSnapshot = await budgetCollection.get();

    // Delete the entire subcollection
    for (QueryDocumentSnapshot<Map<String, dynamic>> document in documentsSnapshot.docs) {
      await budgetCollection.doc(document.id).delete();
    }
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
    }
    else{
      return getMonthName(month + 12);
    }
  }
}
