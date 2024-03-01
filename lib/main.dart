import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:paisa_pluse_new/AboutUs/aboutus.dart';
import 'package:paisa_pluse_new/HelpUs/helpuspage.dart';
import 'package:paisa_pluse_new/Transactionpage/remainderpage/remainderpage.dart';
import 'package:paisa_pluse_new/homepage/initialamount.dart';
import 'package:paisa_pluse_new/navigationbar/transactionmain.dart';
import 'package:paisa_pluse_new/splashscreen.dart';
import 'package:paisa_pluse_new/useraccountpage/profileaccount.dart';
import 'homepage/homepage.dart';
import 'loginpage/forgotpassword.dart';
import 'loginpage/register.dart';
import 'loginpage/signin.dart';
import 'profileAccount/accountpage.dart';
import 'utils/routes.dart';
import 'widgets/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    user = auth.currentUser;
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return ScreenUtilInit(
      designSize: Size(width, height),
      child: MaterialApp(
        title: 'Paisa Pulse',
        themeMode: ThemeMode.light,
        theme: Mytheme.lighttheme(context),
        darkTheme: Mytheme.darktheme(context),
        debugShowCheckedModeBanner: false,
        initialRoute: MyRoutes.splashpage,
        routes: {
          MyRoutes.registerpage: (context) => const Register(),
          MyRoutes.signingpage: (context) => const SignIn(),
          MyRoutes.forgotpasswordpage: (context) => const ForgotPassword(),
          MyRoutes.homepage: (content) => const HomePage(),
          MyRoutes.transactionmain: (content) => const TransactionMain(),
          MyRoutes.splashpage: (context) => const SplashScreen(),
          MyRoutes.profilepage: (context) => const ProfileAccount(),
          MyRoutes.initialamountpage: (context) => const Initialamount(),
          MyRoutes.accountpage: (context) =>  const AccountNav(),
          MyRoutes.reminderpage: (context) =>  ReminderPage(useruid:user!.uid),
          MyRoutes.aboutuspage: (context) =>  const AboutUs(),
          MyRoutes.helpuspage: (context) =>  HelpUsPage(useruid: user!.uid,),
        },
      ),
    );
  }
}
