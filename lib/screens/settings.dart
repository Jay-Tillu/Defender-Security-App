import 'package:defender/custom_widgets/CSettingsContainer.dart';
import 'package:defender/screens/contact_us.dart';
import 'package:defender/screens/main_screen.dart';
import 'package:defender/screens/privacy_policy.dart';
import 'package:defender/screens/terms_and_conditions.dart';
import 'package:defender/utilities/constants.dart';
import 'package:defender/utilities/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsScreen extends StatelessWidget {
  static const String screenID = 'Settings Screen';
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static User firebaseUser;

  signOut() async {
    _firebaseAuth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.black);
    SizeConfig().init(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white12,
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(
                context,
                MainScreen.screenID,
              );
            },
            icon: Icon(
              FontAwesomeIcons.chevronLeft,
              color: Colors.black,
            ),
          ),
          title: Text(
            'Settings',
            style: TextStyle(color: Colors.black),
          ),
        ),
//**********************   Body  ****************************/
        body: Container(
          child: Column(
            children: [
//####################   Settings  ########################/
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.blockSizeVertical * 5,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CSettingsContainer(
                      buttonIcon: Icons.description_rounded,
                      settingName: 'Privacy\nPolicy',
                      borderColor: Colors.deepPurple[500],
                      containerColor: Colors.deepPurple[50],
                      onButtonPressed: () {
                        Navigator.pushNamed(context, PrivacyPolicy.screenID);
                      },
                    ),
                    CSettingsContainer(
                      buttonIcon: Icons.security_rounded,
                      settingName: 'Terms & Conditions',
                      borderColor: Colors.blue[500],
                      containerColor: Colors.blue[50],
                      onButtonPressed: () {
                        Navigator.pushNamed(context, TermsAndConditions.screenID);
                      },
                    ),
                  ],
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CSettingsContainer(
                    buttonIcon: FontAwesomeIcons.phoneVolume,
                    settingName: 'Contact us',
                    onButtonPressed: () {
                      Navigator.pushNamed(context, ContactUsScreen.screenID);
                    },
                    borderColor: Colors.orange[500],
                    containerColor: Colors.orange[50],
                  ),
                  CSettingsContainer(
                    buttonIcon: FontAwesomeIcons.signOutAlt,
                    settingName: 'Log out',
                    onButtonPressed: () {
                      signOut();
                    },
                    borderColor: Colors.red[500],
                    containerColor: Colors.red[50],
                  ),
                ],
              ),

//####################   Made in India  ########################/

              Expanded(
                child: Container(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: SizeConfig.blockSizeHorizontal * 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Made in India',
                          style: TextStyle(
                            fontFamily: kFontRoboto,
                            fontSize: SizeConfig.blockSizeHorizontal * 5.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: SizeConfig.blockSizeHorizontal * 2,
                          ),
                          child: Image.asset(
                            kProudImage,
                            width: SizeConfig.blockSizeHorizontal * 7,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
