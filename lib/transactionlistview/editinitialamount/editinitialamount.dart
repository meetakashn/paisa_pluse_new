import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paisa_pluse_new/homepage/homepage.dart';

import '../../utils/routes.dart';

class EditInitialAmount extends StatefulWidget {
  String useruid = "";
  EditInitialAmount({required this.useruid});
  @override
  State<EditInitialAmount> createState() => _EditInitialAmountState();
}

class _EditInitialAmountState extends State<EditInitialAmount> {
  int amount = 0;
  String docid = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInitialAmountDocId(widget.useruid);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.center,
      backgroundColor: Colors.white,
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: 0.03.sw,
                  bottom: 0.025.sw,
                  right: 0.01.sw,
                  left: 0.01.sw),
              child: Text(
                "Change initial amount",
                style: TextStyle(
                    fontSize: 15.0.sp,
                    letterSpacing: 1,
                    fontFamily: GoogleFonts.akshar().fontFamily),
              ),
            ),
            Icon(
              Icons.edit,
              size: 15.0.sp,
            ),
          ],
        ),
        TextFormField(
          textAlign: TextAlign.start,
          maxLength: 10,
          keyboardType: TextInputType.number,
          showCursor: true,
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
            label: Text("initial amount"),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(width: 1),
            ),
            suffixIcon: Icon(Icons.account_balance),
          ),
          onChanged: (value) {
            amount = int.parse(value);
          },
        ),
        SizedBox(
          width: 0.5.sw,
          child: Padding(
            padding: EdgeInsets.only(right: 0.19.sw),
            child: ElevatedButton(
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
              child: Text(
                "Update",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                side: BorderSide(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void getInitialAmountDocId(String userUid) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('user')
          .doc(userUid)
          .collection('incomes')
          .where('category', isEqualTo: 'Initial Amount')
          .limit(
              1) // Limit to one document, assuming there is only one initial amount document
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // If documents are found, return the document ID of the first one
        docid = querySnapshot.docs.first.id;
      } else {
        // No initial amount document found
        return null;
      }
    } catch (e) {
      // Handle any errors
      print('Error getting initial amount doc ID: $e');
      return null;
    }
  }

  storeinitialamount() async {
    // Store additional user information in Firestore
    await FirebaseFirestore.instance
        .collection('user')
        .doc(widget.useruid)
        .update({
      'totalamount': amount,
    }).then((value) => {
              addInitialAmount(),
            });
  }

  // Adding initial amount as an income entry
  Future<void> addInitialAmount() async {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(widget.useruid)
        .collection('incomes')
        .doc(docid)
        .update({
      'amount': amount,
      'category': 'Initial Amount',
      'date': Timestamp.now(),
      'note': 'Initial amount entry',
      'paymentmethod': 'online payment',
      'type': 'income',
      // Add other necessary fields
    }).then((value) => () {
              setState(() {
                HomePage.initialpageindex = 1;
                HomePage.page = 1;
              });
            });
    Navigator.pushReplacementNamed(context, MyRoutes.homepage);
  }
}
