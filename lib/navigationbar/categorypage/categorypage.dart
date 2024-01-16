import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:paisa_pluse_new/navigationbar/categorypage/expensecategorypage.dart';
import 'package:paisa_pluse_new/navigationbar/categorypage/incomecategorypage.dart';
import '../../loginpage/register.dart';
import '../../utils/routes.dart';

class CategoryPage extends StatefulWidget {
  String useruid="";
  CategoryPage({required this.useruid});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  late GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  late WidgetBuilder builder = (context) => IncomeCatPage(
    useruid: widget.useruid,
  ); // Declare as nullable
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 0.04.sh,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildNavItem(0, "Income", MyRoutes.signingpage),
                buildNavItem(1, "Expense", MyRoutes.registerpage),
              ],
            ),
            decoration: BoxDecoration(
              color:const Color(0xFF003366),
            ),
          ),
          Expanded(
            child: Navigator(
              key: _navigatorKey,
              onGenerateRoute: (settings) {
                return MaterialPageRoute(
                  builder: builder,
                  settings: settings,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  Widget buildNavItem(int index, String title, String route) {
    return Padding(
      padding: EdgeInsets.all(0.007.sw),
      child: Container(
        width: 0.35.sw,
        height: 0.035.sh,
        child: TextButton(
          onPressed: () {
            setState(() {
              _selectedIndex = index;
              if (index == 0) {
                builder = (context) => IncomeCatPage(
                  useruid: widget.useruid,
                );
              } else if (index == 1) {
                builder = (context) => ExpenseCatPage(useruid: widget.useruid);
              }
            });
            _navigatorKey.currentState?.pushReplacementNamed(route);
          },
          style: ButtonStyle(
            alignment: Alignment.topCenter,
            textStyle: MaterialStateProperty.all<TextStyle>(
              TextStyle(
                color: Colors.white,
                // Adjust other styles as needed
              ),
            ),
          ),
          child: Text(
            title,
            style: TextStyle(
                fontSize: 13.0.sp,
                color: _selectedIndex == index ? Colors.white : Colors.black54),
          ),
        ),
        decoration: BoxDecoration(
          color: _selectedIndex == index
              ? Colors.blue
              : Colors.white54,
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    );
  }
}


