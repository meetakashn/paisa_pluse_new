import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paisa_pluse_new/loginpage/signin.dart';
import 'package:paisa_pluse_new/navigationbar/budgetplanner/budgetplanner.dart';
import 'package:paisa_pluse_new/navigationbar/categorypage/categorypage.dart';
import 'package:paisa_pluse_new/navigationbar/dashboard.dart';
import 'package:paisa_pluse_new/navigationbar/transactionmain.dart';

import '../utils/routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static int initialpageindex = 0;
  static int page = 0;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  final FirebaseAuth auth = FirebaseAuth.instance;
  User? user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = auth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }
        _showBackDialog(context);
      },
      child: Scaffold(
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
                Icons.menu,
                color: Colors.white,
              )) ,
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
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          height: 0.072.sh,
          index: HomePage.initialpageindex,
          items: [
            CurvedNavigationBarItem(
              child: const Icon(
                Icons.dashboard,
                color: Colors.white,
              ),
              label: 'Dashboard',
              labelStyle: TextStyle(
                  color: Colors.black,
                  fontFamily: GoogleFonts.akshar().fontFamily),
            ),
            CurvedNavigationBarItem(
              child: const Icon(
                Icons.attach_money_sharp,
                color: Colors.white,
              ),
              label: 'Transaction',
              labelStyle: TextStyle(
                  color: Colors.black,
                  fontFamily: GoogleFonts.akshar().fontFamily),
            ),
            CurvedNavigationBarItem(
              child: const Icon(
                Icons.category_outlined,
                color: Colors.white,
              ),
              label: 'Categories',
              labelStyle: TextStyle(
                  color: Colors.black,
                  fontFamily: GoogleFonts.akshar().fontFamily),
            ),
            CurvedNavigationBarItem(
              child: const Icon(
                Icons.calculate,
                color: Colors.white,
              ),
              label: 'Budget',
              labelStyle: TextStyle(
                  color: Colors.black,
                  fontFamily: GoogleFonts.akshar().fontFamily),
            ),
          ],
          color: Colors.orange.shade600,
          buttonBackgroundColor: _colorButton(),
          backgroundColor: const Color(0xFF003366),
          animationCurve: Curves.easeInOutQuart,
          animationDuration: const Duration(milliseconds: 600),
          onTap: (index) {
            setState(() {
              HomePage.page = index;
            });
          },
          letIndexChange: (index) => true,
        ),
        body: _buildPage(),
      ),
    );
  }

  _colorButton() {
    switch (HomePage.page) {
      case 0:
        return Colors.red;
      case 1:
        return Colors.blue;
      case 2:
        return Colors.deepOrange;
      default:
        return Colors.lightBlue;
    }
  }

  Widget _buildPage() {
    switch (HomePage.page) {
      case 0:
        return const DashBoard();
      case 1:
        return const TransactionMain();
      case 2:
        return CategoryPage(
          useruid: user!.uid,
        );
      case 3:
        return BudgetPlanner(useruid: user!.uid,);
      case 4:
        return const SignIn();
      default:
        return Container(); // Handle other cases or return a default page
    }
  }

  void _showBackDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text(
            'Are you sure you want to leave this page?',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Nevermind'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Leave'),
              onPressed: () {
                SystemNavigator.pop();
              },
            ),
          ],
        );
      },
    );
  }
}
