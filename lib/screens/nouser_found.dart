import 'package:defender/screens/get_otp.dart';
import 'package:defender/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:defender/utilities/size_config.dart';
import 'package:defender/utilities/constants.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NoUserFound extends StatelessWidget {
  static const screenID = 'No User Found';
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.black);
    Map receivedDataFromMainScreen = ModalRoute.of(context).settings.arguments;
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
            'No User Found',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Container(
          width: SizeConfig.screenWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                FontAwesomeIcons.userTimes,
                size: SizeConfig.blockSizeVertical * 15,
                color: kPrimaryColor,
              ),
              Padding(
                padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 3),
                child: Text(
                  'No User Found !',
                  style: TextStyle(
                    fontSize: SizeConfig.blockSizeHorizontal * 7,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(top: SizeConfig.blockSizeVertical * 10),
                child: MaterialButton(
                  onPressed: () {
                    Navigator.pushNamed(context, GetOtpScreen.screenID,
                        arguments: {
                          'mobileNumber':
                              receivedDataFromMainScreen['mobileNumber'],
                          
                        });
                  },
                  child: Text(
                    'REGISTER NEW USER',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: SizeConfig.blockSizeHorizontal * 4.5,
                    ),
                  ),
                  color: kSecondaryColor,
                  minWidth: SizeConfig.blockSizeHorizontal * 82,
                  height: SizeConfig.blockSizeVertical * 6.5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      SizeConfig.blockSizeHorizontal * 2,
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
