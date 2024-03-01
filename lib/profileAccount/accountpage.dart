import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paisa_pluse_new/homepage/homepage.dart';

import '../utils/routes.dart';

class AccountNav extends StatefulWidget {
  const AccountNav({super.key});

  @override
  State<AccountNav> createState() => _AccountNavState();
}

class _AccountNavState extends State<AccountNav> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? user;

  @override
  Widget build(BuildContext context) {
    user = auth.currentUser;
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }
        Navigator.pushReplacementNamed(context, MyRoutes.homepage);
        setState(() {
          HomePage.page=0;
          HomePage.initialpageindex=0;
        });
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF003366),
        appBar: AppBar(
          toolbarHeight: 50,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Padding(
            padding: EdgeInsets.only(left: 0.01.sw),
            child: IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(
                    context, MyRoutes.homepage);
                setState(() {
                  HomePage.page=0;
                  HomePage.initialpageindex=0;
                });
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 25.sp,
              ),
            ),
          ),
          title: Text(
            "Account",
            style: TextStyle(
                fontFamily: GoogleFonts.aBeeZee().fontFamily,
                fontSize: 18.sp,
                color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 0.03.sw, horizontal: 0.02.sw),
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, MyRoutes.profilepage);
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.account_circle_outlined,
                        color: Colors.white54,
                        size: 28.sp,
                      ),
                      SizedBox(
                        width: 0.025.sw,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Profile",
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: GoogleFonts.lato().fontFamily)),
                          SizedBox(
                            height: 0.06.h,
                          ),
                          Text(
                            "update name, phone number or email",
                            style: TextStyle(
                                fontSize: 11.sp,
                                color: Colors.white54,
                                fontWeight: FontWeight.w700,
                                fontFamily: GoogleFonts.lato().fontFamily),
                          ),
                        ],
                      ),
                      Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 18.sp,
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 0.01.sh,
                thickness: 2.sp,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 0.03.sw, horizontal: 0.02.sw),
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, MyRoutes.reminderpage, (route) => false);
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.notifications_none,
                        color: Colors.white54,
                        size: 28.sp,
                      ),
                      SizedBox(
                        width: 0.025.sw,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Set Reminders",
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: GoogleFonts.lato().fontFamily)),
                          SizedBox(
                            height: 0.06.h,
                          ),
                          Text(
                            "Schedule Your Reminders Easily",
                            style: TextStyle(
                                fontSize: 11.sp,
                                color: Colors.white54,
                                fontWeight: FontWeight.w700,
                                fontFamily: GoogleFonts.lato().fontFamily),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 18.sp,
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 0.01.sh,
                thickness: 2.sp,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 0.03.sw, horizontal: 0.02.sw),
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, MyRoutes.helpuspage, (route) => false);
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.help_outline,
                        color: Colors.white54,
                        size: 28.sp,
                      ),
                      SizedBox(
                        width: 0.025.sw,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Help",
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: GoogleFonts.lato().fontFamily)),
                          SizedBox(
                            height: 0.06.h,
                          ),
                          Text(
                            "Trouble?  We've Got You!",
                            style: TextStyle(
                                fontSize: 11.sp,
                                color: Colors.white54,
                                fontWeight: FontWeight.w700,
                                fontFamily: GoogleFonts.lato().fontFamily),
                          ),
                        ],
                      ),
                      Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 18.sp,
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 0.01.sh,
                thickness: 2.sp,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 0.03.sw, horizontal: 0.02.sw),
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, MyRoutes.aboutuspage);
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.verified_outlined,
                        color: Colors.white54,
                        size: 28.sp,
                      ),
                      SizedBox(
                        width: 0.025.sw,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("About Us",
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: GoogleFonts.lato().fontFamily)),
                          SizedBox(
                            height: 0.06.h,
                          ),
                          Text(
                            "Explore our app to get information",
                            style: TextStyle(
                                fontSize: 11.sp,
                                color: Colors.white54,
                                fontWeight: FontWeight.w700,
                                fontFamily: GoogleFonts.lato().fontFamily),
                          ),
                        ],
                      ),
                      Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 18.sp,
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 0.01.sh,
                thickness: 2.sp,
              ),
              SizedBox(
                height: 0.4.sh,
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 0.03.sh),
                child: TextButton(
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Logout'),
                            content: Text('Are you sure you want to logout?'),
                            actions: <Widget>[
                              TextButton(
                                child: Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text('Logout'),
                                onPressed: () async {
                                  await FirebaseAuth.instance.signOut();
                                  Navigator.pushNamedAndRemoveUntil(context,
                                      MyRoutes.signingpage, (route) => false);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text(
                      "Logout",
                      style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black,
                          fontFamily: GoogleFonts.lato().fontFamily,
                          letterSpacing: 1),
                    ),
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(width: 1, color: Colors.black)),
                      backgroundColor: Colors.yellow,
                      fixedSize: Size(double.maxFinite, 50.h),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

}
