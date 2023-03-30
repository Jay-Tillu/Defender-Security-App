import 'package:defender/screens/main_screen.dart';
import 'package:defender/screens/verify_otp.dart';
import 'package:defender/utilities/constants.dart';
import 'package:defender/services/otp_backend.dart';
import 'package:defender/utilities/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GetOtpScreen extends StatelessWidget {
  static const String screenID = 'Get Otp Screen';
//   @override
//   _GetOtpScreenState createState() => _GetOtpScreenState();
// }

// class _GetOtpScreenState extends State<GetOtpScreen> {
  static OtpFunctions _otpFunctions = OtpFunctions();
  @override
  Widget build(BuildContext context) {
    Map receivedDataFromNoUserFoundScreen =
        ModalRoute.of(context).settings.arguments;
    var mobileNumber = receivedDataFromNoUserFoundScreen['mobileNumber'];
    TextEditingController _getOtpController = TextEditingController();
    _getOtpController.text = receivedDataFromNoUserFoundScreen['mobileNumber'];

    SizeConfig().init(context);
    FlutterStatusbarcolor.setStatusBarColor(Colors.black);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white10,
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
            'Get OTP',
            style: TextStyle(color: Colors.black),
          ),
        ),

//******************** Body *********************/

        body: SafeArea(
          child: Container(
            child: Column(
              children: [
//*********************** Image ***********************/
                SizedBox(
                  height: SizeConfig.blockSizeVertical * 3,
                ),

                Center(
                  child: Image.asset(
                    kGetOtpImages,
                    height: SizeConfig.blockSizeVertical * 28,
                  ),
                ),

//*********************** OTP Text ***********************/

                Padding(
                  padding: EdgeInsets.only(
                    left: SizeConfig.blockSizeHorizontal * 7,
                    right: SizeConfig.blockSizeHorizontal * 7,
                    top: SizeConfig.blockSizeHorizontal * 7,
                  ),
                  child: Text(
                    'OTP Verification',
                    style: TextStyle(
                        fontSize: SizeConfig.blockSizeHorizontal * 7,
                        fontWeight: FontWeight.w700,
                        color: Colors.blue[700]),
                  ),
                ),

//*********************** OTP Info Text ***********************/

                Padding(
                  padding:
                      EdgeInsets.only(top: SizeConfig.blockSizeVertical * 1),
                  child: Text(
                    'We will send you an OTP on \nthis Phone Number',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: kFontRoboto,
                      fontSize: SizeConfig.blockSizeHorizontal * 5,
                    ),
                  ),
                ),

//*********************** Phone Number Text ***********************/

                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.blockSizeHorizontal * 8,
                    vertical: SizeConfig.blockSizeVertical * 5,
                  ),
                  child: Container(
                    width: SizeConfig.blockSizeHorizontal * 80,
                    height: SizeConfig.blockSizeVertical * 7,
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue,
                          spreadRadius: 1,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(
                        SizeConfig.blockSizeHorizontal * 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: SizeConfig.blockSizeHorizontal * 5,
                            right: SizeConfig.blockSizeHorizontal * 6,
                          ),
                          child: Icon(
                            FontAwesomeIcons.phoneAlt,
                            size: SizeConfig.blockSizeHorizontal * 5,
                          ),
                        ),
                        Text(
                          mobileNumber,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: kFontRoboto,
                            fontSize: SizeConfig.blockSizeHorizontal * 6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

//*********************** Get OTP Button ***********************/

                MaterialButton(
                  onPressed: () {
                    _otpFunctions.getOtp(phoneNumber: mobileNumber);
                    Navigator.pushReplacementNamed(
                      context,
                      VerifyOtpScreen.screenID,
                      arguments: {
                        'mobileNumber': mobileNumber,
                      },
                    );
                  },
                  child: Text(
                    'GET OTP',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
