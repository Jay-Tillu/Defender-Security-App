import 'package:defender/screens/main_screen.dart';
import 'package:defender/screens/new_registration.dart';
import 'package:defender/services/otp_backend.dart';
import 'package:defender/utilities/constants.dart';
import 'package:defender/utilities/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:timer_button/timer_button.dart';

class VerifyOtpScreen extends StatefulWidget {
  static const String screenID = 'Verify Otp Screen';
  @override
  _VerifyOtpScreenState createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final GlobalKey<FormState> _verifyOtpFormKey = GlobalKey<FormState>();
  TextEditingController _verifyOtpController = TextEditingController();
  var _enteredOtp;
  bool showSpinner = false;

  OtpFunctions _otpFunctions = OtpFunctions();
  @override
  Widget build(BuildContext context) {
    Map receivedDataFromGetOtpScreen =
        ModalRoute.of(context).settings.arguments;
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
              Navigator.pushReplacementNamed(context, MainScreen.screenID);
            },
            icon: Icon(
              FontAwesomeIcons.chevronLeft,
              color: Colors.black,
            ),
          ),
          title: Text(
            'Verification',
            style: TextStyle(color: Colors.black),
          ),
        ),

//******************** Body *********************/

        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: SafeArea(
            child: Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
//*********************** Image ***********************/
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 3,
                    ),

                    Center(
                      child: Image.asset(
                        kVerifyOtpImages,
                        height: SizeConfig.blockSizeVertical * 25,
                      ),
                    ),

//*********************** OTP Text ***********************/

                    Padding(
                      padding: EdgeInsets.only(
                        left: SizeConfig.blockSizeHorizontal * 7,
                        right: SizeConfig.blockSizeHorizontal * 7,
                        top: SizeConfig.blockSizeHorizontal * 10,
                      ),
                      child: Text(
                        'OTP Verification',
                        style: TextStyle(
                          fontSize: SizeConfig.blockSizeHorizontal * 7,
                          fontWeight: FontWeight.w700,
                          color: Colors.blue[700],
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(
                        left: SizeConfig.blockSizeHorizontal * 7,
                        right: SizeConfig.blockSizeHorizontal * 7,
                        top: SizeConfig.blockSizeHorizontal * 5,
                      ),
                      child: Text(
                        'Enter OTP sent to ${receivedDataFromGetOtpScreen['mobileNumber']}',
                        style: TextStyle(
                          fontSize: SizeConfig.blockSizeHorizontal * 5.3,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),

//*********************** Phone Number Text Field ***********************/

                    Padding(
                      padding: EdgeInsets.only(
                        left: SizeConfig.blockSizeHorizontal * 8,
                        right: SizeConfig.blockSizeHorizontal * 8,
                        top: SizeConfig.blockSizeVertical * 3,
                      ),
                      child: Form(
                        key: _verifyOtpFormKey,
                        child: TextFormField(
                          cursorRadius: Radius.circular(5.0),
                          cursorWidth: 3,
                          cursorHeight: SizeConfig.blockSizeVertical * 3.5,
                          keyboardType: TextInputType.phone,
                          controller: _verifyOtpController,
                          maxLength: 6,
                          validator: (input) {
                            if (input.length < 6) {
                              return 'Please enter valid OTP';
                            } else {
                              return null;
                            }
                          },
                          onChanged: (_input) {
                            _enteredOtp = _input;
                          },
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: SizeConfig.blockSizeHorizontal * 5,
                            fontFamily: kFontRoboto,
                          ),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xff1976D2),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            labelText: 'Enter OTP',
                            prefixIcon: Icon(
                              FontAwesomeIcons.key,
                              color: Colors.black,
                              size: SizeConfig.blockSizeVertical * 2.2,
                            ),
                          ),
                        ),
                      ),
                    ),

//*********************** Resend OTP ***********************/

                    Container(
                      margin: EdgeInsets.only(
                        top: SizeConfig.blockSizeVertical * 1,
                        bottom: SizeConfig.blockSizeVertical * 4,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Didn't receive OTP?",
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w600,
                              fontSize: SizeConfig.blockSizeHorizontal * 5,
                            ),
                          ),
                          TimerButton(
                            label: "Resend OTP",
                            timeOutInSeconds: 20,
                            disabledColor: Colors.grey[800],
                            color: kPrimaryColor,
                            buttonType: ButtonType.OutlineButton,
                            onPressed: () {
                              _otpFunctions.getOtp(
                                phoneNumber: receivedDataFromGetOtpScreen[
                                    'mobileNumber'],
                              );
                            },
                          ),
                        ],
                      ),
                    ),

//*********************** Verify OTP Button ***********************/

                    MaterialButton(
                      onPressed: () async {
                        if (_verifyOtpFormKey.currentState.validate()) {
                          setState(() {
                            showSpinner = true;
                          });
                          var sessionResult = OtpFunctions.sessionDetails;
                          var otpVerificationResult =
                              await _otpFunctions.verifyOtp(
                            userEnteredOtp: _enteredOtp,
                            sessionDetails: sessionResult,
                          );
                          if (otpVerificationResult == 'OTP Matched') {
                            Navigator.pushReplacementNamed(
                              context,
                              NewRegistration.screenID,
                              arguments: {
                                'mobileNumber':
                                    receivedDataFromGetOtpScreen['mobileNumber']
                              },
                            );
                          } else {
                            setState(() {
                              showSpinner = false;
                            });
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Wrong OTP'),
                                  content: Text('Please enter valid OTP'),
                                  actions: [
                                    MaterialButton(
                                      color: kSecondaryColor,
                                      onPressed: () {
                                        _verifyOtpController.clear();
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        'Ok',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              },
                            );
                          }
                        }
                      },
                      child: Text(
                        'VERIFY & PROCEED',
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
        ),
      ),
    );
  }
}
