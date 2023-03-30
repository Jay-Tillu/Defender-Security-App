import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:defender/screens/main_screen.dart';
import 'package:defender/utilities/constants.dart';
import 'package:defender/utilities/show_error.dart';
import 'package:defender/utilities/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tap_debouncer/tap_debouncer.dart';

class MakeEntry extends StatefulWidget {
  static const screenID = 'Make Entry';
  @override
  _MakeEntryState createState() => _MakeEntryState();
}

class _MakeEntryState extends State<MakeEntry> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _vehiclenoController = TextEditingController();
  TextEditingController _blockNameController = TextEditingController();
  TextEditingController _houseNumberController = TextEditingController();
  TextEditingController _noOfVisitorController = TextEditingController();

  String _vehicleNumber, _blockName, _houseNumber, _numberOfVisitor;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  ErrorHandling _errorHandling = ErrorHandling();

  var _currentItemSelected;

  void _onDropDownItemSelected(String newValueSelected) {
    setState(() {
      this._currentItemSelected = newValueSelected;
    });
  }

  var purposeList = [
    "Family",
    "Friends",
    "Food Delivery",
    "Package Delivery",
    "Housekeeper",
    "Services",
    "Other"
  ];

//$$$$$$$$$$$$$$$$$$$  Method to get User's UID from Firebase  $$$$$$$$$$$$$$$$$$$$$
  getCurrentUID() {
    return _firebaseAuth.currentUser.uid;
  }

  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime.now();
    DateTime todaysDate =
        DateTime(currentDate.year, currentDate.month, currentDate.day);
    gotoMainScreen() =>
        Navigator.pushReplacementNamed(context, MainScreen.screenID);
    SizeConfig().init(context);
    FlutterStatusbarcolor.setStatusBarColor(Colors.black);
    Map receivedDataFromMainScreen = ModalRoute.of(context).settings.arguments;
    String mobileNumber = receivedDataFromMainScreen['mobileNumber'];
    String name = receivedDataFromMainScreen['name'];
    String surname = receivedDataFromMainScreen['surname'];
    String photoUrl = receivedDataFromMainScreen['photoUrl'];
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
            'Make Entry',
            style: TextStyle(color: Colors.black),
          ),
        ),

//***************************  Body  *****************************/
        body: SafeArea(
          child: ListView(
            children: [
//****************  Image  ***********************
              Padding(
                padding: EdgeInsets.only(
                  top: SizeConfig.blockSizeVertical * 5,
                  left: SizeConfig.blockSizeHorizontal * 12,
                  right: SizeConfig.blockSizeHorizontal * 12,
                ),
                child: photoUrl == null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(
                          SizeConfig.blockSizeVertical * 3,
                        ),
                        child: Image.asset(
                          kLogoImage,
                          fit: BoxFit.fill,
                          height: SizeConfig.blockSizeVertical * 40,
                          // width: 200,
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(
                          SizeConfig.blockSizeVertical * 3,
                        ),
                        child: FadeInImage.assetNetwork(
                          placeholder: kImmolationLogoImage,
                          image: photoUrl,
                          fadeInCurve: Curves.fastOutSlowIn,
                          height: SizeConfig.blockSizeVertical * 40,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),

//****************  Name  ***********************

              Padding(
                padding: EdgeInsets.only(
                  top: SizeConfig.blockSizeVertical * 5,
                  left: SizeConfig.blockSizeVertical * 3.7,
                  right: SizeConfig.blockSizeVertical * 3.7,
                ),
                child: Container(
                  width: SizeConfig.blockSizeHorizontal * 80,
                  height: SizeConfig.blockSizeVertical * 7,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    boxShadow: [
                      BoxShadow(
                        color: kSecondaryColor,
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
                          FontAwesomeIcons.solidAddressCard,
                          size: SizeConfig.blockSizeHorizontal * 5,
                        ),
                      ),
                      Text(
                        name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: kFontRoboto,
                          fontSize: SizeConfig.blockSizeHorizontal * 5.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

//****************  Surname  ***********************

              Padding(
                padding: EdgeInsets.only(
                  top: SizeConfig.blockSizeVertical * 3,
                  left: SizeConfig.blockSizeVertical * 3.7,
                  right: SizeConfig.blockSizeVertical * 3.7,
                ),
                child: Container(
                  width: SizeConfig.blockSizeHorizontal * 80,
                  height: SizeConfig.blockSizeVertical * 7,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    boxShadow: [
                      BoxShadow(
                        color: kSecondaryColor,
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
                          FontAwesomeIcons.solidAddressCard,
                          size: SizeConfig.blockSizeHorizontal * 5,
                        ),
                      ),
                      Text(
                        surname,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: kFontRoboto,
                          fontSize: SizeConfig.blockSizeHorizontal * 5.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

//****************  Mobile Number  ***********************

              Padding(
                padding: EdgeInsets.only(
                  top: SizeConfig.blockSizeVertical * 3,
                  left: SizeConfig.blockSizeVertical * 3.7,
                  right: SizeConfig.blockSizeVertical * 3.7,
                ),
                child: Container(
                  width: SizeConfig.blockSizeHorizontal * 80,
                  height: SizeConfig.blockSizeVertical * 7,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    boxShadow: [
                      BoxShadow(
                        color: kSecondaryColor,
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
                          fontSize: SizeConfig.blockSizeHorizontal * 5.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Form(
                key: _formKey,
                child: Column(
                  children: [
//****************  Vehicle Number Field  ***********************
                    Padding(
                      padding: EdgeInsets.only(
                        top: SizeConfig.blockSizeVertical * 3,
                        left: SizeConfig.blockSizeHorizontal * 7,
                        right: SizeConfig.blockSizeHorizontal * 7,
                      ),
                      child: TextFormField(
                        cursorWidth: 3,
                        controller: _vehiclenoController,
                        cursorHeight: SizeConfig.blockSizeVertical * 3,
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.characters,
                        onSaved: (String input) {
                          _vehicleNumber = input;
                        },
                        validator: (input) {
                          if (input.isEmpty) {
                            return 'Provide a Vehicle Number';
                          } else {
                            return null;
                          }
                        },
                        style: TextStyle(
                          fontSize: SizeConfig.blockSizeHorizontal * 5,
                          fontFamily: kFontRoboto,
                        ),
                        cursorRadius: Radius.circular(5.0),
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          hintText: 'Vehicle Number',
                          prefixIcon: Icon(
                            FontAwesomeIcons.car,
                            color: Colors.black,
                            size: SizeConfig.blockSizeHorizontal * 5,
                          ),
                        ),
                      ),
                    ),

//****************  Block Name Field  ***********************
                    Padding(
                      padding: EdgeInsets.only(
                        top: SizeConfig.blockSizeVertical * 3,
                        left: SizeConfig.blockSizeHorizontal * 7,
                        right: SizeConfig.blockSizeHorizontal * 7,
                      ),
                      child: TextFormField(
                        cursorWidth: 3,
                        controller: _blockNameController,
                        cursorHeight: SizeConfig.blockSizeVertical * 3,
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.characters,
                        validator: (String input) {
                          if (input.isEmpty) {
                            return 'Provide a Block Name';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (input) {
                          _blockName = input;
                        },
                        style: TextStyle(
                          fontSize: SizeConfig.blockSizeHorizontal * 5,
                          fontFamily: kFontRoboto,
                        ),
                        cursorRadius: Radius.circular(5.0),
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          hintText: 'Block Name',
                          prefixIcon: Icon(
                            FontAwesomeIcons.solidBuilding,
                            color: Colors.black,
                            size: SizeConfig.blockSizeHorizontal * 5,
                          ),
                        ),
                      ),
                    ),

//****************  House Number Field  ***********************
                    Padding(
                      padding: EdgeInsets.only(
                        top: SizeConfig.blockSizeVertical * 3,
                        left: SizeConfig.blockSizeHorizontal * 7,
                        right: SizeConfig.blockSizeHorizontal * 7,
                      ),
                      child: TextFormField(
                        cursorWidth: 3,
                        controller: _houseNumberController,
                        cursorHeight: SizeConfig.blockSizeVertical * 3,
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.characters,
                        validator: (String input) {
                          if (input.isEmpty) {
                            return 'Provide a House Number';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (input) {
                          _houseNumber = input;
                        },
                        style: TextStyle(
                          fontSize: SizeConfig.blockSizeHorizontal * 5,
                          fontFamily: kFontRoboto,
                        ),
                        cursorRadius: Radius.circular(5.0),
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          hintText: 'House Number',
                          prefixIcon: Icon(
                            FontAwesomeIcons.home,
                            color: Colors.black,
                            size: SizeConfig.blockSizeHorizontal * 5,
                          ),
                        ),
                      ),
                    ),

//****************  No. Of Visitors Field  ***********************
                    Padding(
                      padding: EdgeInsets.only(
                        top: SizeConfig.blockSizeVertical * 3,
                        left: SizeConfig.blockSizeHorizontal * 7,
                        right: SizeConfig.blockSizeHorizontal * 7,
                      ),
                      child: TextFormField(
                        cursorWidth: 3,
                        controller: _noOfVisitorController,
                        cursorHeight: SizeConfig.blockSizeVertical * 3,
                        keyboardType: TextInputType.phone,
                        validator: (String input) {
                          if (input.isEmpty) {
                            return 'Provide a No of Visitors';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (input) {
                          _numberOfVisitor = input;
                        },
                        style: TextStyle(
                          fontSize: SizeConfig.blockSizeHorizontal * 5,
                          fontFamily: kFontRoboto,
                        ),
                        cursorRadius: Radius.circular(5.0),
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          hintText: 'Number of Visitors',
                          prefixIcon: Icon(
                            FontAwesomeIcons.users,
                            color: Colors.black,
                            size: SizeConfig.blockSizeHorizontal * 5,
                          ),
                        ),
                      ),
                    ),

//****************  Purpose Field  ***********************
                    Container(
                      padding: EdgeInsets.only(
                        top: SizeConfig.blockSizeVertical * 3,
                        left: SizeConfig.blockSizeHorizontal * 7,
                        right: SizeConfig.blockSizeHorizontal * 7,
                      ),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        icon: Container(
                          margin: EdgeInsets.only(
                            bottom: SizeConfig.blockSizeVertical * 5,
                          ),
                          child: Icon(FontAwesomeIcons.sortDown),
                        ),
                        underline: Divider(
                          thickness: 1,
                          color: kSecondaryColor,
                        ),
                        hint: Container(
                          margin: EdgeInsets.only(
                            bottom: SizeConfig.blockSizeVertical * 3.3,
                          ),
                          child: Text(
                            "Purpose of Visit",
                            style: TextStyle(
                              fontSize: SizeConfig.blockSizeHorizontal * 5,
                              fontFamily: kFontRoboto,
                            ),
                          ),
                        ),
                        items: purposeList.map((String dropDownStringItem) {
                          return DropdownMenuItem<String>(
                            value: dropDownStringItem,
                            child: Container(
                                margin: EdgeInsets.only(bottom: 20),
                                child: Text(
                                  dropDownStringItem,
                                  style: TextStyle(
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 5,
                                    fontFamily: kFontRoboto,
                                  ),
                                )),
                          );
                        }).toList(),
                        onChanged: (String newValueSelected) {
                          _onDropDownItemSelected(newValueSelected);
                        },
                        value: _currentItemSelected,
                      ),
                    ),

//****************  Make Entry Button  ***********************
                    Container(
                      margin: EdgeInsets.only(
                        top: SizeConfig.blockSizeVertical * 6,
                        bottom: SizeConfig.blockSizeVertical * 15,
                      ),
                      child: TapDebouncer(
                        onTap: () async {
                          final uid = getCurrentUID();
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            try {
//####################### sending data into Society Data  #######################/
                              _firestore
                                  .collection("Societies")
                                  .doc(uid)
                                  .collection("Society_Data")
                                  .add(
                                {
                                  'Name': name,
                                  'Surname': surname,
                                  'Mobile_Number': mobileNumber,
                                  'Vehicle_Number': _vehicleNumber,
                                  'Block_Name': _blockName,
                                  'House_Number': _houseNumber,
                                  'No_of_Visitor': _numberOfVisitor,
                                  'Purpose': _currentItemSelected,
                                  'Entry_Time': currentDate,
                                  'Todays_Date': todaysDate,
                                  'Url': photoUrl,
                                },
                              );

                              CoolAlert.show(
                                context: context,
                                type: CoolAlertType.success,
                                title: 'Success!',
                                text: 'User added',
                                backgroundColor: kSecondaryColor,
                                onConfirmBtnTap: gotoMainScreen,
                              );
                            } catch (e) {
                              _errorHandling.showError(
                                errorMessage: e.message,
                                context: context,
                              );
                              _blockNameController.clear();
                              _vehiclenoController.clear();
                              _noOfVisitorController.clear();
                              _houseNumberController.clear();
                            }
                          }
                        },
                        builder:
                            (BuildContext context, TapDebouncerFunc onTap) {
                          return MaterialButton(
                            onPressed: onTap,
                            disabledColor: Colors.grey[600],
                            height: SizeConfig.blockSizeVertical * 6,
                            child: Text(
                              'Make Entry',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: SizeConfig.blockSizeHorizontal * 5,
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                SizeConfig.blockSizeHorizontal * 15,
                              ),
                            ),
                            color: Colors.blue[600],
                            minWidth: SizeConfig.blockSizeHorizontal * 86,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
