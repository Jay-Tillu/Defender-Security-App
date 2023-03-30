import 'package:defender/screens/main_screen.dart';
import 'package:defender/screens/contact_us.dart';
import 'package:defender/utilities/size_config.dart';
import 'package:defender/utilities/show_error.dart';
import 'package:defender/utilities/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  static const screenID = 'Login Screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String _email, _password;
  bool showSpinner = false;
  bool _passwordVisible;
  bool _emailVisible;
  ErrorHandling _errorHandling = ErrorHandling();

  // Method to check whether user is logged in or not.
  checkAuthentication() async {
    _firebaseAuth.authStateChanges().listen(
      (user) {
        if (user != null) {
          Navigator.pushReplacementNamed(
            context,
            MainScreen.screenID,
          );
        }
      },
    );
  }

  // Method for sign in the user.
  void signIn() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        await _firebaseAuth.signInWithEmailAndPassword(
          email: _email,
          password: _password,
        );

        setState(() {
          showSpinner = false;
        });
      } catch (e) {
        _errorHandling.showError(errorMessage: e.message, context: context);
        _emailController.clear();
        _passwordController.clear();
        setState(() {
          showSpinner = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentication();
    _passwordVisible = false;
    _emailVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    FlutterStatusbarcolor.setStatusBarColor(Colors.black);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: ModalProgressHUD(
          color: kSecondaryColor,
          inAsyncCall: showSpinner,
          child: SafeArea(
            child: Container(
              child: ListView(
                children: [
                  Stack(
                    children: [
                      Image.asset(
                        kBlackCircleImage,
                        width: SizeConfig.blockSizeHorizontal * 63,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: SizeConfig.blockSizeHorizontal * 6.5,
                              right: SizeConfig.blockSizeHorizontal * 5,
                              top: SizeConfig.blockSizeVertical * 8,
                            ),
                            child: Text(
                              'Login',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                fontSize: SizeConfig.blockSizeHorizontal * 8,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: SizeConfig.blockSizeVertical * 8,
                              left: SizeConfig.blockSizeHorizontal * 2,
                            ),
                            child: Image.asset(
                              kLoginCircleImage,
                              width: SizeConfig.blockSizeHorizontal * 15,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
//****************  Login Field  ***********************
                        Padding(
                          padding: EdgeInsets.only(
                            top: SizeConfig.blockSizeVertical * 2,
                            left: SizeConfig.blockSizeHorizontal * 10,
                            right: SizeConfig.blockSizeHorizontal * 10,
                          ),
                          child: TextFormField(
                            cursorWidth: 3,
                            cursorHeight: SizeConfig.blockSizeVertical * 3,
                            keyboardType: TextInputType.emailAddress,
                            obscureText: !_emailVisible,
                            controller: _emailController,
                            validator: (input) {
                              if (input.isEmpty) {
                                return 'Provide an Email';
                              } else {
                                return null;
                              }
                            },
                            onSaved: (input) {
                              _email = input;
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
                              hintText: 'Email',
                              prefixIcon: Icon(
                                Icons.email_rounded,
                                color: Colors.black,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _emailVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _emailVisible = !_emailVisible;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),

//****************  Password Field  ***********************
                        Padding(
                          padding: EdgeInsets.only(
                            top: SizeConfig.blockSizeVertical * 3,
                            left: SizeConfig.blockSizeHorizontal * 10,
                            right: SizeConfig.blockSizeHorizontal * 10,
                          ),
                          child: TextFormField(
                            obscureText: !_passwordVisible,
                            cursorWidth: 3,
                            cursorHeight: SizeConfig.blockSizeVertical * 3,
                            controller: _passwordController,
                            validator: (input) {
                              if (input.length < 6) {
                                return 'Password should be 6 character atleast';
                              } else {
                                return null;
                              }
                            },
                            onSaved: (input) {
                              _password = input;
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
                              hintText: 'Password',
                              prefixIcon: Icon(
                                FontAwesomeIcons.lock,
                                color: Colors.black,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

//****************  Login Button Section  ********************
                  Padding(
                    padding: EdgeInsets.only(
                      top: SizeConfig.blockSizeVertical * 4,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            right: SizeConfig.blockSizeHorizontal * 14,
                          ),
                          child: Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              fontFamily: kFontRoboto,
                            ),
                          ),
                        ),
                        RawMaterialButton(
                          fillColor: Colors.black,
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                showSpinner = true;
                              });
                              signIn();
                            }
                          },
                          shape: CircleBorder(),
                          padding:
                              EdgeInsets.all(SizeConfig.blockSizeVertical * 3),
                          constraints: BoxConstraints(),
                          child: Icon(
                            FontAwesomeIcons.arrowRight,
                            color: Colors.white,
                            size: SizeConfig.blockSizeHorizontal * 8,
                          ),
                        ),
                      ],
                    ),
                  ),

//**************  Contact Us Section  ******************
                  Padding(
                    padding: EdgeInsets.only(
                      top: SizeConfig.blockSizeHorizontal * 8,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: SizeConfig.blockSizeHorizontal * 2,
                              right: SizeConfig.blockSizeHorizontal * 2,
                            ),
                            child: SizedBox(
                              height: SizeConfig.blockSizeVertical * 0.15,
                              width: SizeConfig.blockSizeHorizontal * 15,
                              child: Container(color: Colors.black),
                            ),
                          ),
                        ),
                        Text(
                          'Want to register your community ?',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: SizeConfig.blockSizeHorizontal * 4,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: SizeConfig.blockSizeHorizontal * 2,
                              left: SizeConfig.blockSizeHorizontal * 2,
                            ),
                            child: SizedBox(
                              height: SizeConfig.blockSizeVertical * 0.15,
                              width: SizeConfig.blockSizeHorizontal * 15,
                              child: Container(color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(
                      top: SizeConfig.blockSizeVertical * 4,
                      left: SizeConfig.blockSizeHorizontal * 10,
                      right: SizeConfig.blockSizeHorizontal * 10,
                    ),
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.pushNamed(context, ContactUsScreen.screenID);
                      },
                      color: Colors.blue.shade700,
                      height: SizeConfig.blockSizeVertical * 6.5,
                      child: Text(
                        'Contact Us',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: kFontRoboto,
                          fontSize: SizeConfig.blockSizeHorizontal * 4.8,
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
          ),
        ),
      ),
    );
  }
}
