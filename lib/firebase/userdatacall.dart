import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  static String username = "";
  static String emailaddress = "";
  static String profileurl = "";

  void Storedetails(String useruid) {
    getusername(useruid);
    getuseremail(useruid);
    getprofilepic(useruid);
  }

  Future<String> getusername(String Useruid) async {
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('user').doc(Useruid).get();
    return username = userDoc.get('username');
  }

  Future<String> getuseremail(String Useruid) async {
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('user').doc(Useruid).get();
    return emailaddress = userDoc.get('emailaddress');
  }

  Future<String> getprofilepic(String Useruid) async {
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('user').doc(Useruid).get();
    return profileurl = userDoc.get('profileurl');
  }
}
