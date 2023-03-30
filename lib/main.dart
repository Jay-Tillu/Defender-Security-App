import 'package:defender/screens/Yesterdays_visitor.dart';
import 'package:defender/screens/contact_us.dart';
import 'package:defender/screens/get_otp.dart';
import 'package:defender/screens/login_screen.dart';
import 'package:defender/screens/main_screen.dart';
import 'package:defender/screens/make_entry.dart';
import 'package:defender/screens/new_registration.dart';
import 'package:defender/screens/nouser_found.dart';
import 'package:defender/screens/privacy_policy.dart';
import 'package:defender/screens/settings.dart';
import 'package:defender/screens/terms_and_conditions.dart';
import 'package:defender/screens/todays_visitor.dart';
import 'package:defender/screens/verify_otp.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Defender',
      initialRoute: MainScreen.screenID,
      routes: {
        LoginScreen.screenID: (context) => LoginScreen(),
        TermsAndConditions.screenID: (context) => TermsAndConditions(),
        MainScreen.screenID: (context) => MainScreen(),
        ContactUsScreen.screenID: (context) => ContactUsScreen(),
        SettingsScreen.screenID: (context) => SettingsScreen(),
        GetOtpScreen.screenID: (context) => GetOtpScreen(),
        VerifyOtpScreen.screenID: (context) => VerifyOtpScreen(),
        NewRegistration.screenID: (context) => NewRegistration(),
        NoUserFound.screenID: (context) => NoUserFound(),
        MakeEntry.screenID: (context) => MakeEntry(),
        TodaysVisitor.screenID: (context) => TodaysVisitor(),
        YesterdaysVisitor.screenID: (context) => YesterdaysVisitor(),
        PrivacyPolicy.screenID: (context) => PrivacyPolicy(),
      },
    );
  }
}
