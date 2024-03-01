import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paisa_pluse_new/AboutUs/aboutusedit.dart';

class ReviewShowing extends StatefulWidget {
  const ReviewShowing({super.key});

  @override
  State<ReviewShowing> createState() => _ReviewShowingState();
}

class _ReviewShowingState extends State<ReviewShowing> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  @override
  void initState() {
    // TODO: implement initState
    user = auth.currentUser;
    super.initState();
  }

  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('review').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
          return const Center(
              child: Text(
            "No Review Found",
            style: TextStyle(color: Colors.white),
          ));
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(
            color: Colors.white,
            value: 0.8,
          ));
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final DocumentSnapshot topic = snapshot.data!.docs[index];
            final String review = topic['review'];
            final String username = topic['username'];
            final String documentId = topic.id;
            final String reviewerUserId = topic['useruid'];
            bool isCurrentUserReview = user!.uid == reviewerUserId;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(
                      vertical: 0.01.sw, horizontal: 0.01.sh),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.orange.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${review + " -" + username}",
                          style: TextStyle(
                              fontSize: 11,
                              fontFamily: GoogleFonts.alata().fontFamily,
                              color: Colors.black,
                              letterSpacing: 1),
                        ),
                        isCurrentUserReview
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        DeleteReview(documentId);
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.black,
                                      )),
                                  IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AboutUsEdit(
                                              docid: documentId,
                                              review: review,
                                              useruid: user!.uid),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.black,
                                      )),
                                ],
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 0.01.sh),
              ],
            );
          },
        );
      },
    );
  } // End of ReviewShowing widget
DeleteReview(String docid){
    FirebaseFirestore.instance.collection('review').doc(docid).delete();
}
}
