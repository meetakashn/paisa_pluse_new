import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AboutUsEdit extends StatefulWidget {
  String review="";
  String useruid="";
  String docid="";
  AboutUsEdit({required this.useruid,required this.docid,required this.review});

  @override
  State<AboutUsEdit> createState() => _AboutUsEditState();
}

class _AboutUsEditState extends State<AboutUsEdit> {
  TextEditingController _reviewcontroller = TextEditingController();
  String DocId="";
  String userUid="";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _reviewcontroller.text=widget.review.toString();
    DocId=widget.docid;
    userUid=widget.useruid;
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.center,
      title: const Text("Change your review"),
      actions: [
        SizedBox(
          width: 0.9.sw,
          height: 0.05.sh,
          child: TextFormField(
            controller: _reviewcontroller,
            decoration: const InputDecoration(
                hintText: "write your review",
                border: OutlineInputBorder(
                  borderSide: BorderSide(width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                )),
            onEditingComplete: (){
              FocusScope.of(context).unfocus();
            },
          ),
        ),
        SizedBox(height:0.01.sh ,),
        CircleAvatar(
          backgroundColor: Colors.black,
          child: IconButton(
              onPressed: () {
                storereview();
                _reviewcontroller.clear();
                FocusScope.of(context).unfocus();
              },
              icon: const Icon(Icons.send,color: Colors.white,)),
        )
      ],

    );
  }
  storereview() async {
    FirebaseFirestore.instance.collection("review").doc(widget.docid).update({
      'review':_reviewcontroller.text
    }).then((value) {Navigator.pop(context);});
  }
}
