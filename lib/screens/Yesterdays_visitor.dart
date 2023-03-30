import 'package:defender/screens/main_screen.dart';
import 'package:defender/utilities/constants.dart';
import 'package:defender/utilities/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class YesterdaysVisitor extends StatefulWidget {
  static const screenID = 'Yesterdays Visitor';
  @override
  _YesterdaysVisitorState createState() => _YesterdaysVisitorState();
}

class _YesterdaysVisitorState extends State<YesterdaysVisitor> {
  @override
  Widget build(BuildContext context) {
    Map receivedData = ModalRoute.of(context).settings.arguments;
    var queryResult = receivedData['queryResult'];
    SizeConfig().init(context);
    FlutterStatusbarcolor.setStatusBarColor(Colors.black);

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
            "Yesterday's Visitor",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                left: SizeConfig.blockSizeHorizontal * 4.5,
                right: SizeConfig.blockSizeHorizontal * 4.5,
                top: SizeConfig.blockSizeVertical * 2,
              ),
              height: SizeConfig.blockSizeVertical * 9,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 0.8,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
                color: Colors.pink[900],
                borderRadius: BorderRadius.circular(
                  SizeConfig.blockSizeVertical * 1.7,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.blockSizeHorizontal * 4,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
//###############  Image  ######################
                    Padding(
                      padding: EdgeInsets.only(
                        left: SizeConfig.blockSizeHorizontal * 4,
                      ),
                      child: Icon(
                        FontAwesomeIcons.walking,
                        color: Colors.white,
                        size: SizeConfig.blockSizeVertical * 2.7,
                      ),
                    ),

//################  Active Visitor Text  ######################
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: SizeConfig.blockSizeHorizontal * 7,
                        ),
                        child: Text(
                          "Yesterday's Visitors",
                          style: TextStyle(
                            fontSize: SizeConfig.blockSizeHorizontal * 5.2,
                            fontFamily: kFontRoboto,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

//################  Number Container  #####################
                    Padding(
                      padding: EdgeInsets.only(
                        right: SizeConfig.blockSizeHorizontal * 5,
                      ),
                      child: Text(
                        '${queryResult.docs.length}',
                        style: TextStyle(
                          fontFamily: kFontRoboto,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: SizeConfig.blockSizeHorizontal * 5.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: SizeConfig.blockSizeVertical * 3),

//##################  ListTile  ####################
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: queryResult.docs.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    isThreeLine: true,
                    leading: Initicon(
                      text:
                          '${queryResult.docs[index].data()['Name']} ${queryResult.docs[index].data()['Surname']}',
                      backgroundColor: Colors.indigo[800],
                    ),
                    title: Text(
                      '${queryResult.docs[index].data()['Name']} ${queryResult.docs[index].data()['Surname']}',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: kFontRoboto,
                        fontWeight: FontWeight.w500,
                        fontSize: SizeConfig.blockSizeHorizontal * 5.3,
                      ),
                    ),
                    subtitle: Column(
                      children: [
//************************  Row  ******************************/
                        Padding(
                          padding: EdgeInsets.only(
                            top: SizeConfig.blockSizeVertical * 0.9,
                          ),
                          child: Row(
                            children: [
//####################  House No  ###################
                              Expanded(
                                flex: 0,
                                child: Icon(
                                  FontAwesomeIcons.solidBuilding,
                                  color: Colors.pink[400],
                                  size: SizeConfig.blockSizeVertical * 1.8,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                flex: 0,
                                child: Text(
                                  '${queryResult.docs[index].data()['Block_Name']} - ${queryResult.docs[index].data()['House_Number']}',
                                  style: TextStyle(
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 4.3,
                                    fontFamily: kFontRoboto,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),

//####################  Date  ###################

                              Expanded(
                                flex: 3,
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  child: Icon(
                                    FontAwesomeIcons.calendarDay,
                                    color: Colors.blue[400],
                                    size: SizeConfig.blockSizeVertical * 1.8,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                flex: 0,
                                child: Text(
                                  '${DateFormat('dd MMM yyyy').format((queryResult.docs[index].data()['Entry_Time']).toDate())}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 4.3,
                                    fontFamily: kFontRoboto,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

//************************  Row 02 ******************************/

                        Padding(
                          padding: EdgeInsets.only(
                            top: SizeConfig.blockSizeVertical * 0.6,
                          ),
                          child: Row(
                            children: [
//####################  Vehicle Number  ###################
                              Expanded(
                                flex: 0,
                                child: Icon(
                                  FontAwesomeIcons.car,
                                  color: Colors.pink[400],
                                  size: SizeConfig.blockSizeVertical * 1.8,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                flex: 0,
                                child: Text(
                                  '${queryResult.docs[index].data()['Vehicle_Number']}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 4.3,
                                    fontFamily: kFontRoboto,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),

//####################  Time  ###################
                              Expanded(
                                flex: 3,
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  child: Icon(
                                    FontAwesomeIcons.solidClock,
                                    color: Colors.blue[400],
                                    size: SizeConfig.blockSizeVertical * 1.8,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 11,
                              ),
                              Text(
                                '${DateFormat('hh:mm a').format((queryResult.docs[index].data()['Entry_Time']).toDate())}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize:
                                      SizeConfig.blockSizeHorizontal * 4.3,
                                  fontFamily: kFontRoboto,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(
                                width: 19,
                              ),
                            ],
                          ),
                        ),

                        Divider(
                          height: SizeConfig.blockSizeVertical * 2.4,
                          thickness: SizeConfig.blockSizeVertical * 0.12,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
