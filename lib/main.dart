import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:paisa_pluse_new/Transactionpage/transactionoverview.dart';
import 'package:paisa_pluse_new/homepage/initialamount.dart';
import 'package:paisa_pluse_new/navigationbar/transactionmain.dart';
import 'package:paisa_pluse_new/splashscreen.dart';
import 'package:paisa_pluse_new/useraccountpage/profileaccount.dart';
import 'homepage/homepage.dart';
import 'loginpage/forgotpassword.dart';
import 'loginpage/register.dart';
import 'loginpage/signin.dart';
import 'utils/routes.dart';
import 'widgets/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
          MyRoutes.registerpage: (context) => Register(),
          MyRoutes.signingpage: (context) => SignIn(),
          MyRoutes.forgotpasswordpage: (context) => ForgotPassword(),
          MyRoutes.homepage: (content) => HomePage(),
          MyRoutes.transactionmain: (content) => TransactionMain(),
          MyRoutes.splashpage: (context) => SplashScreen(),
          MyRoutes.profilepage: (context) => ProfileAccount(),
          MyRoutes.initialamountpage: (context) => Initialamount(),
        },
      ),
    );
  }
}
