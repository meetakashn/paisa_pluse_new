import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../homepage/homepage.dart';
import '../utils/routes.dart';
import 'reviewshowing.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  var usernametext;
  TextEditingController _reviewcontroller = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    user = auth.currentUser;
    getdata();
    super.initState();
  }

  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }
        Navigator.pushReplacementNamed(context, MyRoutes.accountpage);
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF003366),
        appBar: AppBar(
          backgroundColor: const Color(0xFF003366),
          elevation: 1,
          toolbarHeight: 0.05.sh,
          // Set the toolbar height
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context,MyRoutes.accountpage);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
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
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              color: Color(0xFF003366),
              padding: EdgeInsets.all(0.035.sw),
              child: Column(
                children: [
                  Text(
                    "About Us",
                    style: TextStyle(color: Colors.white,fontSize: 15.0.sp,fontFamily: GoogleFonts.alata().fontFamily),
                  ),
                  SizedBox(
                    height: 0.01.sh,
                  ),
                  SizedBox(
                    height: 0.13.sh,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 1),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset("assets/images/paisalogopng.png",
                                width: 0.1.sw, height: 0.1.sh),
                           Text(
                              "Paisa Pulse, your financial companion, simplifies money\nmanagement. Track expenses, set budgets, and achieve\nfinancial goals effortlessly. Empowering you for a\nsecure and prosperous financial journey",
                              style: TextStyle(
                                  fontSize: 12.0.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                              textAlign: TextAlign.justify,
                            ),
                          ]),
                    ),
                  ),
                  SizedBox(
                    height: 0.01.sh,
                  ),
                  Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 1),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      child: Column(
                        children: [
                          Text("Social Media",
                              style: TextStyle(
                                fontFamily: GoogleFonts.alata().fontFamily,
                                color: Colors.black,
                              )),
                          SizedBox(height: 0.001.sh),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                  onPressed: () async {
                                    launchUrl(
                                      Uri.parse(
                                          "https://www.facebook.com/meetakashn24"),
                                      mode: LaunchMode.externalApplication,
                                    );
                                  },
                                  icon: Image.asset(
                                      "assets/images/facebook.png",width: 0.07.sw,)),
                              IconButton(
                                  onPressed: () {
                                    launchUrl(
                                      Uri.parse(
                                          "https://www.instagram.com/meetakashn/"),
                                      mode: LaunchMode.externalApplication,
                                    );
                                  },
                                  icon: Image.asset(
                                      "assets/images/instagram.png",width: 0.07.sw,)),
                              IconButton(
                                  onPressed: () {
                                    launchUrl(
                                      Uri.parse(
                                          "https://twitter.com/meetakashn"),
                                      mode: LaunchMode.externalApplication,
                                    );
                                  },
                                  icon:
                                      Image.asset("assets/images/twitter.png",width: 0.07.sw,)),
                              IconButton(
                                  onPressed: () {
                                    launchUrl(
                                      Uri.parse(
                                          "https://www.linkedin.com/in/meetakashn/"),
                                      mode: LaunchMode.externalApplication,
                                    );
                                  },
                                  icon: Image.asset(
                                      "assets/images/linkedin.png",width: 0.07.sw,)),
                            ],
                          ),
                        ],
                      )),
                  SizedBox(height: 0.01.sh,),
                  SizedBox(
                    height: 0.48.sh,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Column(
                        children: [
                          Expanded(child: ReviewShowing()),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 1),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 0.01.sw,
                        ),
                        Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.transparent,
                            ),
                            child: Image.asset(
                              "assets/images/review.png",
                              width: 0.08.sw,
                              height: 0.04.sh,
                            )),
                       SizedBox(
                          width: 0.025.sw,
                        ),
                        SizedBox(
                          width: 0.68.sw,
                          height: 0.07.sh,
                          child: TextFormField(
                            controller: _reviewcontroller,
                            decoration: const InputDecoration(
                                hintText: "write your review",
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1),
                                )),
                            onEditingComplete: (){
                              FocusScope.of(context).unfocus();
                            },
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              storereview();
                              _reviewcontroller.clear();
                              FocusScope.of(context).unfocus();
                            },
                            icon: const Icon(Icons.send)),
                      ],
                    ),
                  ),
                  SizedBox(height: 0.01.sh),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 1),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                            onPressed: () {
                              launchUrl(
                                Uri(
                                    scheme: 'mailto',
                                    path: "akashnoffical03@gmail.com"),
                                mode: LaunchMode.externalApplication,
                              );
                            },
                            child: Text(
                              "Contact us",
                              style: TextStyle(color: Colors.black,fontSize: 12.0.sp),
                            )),
                        const SizedBox(),
                        TextButton(
                            onPressed: () {
                              launchUrl(
                                Uri.parse(
                                    "https://github.com/meetakashn"),
                                mode: LaunchMode.externalApplication,
                              );
                            },
                            child: Text("Creator",
                                style: TextStyle(color: Colors.black,fontSize: 12.0.sp))),
                        TextButton(
                            onPressed: () {
                              launchUrl(
                                Uri.parse(
                                    "https://docs.google.com/document/d/1qp-AKdp94OlZIpPYbzXcEhGrsnPVgf1YDJOcrqb_mCI/edit?usp=sharing"),
                                mode: LaunchMode.externalApplication,
                              );
                            },
                            child: Text("Terms & Conditions",
                                style: TextStyle(color: Colors.black,fontSize: 12.0.sp))),
                        const SizedBox(),
                        TextButton(
                            onPressed: () {
                              launchUrl(
                                Uri.parse(
                                    "https://docs.google.com/document/d/1PExabySYOhDyAFymNMf1M3b1MHkdxNX6Lozlvb-C2mE/edit?usp=sharing"),
                                mode: LaunchMode.externalApplication,
                              );
                            },
                            child: Text("Privacy",
                                style: TextStyle(color: Colors.black,fontSize: 12.0.sp)))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  getdata() async {
    User? user = auth.currentUser;
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .get();
    setState(() {
      usernametext = userDoc.get('username');
    });
  }

  storereview() async {
    FirebaseFirestore.instance.collection("review").add({
      'username': usernametext,
      'review': _reviewcontroller.text.trim().toString(),
      'useruid':user!.uid,
    });
  }
}
