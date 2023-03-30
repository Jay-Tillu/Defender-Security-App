import 'dart:io';
import 'package:cool_alert/cool_alert.dart';
import 'package:defender/screens/main_screen.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_ink_well/image_ink_well.dart';
import 'package:defender/utilities/constants.dart';
import 'package:defender/utilities/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:defender/utilities/show_error.dart';
import 'package:path/path.dart';
import 'package:tap_debouncer/tap_debouncer.dart';

class NewRegistration extends StatefulWidget {
  static const screenID = 'New Registration';
  @override
  _NewRegistrationState createState() => _NewRegistrationState();
}

class _NewRegistrationState extends State<NewRegistration> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var _currentItemSelected;
  CollectionReference imageReference;
  firebase_storage.Reference firebaseStorageReference;
  String imageUrl;
  File _image;
  final imagePicker = ImagePicker();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  ErrorHandling _errorHandling = ErrorHandling();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _surnameController = TextEditingController();
  TextEditingController _vehiclenoController = TextEditingController();
  TextEditingController _blockNameController = TextEditingController();
  TextEditingController _houseNumberController = TextEditingController();
  TextEditingController _noOfVisitorController = TextEditingController();
  var mobileNumber;

  var purposeList = [
    "Family",
    "Friends",
    "Food Delivery",
    "Package Delivery",
    "Housekeeper",
    "Services",
    "Other"
  ];

  String _name,
      _surname,
      _vehicleNumber,
      _blockName,
      _houseNumber,
      _numberOfVisitor;

  //$$$$$$$$$$$$$$$$$$$  Function to Take Photo  $$$$$$$$$$$$$$$$$$$$$
  Future takeAphoto() async {
    try {
      // Capture the image from camera
      final capturedImage =
          await imagePicker.getImage(source: ImageSource.camera);

      // Crop the image
      File croppedFile = await ImageCropper.cropImage(
          sourcePath: capturedImage.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop the Image',
            toolbarColor: kPrimaryColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          ));

      // Compress the image
      var compressedImage = await FlutterImageCompress.compressAndGetFile(
        croppedFile.path,
        capturedImage.path,
        quality: 10,
      );

      // print("Cropped Image Size ${croppedFile.lengthSync()}");
      // print("Crompressed Image Size ${compressedImage.lengthSync()}");

      setState(() {
        _image = File(compressedImage.path);
      });
    } catch (e) {
      _errorHandling.showError(context: context, errorMessage: e.message);
    }
  }

  //$$$$$$$$$$$$$$$$$$$  Function Upload the Photo  $$$$$$$$$$$$$$$$$$$$$

  Future uploadImage() async {
    String fileName = basename(_image.path);
    firebaseStorageReference = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('$mobileNumber/$fileName');
    await firebaseStorageReference.putFile(_image).whenComplete(() async {
      await firebaseStorageReference.getDownloadURL().then((value) {
        imageUrl = value;
      });
    });
  }

  //$$$$$$$$$$$$$$$$$$$  Method to get User's UID from Firebase  $$$$$$$$$$$$$$$$$$$$$
  getCurrentUID() {
    return _firebaseAuth.currentUser.uid;
  }

  void _onDropDownItemSelected(String newValueSelected) {
    setState(() {
      this._currentItemSelected = newValueSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    Map receivedDataFromVerifyOtpScreen =
        ModalRoute.of(context).settings.arguments;

    mobileNumber = receivedDataFromVerifyOtpScreen['mobileNumber'];
    DateTime currentDate = DateTime.now();
    DateTime todaysDate =
        DateTime(currentDate.year, currentDate.month, currentDate.day);

    gotoMainScreen() =>
        Navigator.pushReplacementNamed(context, MainScreen.screenID);

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
            'New Registration',
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
                child: _image == null
                    ? RoundedRectangleImageInkWell(
                        height: SizeConfig.blockSizeVertical * 40,
                        width: SizeConfig.blockSizeHorizontal * 20,
                        fit: BoxFit.fill,
                        borderRadius: BorderRadius.only(
                          bottomLeft:
                              Radius.circular(SizeConfig.blockSizeVertical * 3),
                          bottomRight:
                              Radius.circular(SizeConfig.blockSizeVertical * 3),
                          topLeft:
                              Radius.circular(SizeConfig.blockSizeVertical * 3),
                          topRight:
                              Radius.circular(SizeConfig.blockSizeVertical * 3),
                        ),
                        onPressed: () {
                          takeAphoto();
                        },
                        image: AssetImage(kImmolationLogoImage),
                      )
                    : RoundedRectangleImageInkWell(
                        height: SizeConfig.blockSizeVertical * 40,
                        width: SizeConfig.blockSizeHorizontal * 20,
                        fit: BoxFit.cover,
                        borderRadius: BorderRadius.only(
                          bottomLeft:
                              Radius.circular(SizeConfig.blockSizeVertical * 3),
                          bottomRight:
                              Radius.circular(SizeConfig.blockSizeVertical * 3),
                          topLeft:
                              Radius.circular(SizeConfig.blockSizeVertical * 3),
                          topRight:
                              Radius.circular(SizeConfig.blockSizeVertical * 3),
                        ),
                        onPressed: () {
                          takeAphoto();
                        },
                        image: FileImage(_image),
                      ),
              ),

              Form(
                key: _formKey,
                child: Column(
                  children: [
//****************  Name Field  ***********************
                    Padding(
                      padding: EdgeInsets.only(
                        top: SizeConfig.blockSizeVertical * 5,
                        left: SizeConfig.blockSizeHorizontal * 7,
                        right: SizeConfig.blockSizeHorizontal * 7,
                      ),
                      child: TextFormField(
                        cursorWidth: 3,
                        controller: _nameController,
                        cursorHeight: SizeConfig.blockSizeVertical * 3,
                        keyboardType: TextInputType.name,
                        validator: (String input) {
                          if (input.isEmpty) {
                            return 'Provide a Name';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (input) {
                          _name = input;
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
                          hintText: 'Name',
                          prefixIcon: Icon(
                            FontAwesomeIcons.solidAddressCard,
                            color: Colors.black,
                            size: SizeConfig.blockSizeHorizontal * 5,
                          ),
                        ),
                      ),
                    ),

//****************  Surname Field  ***********************
                    Padding(
                      padding: EdgeInsets.only(
                        top: SizeConfig.blockSizeVertical * 3,
                        left: SizeConfig.blockSizeHorizontal * 7,
                        right: SizeConfig.blockSizeHorizontal * 7,
                      ),
                      child: TextFormField(
                        cursorWidth: 3,
                        controller: _surnameController,
                        cursorHeight: SizeConfig.blockSizeVertical * 3,
                        keyboardType: TextInputType.name,
                        validator: (String input) {
                          if (input.isEmpty) {
                            return 'Provide a Surname';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (input) {
                          _surname = input;
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
                          hintText: 'Surname',
                          prefixIcon: Icon(
                            FontAwesomeIcons.solidAddressCard,
                            color: Colors.black,
                            size: SizeConfig.blockSizeHorizontal * 5,
                          ),
                        ),
                      ),
                    ),

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
                              await uploadImage();
//####################### sending data into Society Data  #######################/
                              _firestore
                                  .collection("Societies")
                                  .doc(uid)
                                  .collection("Society_Data")
                                  .add(
                                {
                                  'Name': _name,
                                  'Surname': _surname,
                                  'Mobile_Number': mobileNumber,
                                  'Vehicle_Number': _vehicleNumber,
                                  'Block_Name': _blockName,
                                  'House_Number': _houseNumber,
                                  'No_of_Visitor': _numberOfVisitor,
                                  'Purpose': _currentItemSelected,
                                  'Entry_Time': currentDate,
                                  'Todays_Date': todaysDate,
                                  'Url': imageUrl,
                                },
                              );
//#######################  sending data into Common Data  #######################/
                              _firestore.collection('CommonData').add({
                                'Mobile_Number': mobileNumber,
                                'Name': _name,
                                'Surname': _surname,
                                'Url': imageUrl,
                              });

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
                                  errorMessage: e.message, context: context);
                              _blockNameController.clear();
                              _vehiclenoController.clear();
                              _surnameController.clear();
                              _nameController.clear();
                              _noOfVisitorController.clear();
                              _houseNumberController.clear();
                            }
                          }
                        },
                        builder:
                            (BuildContext context, TapDebouncerFunc onTap) {
                          return MaterialButton(
                            disabledColor: Colors.grey[600],
                            onPressed: onTap,
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
