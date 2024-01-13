import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/routes.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool _isPasswordVisible = false;
  String emailaddress = "";
  String password = "";
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
        Navigator.pushReplacementNamed(context, MyRoutes.splashpage);
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
                    Image.asset("assets/images/signinbudget.png",
                        width: 0.71.sw, height: 0.2.sh),
                    RichText(
                      textAlign: TextAlign.right,
                      text: TextSpan(
                        text: '"Smart Savings, Simple Spending"\n',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19.0.sp,
                          fontFamily: GoogleFonts.cabin().fontFamily,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: ' – Paisa Pulse',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.yellow,
                              fontFamily: GoogleFonts.cabin().fontFamily,
                              fontSize: 19.0.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 0.03.sh,
                    ),
                    Text(
                      "\" Welcome back \"",
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 19.0.sp,
                        fontWeight: FontWeight.w400,
                        fontFamily: GoogleFonts.lato().fontFamily,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 0.02.sh,
                    ),
                    Column(
                      children: [
                        // For E mail id
                        SizedBox(
                          width: 0.8.sw,
                          height: 0.10.sh,
                          child: TextFormField(
                            cursorColor: Colors.white,
                            style: TextStyle(color: Colors.white),
                            onChanged: (value) {
                              emailaddress = value;
                            },
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: "Email Id",
                              hintStyle: TextStyle(color: Colors.white),
                              suffixIcon: Icon(Icons.mail),
                              suffixIconColor: Colors.orangeAccent,
                              errorStyle: TextStyle(color: Colors.amberAccent),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.lightBlueAccent),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.white, width: 1),
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
                        SizedBox(
                          height: 0.01.sh,
                        ),
                        // for password
                        SizedBox(
                          width: 0.8.sw,
                          height: 0.10.sh,
                          child: TextFormField(
                            cursorColor: Colors.white,
                            style: TextStyle(color: Colors.white),
                            obscureText: !_isPasswordVisible,
                            onChanged: (value) {
                              password = value;
                            },
                            decoration: InputDecoration(
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
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.lightBlueAccent),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.white, width: 1),
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
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 0.03.sw),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, MyRoutes.forgotpasswordpage);
                              },
                              child: Text(
                                "Forgot password ?",
                                style: TextStyle(color: Colors.white),
                              ))
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 0.8.sw,
                      height: 0.05.sh,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (emailaddress.toString().isEmpty ||
                              password.toString().isEmpty) {
                            _noempty(context);
                          } else {
                            try {
                              final credential = await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: emailaddress, password: password);
                              FocusScope.of(context).unfocus();
                              setState(() {
                                emailaddress = "";
                                password = "";
                              });
                              Navigator.pushReplacementNamed(
                                  context, MyRoutes.homepage);
                            } on FirebaseAuthException catch (e) {
                              _wronguser(context);
                            }
                          }
                        },
                        child: Text(
                          "Sign in",
                          style:
                              TextStyle(fontSize: 18.0.sp, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 1,
                          backgroundColor: Colors.blueAccent,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have account ?",
                          style: TextStyle(color: Colors.amberAccent),
                        ),
                        TextButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            Navigator.pushReplacementNamed(
                                context, MyRoutes.registerpage);
                          },
                          child: Text(
                            "Sign up",
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

  void _noempty(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none),
        content: const Text('Field should not be empty'),
      ),
    );
  }

  void _wronguser(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
        content: Text("Incorrect email or password"),
      ),
    );
  }
}
