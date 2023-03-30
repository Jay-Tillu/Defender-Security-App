import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:defender/screens/Yesterdays_visitor.dart';
import 'package:defender/screens/make_entry.dart';
import 'package:defender/screens/settings.dart';
import 'package:defender/screens/login_screen.dart';
import 'package:defender/screens/nouser_found.dart';
import 'package:defender/screens/todays_visitor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:defender/utilities/size_config.dart';
import 'package:defender/utilities/constants.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:defender/utilities/show_error.dart';

class MainScreen extends StatefulWidget {
  static const screenID = 'Main Screen';
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<FormState> _mobileNumberFormKey = GlobalKey<FormState>();
  TextEditingController _mobileNumberTextFieldController =
      TextEditingController();
  String mobileNumber;
  String name;
  String surname;
  String photoUrl;
  var entryTime;
  bool _showSpinner = false;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User firebaseUser;
  bool isSignedIn = false;
  ErrorHandling _errorHandling = ErrorHandling();
  var receivedEntryTime;

  checkAuthentication() async {
    _firebaseAuth.authStateChanges().listen(
      (user) {
        if (user == null) {
          Navigator.pushReplacementNamed(context, LoginScreen.screenID);
        }
      },
    );
  }

  //$$$$$$$$$$$$$$$$$$$  Method to get User's UID from Firebase  $$$$$$$$$$$$$$$$$$$$$
  getCurrentUID() {
    return _firebaseAuth.currentUser.uid;
  }

  getUser() {
    User firebaseUser = _firebaseAuth.currentUser;
    firebaseUser?.reload();
    firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser != null) {
      setState(() {
        this.firebaseUser = firebaseUser;
        this.isSignedIn = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentication();
    this.getUser();
  }

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    DateTime todaysDate = DateTime(now.year, now.month, now.day);
    DateTime yesterdaysDate = DateTime(now.year, now.month, now.day - 1);
    SizeConfig().init(context);
    FlutterStatusbarcolor.setStatusBarColor(Colors.black);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: ModalProgressHUD(
          inAsyncCall: _showSpinner,
          child: ColorfulSafeArea(
            child: SingleChildScrollView(
              child: Container(
                height: SizeConfig.screenHeight,
                child: Column(
                  children: [
//*******************  AppBar  **********************
                    Padding(
                      padding: EdgeInsets.only(
                        top: SizeConfig.blockSizeVertical * 2,
                        left: SizeConfig.blockSizeHorizontal * 6,
                        right: SizeConfig.blockSizeHorizontal * 2.5,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                kLogoImage,
                                height: SizeConfig.blockSizeVertical * 3.8,
                              ),
                              SizedBox(
                                width: SizeConfig.blockSizeHorizontal * 5,
                              ),
                              Text(
                                "Defender",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: SizeConfig.blockSizeHorizontal * 8,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: kFontRoboto,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.settings_rounded,
                              color: Colors.black,
                              size: SizeConfig.blockSizeVertical * 4,
                            ),
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                SettingsScreen.screenID,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
//***************************  Visitors Containers ********************/

                    Padding(
                      padding: EdgeInsets.only(
                        top: SizeConfig.blockSizeVertical * 3,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
//#######################  Todays Visitor  ##########################

                          Container(
                            width: SizeConfig.blockSizeHorizontal * 35,
                            height: SizeConfig.blockSizeVertical * 20,
                            child: InkWell(
                              onTap: () async {
                                try {
                                  setState(() {
                                    _showSpinner = true;
                                  });
                                  final uid = await getCurrentUID();
                                  final QuerySnapshot result =
                                      await FirebaseFirestore.instance
                                          .collection('Societies')
                                          .doc(uid)
                                          .collection('Society_Data')
                                          .where('Todays_Date',
                                              isEqualTo: todaysDate)
                                          .get();

                                  if (result.docs.isNotEmpty) {
                                    Navigator.pushNamed(
                                      context,
                                      TodaysVisitor.screenID,
                                      arguments: {
                                        'queryResult': result,
                                      },
                                    );
                                    setState(() {
                                      _showSpinner = false;
                                    });
                                  } else {
                                    _errorHandling.showError(
                                      context: context,
                                      errorMessage: 'No Data Found.',
                                    );
                                    setState(() {
                                      _showSpinner = false;
                                    });
                                  }
                                } catch (e) {
                                  _errorHandling.showError(
                                    errorMessage: e.message,
                                    context: context,
                                  );
                                  setState(() {
                                    _showSpinner = false;
                                  });
                                }
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    FontAwesomeIcons.users,
                                    size: SizeConfig.blockSizeVertical * 4,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: SizeConfig.blockSizeVertical * 2,
                                    ),
                                    child: Text(
                                      'Today\'s\nVisitors',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize:
                                            SizeConfig.blockSizeHorizontal * 5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.green,
                                  spreadRadius: 1,
                                ),
                              ],
                              borderRadius: BorderRadius.circular(
                                SizeConfig.blockSizeHorizontal * 4,
                              ),
                            ),
                          ),

//#######################  Yesterdays Visitor  ##########################
                          Container(
                            width: SizeConfig.blockSizeHorizontal * 35,
                            height: SizeConfig.blockSizeVertical * 20,
                            child: InkWell(
                              onTap: () async {
                                try {
                                  setState(() {
                                    _showSpinner = true;
                                  });
                                  final uid = await getCurrentUID();
                                  final QuerySnapshot result =
                                      await FirebaseFirestore.instance
                                          .collection('Societies')
                                          .doc(uid)
                                          .collection('Society_Data')
                                          .where('Todays_Date',
                                              isEqualTo: yesterdaysDate)
                                          .get();

                                  if (result.docs.isNotEmpty) {
                                    Navigator.pushNamed(
                                      context,
                                      YesterdaysVisitor.screenID,
                                      arguments: {
                                        'queryResult': result,
                                      },
                                    );
                                    setState(() {
                                      _showSpinner = false;
                                    });
                                  } else {
                                    _errorHandling.showError(
                                      context: context,
                                      errorMessage: 'No Data Found.',
                                    );
                                    setState(() {
                                      _showSpinner = false;
                                    });
                                  }
                                } catch (e) {
                                  _errorHandling.showError(
                                    errorMessage: e.message,
                                    context: context,
                                  );
                                  setState(() {
                                    _showSpinner = false;
                                  });
                                }
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    FontAwesomeIcons.walking,
                                    size: SizeConfig.blockSizeVertical * 4,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: SizeConfig.blockSizeVertical * 2,
                                    ),
                                    child: Text(
                                      'Yesterday\'s\nVisitors',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize:
                                            SizeConfig.blockSizeHorizontal * 5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.pink[50],
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.pink,
                                  spreadRadius: 1,
                                ),
                              ],
                              borderRadius: BorderRadius.circular(
                                SizeConfig.blockSizeHorizontal * 4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

//*******************  Phone Search Card  *********************
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(
                        top: SizeConfig.blockSizeVertical * 10,
                        left: SizeConfig.blockSizeHorizontal * 4.5,
                        right: SizeConfig.blockSizeHorizontal * 4.5,
                      ),
                      decoration: BoxDecoration(
                          color: Color(0xffE3F2FD),
                          borderRadius: BorderRadius.circular(
                            SizeConfig.blockSizeHorizontal * 8,
                          ),
                          border: Border.all(
                            width: SizeConfig.blockSizeHorizontal * 1,
                            color: Color(0xff1976d2),
                          )),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              top: SizeConfig.blockSizeVertical * 4,
                            ),
                            child: Text(
                              'Search',
                              style: TextStyle(
                                fontFamily: kFontRoboto,
                                fontSize: SizeConfig.blockSizeHorizontal * 6.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),

//######################   Mobile Number Text Field  ########################
                          Form(
                            key: _mobileNumberFormKey,
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: SizeConfig.blockSizeHorizontal * 8,
                                right: SizeConfig.blockSizeHorizontal * 8,
                                top: SizeConfig.blockSizeVertical * 3,
                              ),
                              child: TextFormField(
                                controller: _mobileNumberTextFieldController,
                                cursorRadius: Radius.circular(5.0),
                                cursorWidth: 3,
                                cursorHeight: SizeConfig.blockSizeVertical * 3,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: SizeConfig.blockSizeHorizontal * 5,
                                  fontFamily: kFontRoboto,
                                ),
                                keyboardType: TextInputType.phone,
                                maxLength: 10,
                                validator: (input) {
                                  if (input.length < 10) {
                                    return 'Please enter 10 digit mobile number';
                                  } else {
                                    return null;
                                  }
                                },
                                onChanged: (_input) {
                                  mobileNumber = _input;
                                },
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  hintText: 'Phone Number',
                                  hintStyle: TextStyle(
                                    color: Colors.black,
                                  ),
                                  prefixIcon: Icon(
                                    FontAwesomeIcons.phoneAlt,
                                    color: Colors.black,
                                    size: SizeConfig.blockSizeVertical * 2.2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: SizeConfig.blockSizeVertical * 3,
                              bottom: SizeConfig.blockSizeVertical * 4,
                            ),
                            child: MaterialButton(
                              onPressed: () async {
                                if (_mobileNumberFormKey.currentState
                                    .validate()) {
                                  setState(() {
                                    _showSpinner = true;
                                  });

                                  final QuerySnapshot result =
                                      await FirebaseFirestore.instance
                                          .collection('CommonData')
                                          .where(
                                            'Mobile_Number',
                                            isEqualTo: mobileNumber,
                                          )
                                          .get();
                                  final List<DocumentSnapshot> myDocuments =
                                      result.docs;

                                  if (myDocuments.length == 1) {
                                    result.docs.forEach((value) {
                                      mobileNumber =
                                          value.data()['Mobile_Number'];
                                      name = value.data()['Name'];
                                      surname = value.data()['Surname'];
                                      photoUrl = value.data()['Url'];
                                    });
                                    Navigator.pushReplacementNamed(
                                      context,
                                      MakeEntry.screenID,
                                      arguments: {
                                        'mobileNumber': mobileNumber,
                                        'name': name,
                                        'surname': surname,
                                        'photoUrl': photoUrl,
                                      },
                                    );
                                    setState(() {
                                      _showSpinner = false;
                                    });
                                  } else {
                                    Navigator.pushNamed(
                                      context,
                                      NoUserFound.screenID,
                                      arguments: {
                                        'mobileNumber': mobileNumber,
                                      },
                                    );
                                    setState(() {
                                      _showSpinner = false;
                                    });
                                  }
                                }
                              },
                              minWidth: SizeConfig.blockSizeHorizontal * 70,
                              height: SizeConfig.blockSizeVertical * 6,
                              color: Colors.blue[800],
                              child: Text(
                                'Search',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: kFontRoboto,
                                  fontSize:
                                      SizeConfig.blockSizeHorizontal * 4.8,
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  SizeConfig.blockSizeHorizontal * 15,
                                ),
                              ),
                            ),
                          ),
                        ],
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
