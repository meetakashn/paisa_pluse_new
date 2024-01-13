import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/routes.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailaddresstext = TextEditingController();
  //final auth = FirebaseAuth.instance;
  String emailaddress = "";
  bool state = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }
        Navigator.pushReplacementNamed(context, MyRoutes.signingpage);
      },
      child: Scaffold(
        //backgroundColor:Color(0xFFE1AD01),
        backgroundColor: Colors.orange.shade500,
        extendBodyBehindAppBar: true,
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              margin:
                  EdgeInsets.only(top: 0.05.sh, left: 0.05.sw, right: 0.05.sw),
              decoration: BoxDecoration(
                color: Colors.orange.shade200,
                border: Border.all(width: 1),
                borderRadius: BorderRadius.circular(100),
              ),
              //color: Color(0xFFE1AD01),
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 0.00.sh,
                    ),
                    Image.asset("assets/images/passresetbudget.png",
                        width: 0.5.sw, height: 0.3.sh),
                    RichText(
                      textAlign: TextAlign.right,
                      text: TextSpan(
                        text: '"Fresh Start: Resetting Your Password"\n',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 19.0.sp,
                          fontFamily: GoogleFonts.cabin().fontFamily,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: '– Paisa Pulse',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.black,
                              fontFamily: GoogleFonts.cabin().fontFamily,
                              fontSize: 19.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 0.02.sh,
                    ),
                    Text(
                      "\" Reset Your Password\"",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 19.0.sp,
                        fontWeight: FontWeight.w400,
                        fontFamily: GoogleFonts.lato().fontFamily,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 0.025.sh,
                    ),
                    Column(
                      children: [
                        // For E mail id
                        SizedBox(
                          width: 0.78.sw,
                          height: 0.069.sh,
                          child: TextFormField(
                            controller: emailaddresstext,
                            style: TextStyle(color: Colors.black),
                            onChanged: (value) {
                              emailaddress = value;
                            },
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: "Email Id",
                              hintStyle: TextStyle(color: Colors.black),
                              suffixIcon: Icon(Icons.mail),
                              suffixIconColor: Colors.lightBlue,
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.lightBlue),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                            ),
                            onEditingComplete: () {
                              FocusScope.of(context).unfocus();
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 0.03.sh,
                    ),
                    Center(
                      child: SizedBox(
                        width: 0.78.sw,
                        height: 0.055.sh,
                        child: ElevatedButton(
                          onPressed: () async {
                            FocusScope.of(context).unfocus();
                            if (emailaddress.toString().isEmpty) {
                              _noempty(context);
                            } else {
                              if (RegExp(r'@gmail\.com$', caseSensitive: false)
                                  .hasMatch(emailaddresstext.text.toString())) {
                                try {
                                  // Check if the provided email matches any stored emails in Firestore
                                  QuerySnapshot querySnapshot =
                                      await FirebaseFirestore.instance
                                          .collection(
                                              'user') // Change 'users' to your actual collection name
                                          .where('emailaddress',
                                              isEqualTo: emailaddresstext.text
                                                  .toString())
                                          .get();
                                  if (querySnapshot.docs.isNotEmpty) {
                                    await FirebaseAuth.instance
                                        .sendPasswordResetEmail(
                                            email: emailaddresstext.text);
                                    setState(() {
                                      state = true;
                                    });
                                    Future.delayed(Duration(milliseconds: 1000),
                                        () {
                                      setState(() {
                                        state = false;
                                      });
                                    });
                                  } else {
                                    wrongemail(context);
                                  }
                                } catch (e) {
                                  wrongemail(context);
                                }
                              } else {
                                _noempty(context);
                              }
                            }
                          },
                          child: Text(
                            "Verify Your Account",
                            style: TextStyle(
                                fontSize: 19.0.sp, color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            elevation: 1,
                            backgroundColor: Colors.lightBlue,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, MyRoutes.signingpage);
                            },
                            child: Text(
                              "Sign in",
                              style: TextStyle(color: Colors.black),
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 0.01.sh,
                    ),
                    state
                        ? Text(
                            "Password reset link sended successfully",
                            style: TextStyle(color: Colors.black, fontSize: 10),
                          )
                        : Text(""),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _noempty(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none),
        content: const Text('Invalid email'),
      ),
    );
  }

  wronguser(BuildContext context, String s) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
        content: Text(s),
      ),
    );
  }

  wrongemail(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
        content: Text("Email doesn't exists"),
      ),
    );
  }

  //for back button
  Future<bool> _onWillPop() async {
    Navigator.pushReplacementNamed(context, MyRoutes.signingpage);
    return true;
  }
}
