import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paisa_pluse_new/homepage/homepage.dart';
import 'package:paisa_pluse_new/utils/routes.dart';

class AddingBudget extends StatefulWidget {
  String Category = "";
  IconData? iconData;
  String useruid="";
  AddingBudget({required this.Category, required this.iconData,required this.useruid});

  @override
  State<AddingBudget> createState() => _AddingBudgetState();
}

class _AddingBudgetState extends State<AddingBudget> {
  final TextEditingController _budgetAmount = TextEditingController();
  int budgetAmount = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text("Set Budget for ${widget.Category}",
          style: TextStyle(
              fontSize: 15.0.sp, fontFamily: GoogleFonts.lexend().fontFamily),
          textAlign: TextAlign.center),
      alignment: Alignment.center,
      actions: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 0.08.sh,
              width: widget.Category.length <= 13 ? 0.6.sw : 0.7.sw,
              decoration: BoxDecoration(
                color: Colors.brown,
                border: Border.all(width: 1),
                borderRadius: const BorderRadius.all(Radius.circular(40)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                          child: Icon(
                            widget.iconData,
                            color: Colors.yellow.shade400,
                          ),
                          backgroundColor: Colors.black),
                      SizedBox(
                        width: 0.02.sw,
                      ),
                      Text(
                        "${widget.Category}",
                        style: TextStyle(
                            fontSize: 18.0.sp,
                            fontFamily: GoogleFonts.lexend().fontFamily,
                            color: Colors.white),
                      )
                    ],
                  ),
                  Text(
                      "month: ${getMonthName(DateTime.now().month)},${DateTime.now().year}",
                      style: TextStyle(fontSize: 14.0.sp, color: Colors.white)),
                ],
              ),
            ),
            SizedBox(
              height: 0.01.sh,
            ),
            SizedBox(
              width: 0.6.sw,
              height: 0.061.sh,
              child: TextFormField(
                style: TextStyle(
                    fontFamily: GoogleFonts.akshar().fontFamily,
                    color: Colors.black,
                    letterSpacing: 2),
                cursorColor: Colors.black,
                keyboardType: TextInputType.number,
                controller: _budgetAmount,
                decoration: InputDecoration(
                    suffixIcon: Icon(
                      Icons.currency_rupee,
                      size: 0.024.sh,
                      color: Colors.black,
                    ),
                    hintText: "Amount",
                    hintStyle: TextStyle(
                        fontFamily: GoogleFonts.akshar().fontFamily,
                        color: Colors.black,
                        letterSpacing: 2),
                    border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1.0, color: Colors.black),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: Colors.blueAccent),
                      borderRadius: BorderRadius.circular(15),
                    )),
                onChanged: (value) {
                  setState(() {
                    budgetAmount = int.parse(value);
                  });
                },
              ),
            ),
            SizedBox(
              height: 0.01.sh,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () {Navigator.pop(context);},
                    child: Text("cancel",style: TextStyle(color: Colors.white,fontSize: 18.0.sp,fontFamily: GoogleFonts.lexend().fontFamily),),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      backgroundColor: Colors.black54,
                    )),
                TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      );
                      budgetSet(widget.Category,budgetAmount);
                      setState(() {
                        HomePage.page=3;
                        HomePage.initialpageindex=3;
                      });
                    },
                    child: Text("set",style: TextStyle(color: Colors.white,fontSize: 18.0.sp,fontFamily: GoogleFonts.lexend().fontFamily),),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      backgroundColor: Colors.black54,
                    )),
              ],
            ),
          ],
        ),
      ],
    );
  }
  Future<void> budgetSet(String category, int amount) async {
    try {
      await FirebaseFirestore.instance
          .collection('budget')
          .doc(widget.useruid)
          .collection(getMonthName(DateTime.now().month))
          .add({
        'category': category,
        'amount': amount,
        'date': DateTime.now(),
      });

      Navigator.pushReplacementNamed(context, MyRoutes.homepage);
    } catch (e) {
      print('Error setting budget: $e');
    }
  }
  String getMonthName(int month) {
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
}
