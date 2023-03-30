import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:defender/utilities/size_config.dart';
import 'package:defender/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContactUsScreen extends StatelessWidget {
  static const screenID = 'Contact Us Screen';
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    FlutterStatusbarcolor.setStatusBarColor(Colors.black);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: ColorfulSafeArea(
          color: Colors.white,
          child: Container(
            child: Column(
              children: [
                Stack(
                  children: [
                    Image.asset(
                      kContactUsImage,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: SizeConfig.blockSizeVertical * 1.5,
                        left: SizeConfig.blockSizeVertical * 1,
                      ),
                      child: IconButton(
                        icon: Icon(
                          FontAwesomeIcons.chevronLeft,
                          color: Colors.white,
                          size: SizeConfig.blockSizeVertical * 4,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),

//*******************  Contact Card  ****************
                Padding(
                  padding: EdgeInsets.only(
                    left: SizeConfig.blockSizeHorizontal * 6,
                    right: SizeConfig.blockSizeHorizontal * 6,
                    top: SizeConfig.blockSizeVertical * 8,
                    bottom: SizeConfig.blockSizeVertical * 5,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xffE3F2FD),
                      borderRadius: BorderRadius.circular(
                        SizeConfig.blockSizeHorizontal * 5,
                      ),
                      border: Border.all(
                        width: SizeConfig.blockSizeHorizontal * 1,
                        color: Color(0xff1976D2),
                      ),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: SizeConfig.blockSizeVertical * 4,
                          ),
                          child: Image.asset(
                            kLogoImage,
                            height: SizeConfig.blockSizeVertical * 9,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: SizeConfig.blockSizeVertical * 1.3,
                          ),
                          child: Text(
                            'Defender',
                            style: TextStyle(
                              fontFamily: kFontRoboto,
                              fontSize: SizeConfig.blockSizeHorizontal * 6.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.only(
                            left: SizeConfig.blockSizeHorizontal * 5,
                          ),

//*******************  Contact Us  *******************
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: SizeConfig.blockSizeVertical * 2.5,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.phoneAlt,
                                  size: SizeConfig.blockSizeHorizontal * 4.5,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: SizeConfig.blockSizeHorizontal * 4,
                                  ),
                                  child: Text(
                                    'Contact Number',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize:
                                          SizeConfig.blockSizeHorizontal * 4.2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: SizeConfig.blockSizeVertical * 0.5,
                          ),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: SizeConfig.blockSizeHorizontal * 13.5,
                              ),
                              child: Text(
                                '7201013140',
                                style: TextStyle(
                                  fontSize:
                                      SizeConfig.blockSizeHorizontal * 4.7,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.blue[800],
                                ),
                              ),
                            ),
                          ),
                        ),

//**************************  Email  ***********************
                        Padding(
                          padding: EdgeInsets.only(
                            top: SizeConfig.blockSizeVertical * 1.5,
                            left: SizeConfig.blockSizeHorizontal * 5,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                FontAwesomeIcons.solidEnvelope,
                                size: SizeConfig.blockSizeHorizontal * 4.5,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: SizeConfig.blockSizeHorizontal * 4),
                                child: Text(
                                  'Email ID',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 4.2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.only(
                              top: SizeConfig.blockSizeVertical * 0.3),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: SizeConfig.blockSizeHorizontal * 13.5),
                              child: Text(
                                'contactus.defender@gmail.com',
                                style: TextStyle(
                                  fontSize:
                                      SizeConfig.blockSizeHorizontal * 4.3,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.blue[800],
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(
                          height: SizeConfig.blockSizeVertical * 4,
                        ),
                      ],
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
