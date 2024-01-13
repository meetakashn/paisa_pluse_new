import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paisa_pluse_new/utils/routes.dart';

class Initialamount extends StatefulWidget {
  const Initialamount({super.key});

  @override
  State<Initialamount> createState() => _InitialamountState();
}

class _InitialamountState extends State<Initialamount> {
  TextEditingController pinController = TextEditingController();
  int amount = 0;
  bool button = false;
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 0.08.sh,
            ),
            Center(
                child: Image.asset(
              "assets/images/initialmoney.png",
              width: 0.48.sw,
            )),
            SizedBox(
              height: 0.02.sh,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Input your virtual currency balance",
                  style: TextStyle(
                      fontSize: 19.0.sp,
                      fontFamily: GoogleFonts.abel().fontFamily,
                      color: Colors.white),
                ),
              ],
            ),
            SizedBox(
              height: 0.01.sh,
            ),
            SizedBox(
              width: 0.71.sw,
              height: 0.07.sh,
              child: TextFormField(
                style: TextStyle(color: Colors.yellow, fontSize: 18.0.sp),
                controller: pinController,
                keyboardType: TextInputType.none,
                maxLength: 7,
                decoration: InputDecoration(
                    hintText: "Initial amount",
                    counterText: "",
                    hintStyle: TextStyle(
                        fontFamily: GoogleFonts.akshar().fontFamily,
                        letterSpacing: 2,
                        color: Colors.white60),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(width: 1))),
              ),
            ),
            Text(
              "Hint: Enter an amount greater than 500.",
              style: TextStyle(
                  fontSize: 10.0.sp,
                  fontFamily: GoogleFonts.abel().fontFamily,
                  color: Colors.white),
            ),
            SizedBox(
              height: 0.05.sh,
            ),
            buildCustomKeyboard(),
            SizedBox(
              height: 0.04.sh,
            ),
            SizedBox(
              width: 0.85.sw,
              child: button
                  ? ElevatedButton(
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
                        storeinitialamount();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Budgeting Brilliance Begins ",
                              style: TextStyle(
                                  fontSize: 20.0.sp,
                                  fontFamily: GoogleFonts.abel().fontFamily,
                                  color: Colors.black)),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 18.0.sp,
                            color: Colors.black,
                          ),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white70,
                      ),
                    )
                  : SizedBox.shrink(),
            )
          ],
        ),
      ),
      backgroundColor: Color(0xFF003366),
    );
  }

  Widget buildCustomKeyboard() {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildKeyboardRow(['1', '2', '3']),
          SizedBox(height: 10.0),
          buildKeyboardRow(['4', '5', '6']),
          SizedBox(height: 10.0),
          buildKeyboardRow(['7', '8', '9']),
          SizedBox(height: 10.0),
          buildKeyboardRow(['', '0', '<']),
        ],
      ),
    );
  }

  Widget buildKeyboardRow(List<String> keys) {
    return Padding(
      padding: EdgeInsets.only(left: 0.08.sw, right: 0.08.sw),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: keys.map((key) {
          return buildKeyboardKey(key);
        }).toList(),
      ),
    );
  }

  Widget buildKeyboardKey(String key) {
    Color keyColor = key == '<' ? Colors.blueAccent : Colors.black;
    Color textColor = key == '<' ? Colors.white : Colors.blueAccent;

    return InkWell(
      onTap: () {
        handleKeyboardKeyPress(key);
      },
      child: Container(
        width: 0.18.sw,
        height: 0.074.sh,
        decoration: BoxDecoration(
          color: Colors.white30,
          border: Border.all(color: Colors.black45, width: 1),
          borderRadius: BorderRadius.circular(11.0),
        ),
        alignment: Alignment.center,
        child: Text(
          key,
          style: TextStyle(fontSize: 20.0, color: Colors.white),
        ),
      ),
    );
  }

  void handleKeyboardKeyPress(String key) {
    if (key == '<') {
      // Handle backspace
      if (pinController.text.isNotEmpty) {
        pinController.text =
            pinController.text.substring(0, pinController.text.length - 1);
      }
    } else {
      // Handle numeric key
      if (pinController.text.length < 7) {
        pinController.text += key;
      }
    }
    // Update the amount variable
    amount = int.tryParse(pinController.text)!;
    // Update the button state
    setState(() {
      if (amount != null && amount >= 500) {
        button = true;
      } else {
        button = false;
      }
    });
  }

  storeinitialamount() async {
    // Store additional user information in Firestore
    await FirebaseFirestore.instance.collection('user').doc(user!.uid).update({
      'totalamount': amount,
    }).then((value) => {
          addInitialAmount(),
          pinController.clear(),
        });
    Navigator.pushReplacementNamed(context, MyRoutes.homepage);
  }

  // Adding initial amount as an income entry
  Future<void> addInitialAmount() async {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .collection('incomes')
        .add({
      'amount': amount,
      'category': 'Initial Amount',
      'date': Timestamp.now(),
      'note': 'Initial amount entry',
      'paymentmethod': 'online payment',
      'type': 'income',
      // Add other necessary fields
    });
  }
}
