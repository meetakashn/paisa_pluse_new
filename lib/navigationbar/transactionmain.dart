import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:paisa_pluse_new/Transactionpage/expenseoverview/expenseoverview.dart';
import 'package:paisa_pluse_new/Transactionpage/incomeoverview/incomeoverview.dart';
import 'package:paisa_pluse_new/Transactionpage/transactionoverview.dart';
import 'package:paisa_pluse_new/utils/routes.dart';

class TransactionMain extends StatefulWidget {
  const TransactionMain({super.key});

  @override
  State<TransactionMain> createState() => _TransactionMainState();
}

class _TransactionMainState extends State<TransactionMain> {
  late GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  late WidgetBuilder builder = (context) => TransactionOverview(
        useruid: user!.uid,
      ); // Declare as nullable
  int _selectedIndex = 0;
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
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 0.04.sh,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                buildNavItem(0, "Overview", MyRoutes.signingpage),
                SizedBox(
                  width: 0.010.sw,
                ),
                buildNavItem(1, "Income Overview", MyRoutes.registerpage),
                SizedBox(
                  width: 0.010.sw,
                ),
                buildNavItem(2, "Expense Overview", MyRoutes.profilepage),
              ],
            ),
            decoration: BoxDecoration(
              color: Color(0xFF003366),
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
        height: 0.03.sh,
        child: TextButton(
          onPressed: () {
            setState(() {
              _selectedIndex = index;
              if (index == 0) {
                builder = (context) => TransactionOverview(
                      useruid: user!.uid,
                    );
              } else if (index == 1) {
                builder = (context) => IncomeOverview(useruid: user!.uid);
              } else if (index == 2) {
                builder = (context) => ExpenseOverview(useruid: user!.uid);
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
                fontSize: 12.0.sp,
                color: _selectedIndex == index ? Colors.black : Colors.white60),
          ),
        ),
        decoration: BoxDecoration(
          color: _selectedIndex == index
              ? Colors.orange.shade400
              : Colors.blueGrey,
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    );
  }
}
