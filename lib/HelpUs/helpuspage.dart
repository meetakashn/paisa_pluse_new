import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../homepage/homepage.dart';
import '../utils/routes.dart';
import 'sendingmail.dart';

class HelpUsPage extends StatefulWidget {
  String useruid = "";
  HelpUsPage({required this.useruid});

  @override
  State<HelpUsPage> createState() => _HelpUsPageState();
}

class _HelpUsPageState extends State<HelpUsPage> {
  var Username = "loading...";
  var imageurl = "";
  final TextEditingController _subject = TextEditingController();
  final TextEditingController _body = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  @override
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
                Navigator.pushReplacementNamed(context, MyRoutes.accountpage);
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Help Me",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0.sp,
                        fontFamily: GoogleFonts.alata().fontFamily),
                  ),
                ],
              ),
              SizedBox(
                height: 0.05.sh,
              ),
              SizedBox(
                height: 0.08.sh,
                child: Container(
                  margin: EdgeInsets.only(left: 0.10.sw, right: 0.10.sw),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 0.02.sw),
                        child: Container(
                          width: 0.15.sw, // Adjust the width as needed
                          height: 0.09.sh, // Adjust the height as needed
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(width: 1)),
                          child: buildProfileImage(),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 0.03.sw),
                            child: Text(
                              "${Username}",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 18.0.sp),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 0.06.sw),
                            child: Text(
                              "To: Paisa Pulse Team",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 15.0.sp),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 0.02.sh,
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 0.11.sw, bottom: 0.01.sw),
                    child: const Text(
                      "Subject",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 0.1.sw, right: 0.1.sw),
                child: TextFormField(
                  style: const TextStyle(color: Colors.white),
                  controller: _subject,
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    hintText: "write your subject",
                    hintStyle: TextStyle(color: Colors.white),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  onEditingComplete: () {
                    FocusScope.of(context).unfocus();
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(0.09.sw),
                child: TextFormField(
                  style: const TextStyle(color: Colors.white),
                  controller: _body,
                  maxLines: 10,
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    hintText: "",
                    hintStyle: TextStyle(color: Colors.white),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  onEditingComplete: () {
                    FocusScope.of(context).unfocus();
                  },
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 0.04.sh),
                child: TextButton(
                    onPressed: () async {
                      if (_subject.text.isEmpty || _body.text.isEmpty) {
                        final snackBar = SnackBar(
                          content: Text('subject and body should not be empty'),
                        );
                        // Show the SnackBar
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        sendHelpRequest(
                            _subject.text.toString(), _body.text.toString());
                        Navigator.pushReplacementNamed(context, MyRoutes.accountpage);
                      }
                    },
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(width: 1, color: Colors.black)),
                      backgroundColor: Colors.yellow,
                      fixedSize: Size(double.maxFinite, 50.h),
                    ),
                    child: Text(
                      "Send",
                      style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black,
                          fontFamily: GoogleFonts.lato().fontFamily,
                          letterSpacing: 1),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> fetchData() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await getUserDocument(FirebaseFirestore.instance, widget.useruid);
      if (userDoc.exists) {
        setState(() {
          Username = userDoc.get('username');
        });
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDocument(
      FirebaseFirestore firestore, String useruid) async {
    return await firestore.collection('user').doc(useruid).get();
  }

  Widget buildProfileImage() {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: getUserDocument(FirebaseFirestore.instance, widget.useruid),
      builder: (BuildContext context,
          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error fetching data: ${snapshot.error}'));
        } else {
          DocumentSnapshot userDoc = snapshot.data!;
          String imageUrl = userDoc.get('profileurl');
          return CircleAvatar(
            radius: 80,
            backgroundImage: NetworkImage(imageUrl, scale: 1.0),
          );
        }
      },
    );
  }
}
