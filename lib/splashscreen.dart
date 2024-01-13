import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paisa_pluse_new/homepage/homepage.dart';

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
}
