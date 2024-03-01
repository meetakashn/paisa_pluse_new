import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../connectivitycheck.dart';
import '../utils/routes.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  static String uid = "";

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formkey = GlobalKey<FormState>();
  late ConnectivityHandler connectivityHandler;
  TextEditingController usernametext = TextEditingController();
  TextEditingController emailaddresstext = TextEditingController();
  TextEditingController passwordtext = TextEditingController();
  bool _isPasswordVisible = false;
  String emailaddress = "";
  String password = "";
  String username = "";

  @override
  void initState() {
    // TODO: implement initState
    connectivityHandler = ConnectivityHandler(context);
    connectivityHandler.setupConnectivityListener();
    super.initState();
  }

  @override
  void dispose() {
    connectivityHandler.dispose();
    super.dispose();
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
        backgroundColor: Color(0xFF003366),
        extendBodyBehindAppBar: true,
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              margin: EdgeInsets.only(left: 0.05.sw, right: 0.05.sw),
              color: Color(0xFF003366),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 0.04.sh,
                    ),
                    Image.asset("assets/images/registerbudget.png",
                        width: 0.6.sw, height: 0.3.sh),
                    Text(
                      "Create an account",
                      style: TextStyle(
                          fontSize: 19.0.sp,
                          color: Colors.white,
                          fontFamily: GoogleFonts.lato().fontFamily),
                    ),
                    SizedBox(
                      height: 0.028.sh,
                    ),
                    Form(
                      key: formkey,
                      child: Column(
                        children: [
                          // for username
                          SizedBox(
                            width: 0.8.sw,
                            height: 0.10.sh,
                            child: TextFormField(
                              keyboardType: TextInputType.name,
                              cursorColor: Colors.white,
                              style: TextStyle(color: Colors.white),
                              maxLength: 15,
                              decoration: const InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.lightBlueAccent),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                                counterText: "",
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                hintText: "Username",
                                hintStyle: TextStyle(color: Colors.white),
                                suffixIcon: Icon(Icons.person_2_rounded),
                                suffixIconColor: Colors.orangeAccent,
                                errorStyle:
                                    TextStyle(color: Colors.amberAccent),
                              ),
                              controller: usernametext,
                              onChanged: (value) {
                                username = value;
                              },
                              validator: (value) {
                                // Check if the string is not empty
                                if (value!.isEmpty) {
                                  return "Field should not be empty";
                                }

                                // Check if the string has more than 5 characters
                                if (value.length <= 5) {
                                  return 'Field should have more than 5 characters';
                                }

                                // Check if the string contains only alphabets and numbers
                                if (!RegExp(r'^[a-zA-Z0-9]+$')
                                    .hasMatch(value)) {
                                  return 'Field should only contain alphabets and numbers';
                                }
                                // Return null if the input is valid
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 0.003.sh,
                          ),
                          // For E mail id
                          SizedBox(
                            width: 0.8.sw,
                            height: 0.10.sh,
                            child: TextFormField(
                              style: TextStyle(color: Colors.lightBlueAccent),
                              keyboardType: TextInputType.emailAddress,
                              cursorColor: Colors.white,
                              onChanged: (value) {
                                emailaddress = value;
                              },
                              controller: emailaddresstext,
                              validator: (value) {
                                if (!RegExp(
                                        r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                                    .hasMatch(value!)) {
                                  return "Enter a valid email";
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.lightBlueAccent),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                hintText: "Email Id",
                                hintStyle: TextStyle(color: Colors.white),
                                suffixIcon: Icon(Icons.mail),
                                suffixIconColor: Colors.orangeAccent,
                                errorStyle:
                                    TextStyle(color: Colors.amberAccent),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 0.003.sh,
                          ),
                          // for password
                          SizedBox(
                            width: 0.8.sw,
                            height: 0.10.sh,
                            child: TextFormField(
                              cursorColor: Colors.white,
                              style: TextStyle(color: Colors.lightBlueAccent),
                              controller: passwordtext,
                              obscureText: !_isPasswordVisible,
                              onChanged: (value) {
                                password = value;
                              },
                              validator: (value) {
                                final minLength = 8;
                                final hasUppercase =
                                    RegExp(r'[A-Z]').hasMatch(password);
                                final hasLowercase =
                                    RegExp(r'[a-z]').hasMatch(password);
                                final hasDigits =
                                    RegExp(r'\d').hasMatch(password);
                                if (password.length >= minLength &&
                                    hasUppercase &&
                                    hasLowercase &&
                                    hasDigits) {
                                  return null;
                                }
                                return "must contain uppercase, lowercase, digit";
                              },
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.lightBlueAccent),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                hintText: "Password",
                                hintStyle: TextStyle(color: Colors.white),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    // Toggle the visibility state
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                  child: Icon(
                                    _isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.orangeAccent,
                                  ),
                                ),
                                errorStyle:
                                    TextStyle(color: Colors.amberAccent),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 0.05.sh,
                    ),
                    // register
                    SizedBox(
                      width: 0.8.sw,
                      height: 0.05.sh,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (formkey.currentState!.validate()) {
                            print("Enter");
                            try {
                              final credential = await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                email: emailaddress,
                                password: password,
                              );
                              // Get the newly created user's UID
                              Register.uid = credential.user!.uid;
                              storeUserinfo();
                              Navigator.pushReplacementNamed(
                                  context, MyRoutes.initialamountpage);
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'weak-password') {
                                print('The password provided is too weak.');
                              } else if (e.code == 'email-already-in-use') {
                                _emailalreadyexist(context);
                              }
                            } catch (e) {
                              print(e);
                            }
                          }
                        },
                        child: Text(
                          "Sign up",
                          style:
                              TextStyle(fontSize: 20.0.sp, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 1,
                          backgroundColor: Colors.blueAccent,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account ?",
                          style: TextStyle(color: Colors.amberAccent),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, MyRoutes.signingpage);
                          },
                          child: const Text(
                            "Sign in",
                            style: TextStyle(color: Colors.lightBlue),
                          ),
                          style: TextButton.styleFrom(),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  storeUserinfo() async {
    // Store additional user information in Firestore
    await FirebaseFirestore.instance.collection('user').doc(Register.uid).set({
      'username': usernametext.text,
      'emailaddress': emailaddresstext.text,
      'profileurl':
          "https://firebasestorage.googleapis.com/v0/b/paisapulse-7ab21.appspot.com/o/profile_9fraVpBgNCfijtsJiGCqVeTfJNa2.jpg?alt=media&token=60ecf4d6-0ea5-4d38-a5a3-0734592decf9",
      'totalincome': 0,
      'totalexpense': 0,
    }).then((value) => {
          usernametext.clear(),
          emailaddresstext.clear(),
          passwordtext.clear(),
        });
  }

  void _emailalreadyexist(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
        content: Text("The email address is already in use"),
      ),
    );
  }
}
