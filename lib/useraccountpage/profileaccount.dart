import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paisa_pluse_new/homepage/homepage.dart';

import '../utils/routes.dart';

class ProfileAccount extends StatefulWidget {
  const ProfileAccount({super.key});

  @override
  State<ProfileAccount> createState() => _ProfileAccountState();
}

class _ProfileAccountState extends State<ProfileAccount> {
  String emailaddress = "";
  String username = "";
  bool userbool = false, buttonbool = false;
  TextEditingController emailaddresstext = TextEditingController();
  TextEditingController usernametext = TextEditingController();
  final FocusNode _usernameFocus = FocusNode();
  File? _imageFile;
  String? _uploadedImageUrl;
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = auth.currentUser;
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) {
          if (didPop) {
            return;
          }
          Navigator.pushReplacementNamed(context, MyRoutes.accountpage);
        },
        child: SingleChildScrollView(
          child: SafeArea(
            child: Center(
              child: Container(
                padding: EdgeInsets.all(0.096.sw),
                child: Column(
                  children: [
                    _uploadedImageUrl != null
                        ? Stack(
                            children: [
                              buildProfileImage(),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 0.12.sh, left: 0.30.sw),
                                child: Container(
                                  height: 0.041.sh,
                                  width: 0.09.sw,
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 1),
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.blueAccent,
                                  ),
                                  child: Center(
                                    child: IconButton(
                                      icon: Icon(Icons.camera_alt,
                                          size: 0.022.sh, color: Colors.black),
                                      onPressed: () {
                                        _pickImage();
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Container(
                            width: 1.sw,
                            height: 0.15.sh,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white70),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset("assets/images/paisalogopng.png"),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 0.1068.sh, left: 0.28.sw),
                                  child: Container(
                                    height: 0.045.sh,
                                    width: 0.09.sw,
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 1),
                                      borderRadius: BorderRadius.circular(100),
                                      color: Colors.blueAccent,
                                    ),
                                    child: Center(
                                      child: IconButton(
                                        icon: Icon(Icons.camera_alt,
                                            size: 0.045.sw,
                                            color: Colors.black),
                                        onPressed: () {
                                          _pickImage();
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                    SizedBox(height: 0.01.sh),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'Hii', // First word
                            style: TextStyle(
                              color: Colors.white, // Color of the first word
                              fontSize: 20.0.sp, // Font size of the first word
                              fontWeight: FontWeight.bold,
                              fontFamily: GoogleFonts.lato().fontFamily,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text:
                                    '  \' ${usernametext.text.toString()} \' ',
                                // Second word
                                style: TextStyle(
                                  color: Colors.red, // Color of the second word
                                  fontSize:
                                      18.0.sp, // Font size of the second word
                                  fontFamily:
                                      GoogleFonts.albertSans().fontFamily,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 0.02.sh,
                    ),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text("  Username",
                            style: TextStyle(
                                fontSize: 15.0.sp,
                                color: Colors.white,
                                fontFamily: GoogleFonts.lato().fontFamily))),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 1,
                            color: userbool ? Colors.white : Colors.white60),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 0.68.sw,
                            child: Padding(
                              padding: EdgeInsets.only(left: 0.02.sw),
                              child: TextFormField(
                                cursorColor: Colors.white,
                                style: const TextStyle(color: Colors.white),
                                controller: usernametext,
                                enabled: userbool,
                                focusNode: _usernameFocus,
                                maxLength: 15,
                                onEditingComplete: () {
                                  FocusScope.of(context).unfocus();
                                  setState(() {
                                    userbool = false;
                                    buttonbool = false;
                                  });
                                },
                                onChanged: (value) {
                                  usernametext.text = value;
                                  setState(() {});
                                },
                                decoration: const InputDecoration(
                                  counterText: "",
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  userbool = true;
                                  buttonbool = true;
                                });
                                Future.delayed(const Duration(milliseconds: 50), () {
                                  _usernameFocus.requestFocus();
                                });
                              },
                              icon: const Icon(
                                Icons.edit_rounded,
                                color: Colors.orange,
                              )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 0.02.sh,
                    ),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text("  Email",
                            style: TextStyle(
                                fontSize: 15.0.sp,
                                color: Colors.white,
                                fontFamily: GoogleFonts.lato().fontFamily))),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.white60),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 0.68.sw,
                            child: Padding(
                              padding: EdgeInsets.only(left: 0.02.sw),
                              child: TextFormField(
                                style: const TextStyle(color: Colors.white54),
                                controller: emailaddresstext,
                                enabled: false,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 0.04.sh,
                    ),
                    SizedBox(
                      width: 0.8.sw,
                      height: 0.045.sh,
                      child: ElevatedButton(
                        onPressed: () {
                          final scaffold = ScaffoldMessenger.of(context);
                          if (usernametext.text.toString().isEmpty) {
                            scaffold.showSnackBar(
                              const SnackBar(
                                duration: Duration(seconds: 2),
                                backgroundColor: Colors.red,
                                content: Text("Field should not be empty"),
                              ),
                            );
                          }
                          // Check if the string has more than 5 characters
                          else if (usernametext.text.toString().length <= 5) {
                            scaffold.showSnackBar(
                              const SnackBar(
                                duration: Duration(seconds: 2),
                                backgroundColor: Colors.red,
                                content: Text(
                                    "Field should have more than 5 characters"),
                              ),
                            );
                          }

                          // Check if the string contains only alphabets and numbers
                          else if (!RegExp(r'^[a-zA-Z0-9]+$')
                              .hasMatch(usernametext.text.toString())) {
                            scaffold.showSnackBar(
                              const SnackBar(
                                duration: Duration(seconds: 2),
                                backgroundColor: Colors.red,
                                content: Text(
                                    "Field should only contain alphabets and numbers"),
                              ),
                            );
                          } else {
                            storeUserinfo();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                buttonbool ? Colors.green : Colors.red,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(width: 1))),
                        child: Text(
                          "Update",
                          style:
                              TextStyle(fontSize: 18.0.sp, color: Colors.white),
                        ),
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, MyRoutes.aboutuspage);
                        },
                        child: const Text(
                          "About us",
                          style: TextStyle(color: Colors.orangeAccent),
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> fetchData() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await getUserDocument(FirebaseFirestore.instance, user!.uid);
      if (userDoc.exists) {
        setState(() {
          usernametext.text = userDoc.get('username');
          emailaddresstext.text = userDoc.get('emailaddress');
          _uploadedImageUrl = userDoc.get('profileurl');
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
      future: getUserDocument(FirebaseFirestore.instance, user!.uid),
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

  storeUserinfo() async {
    // Store additional user information in Firestore
    await FirebaseFirestore.instance.collection('user').doc(user!.uid).update({
      'username': usernametext.text.toString(),
    }).then((value) => {
          usernametext.clear(),
        });
    Navigator.pushReplacementNamed(context, MyRoutes.homepage);
  }

  // Function to pick an image from the device
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _uploadImage();
      });
    }
  }

  // Function to upload the picked image
  Future<void> _uploadImage() async {
    if (_imageFile != null) {
      // Replace 'YOUR_USER_ID' with the actual user ID
      String userID = user!.uid;
      await uploadImage(_imageFile!, userID);
    }
  }

  Future<String?> uploadImage(File imageFile, String userID) async {
    try {
      String fileName = 'profile_$userID.jpg';
      Reference storageReference =
          FirebaseStorage.instance.ref().child(fileName);

      await storageReference.putFile(imageFile);

      String downloadURL = await storageReference.getDownloadURL();
      await FirebaseFirestore.instance.collection('user').doc(userID).update({
        'profileurl': downloadURL,
      });
      setState(() {
        _uploadedImageUrl = downloadURL;
      });
      return downloadURL;
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }
}
