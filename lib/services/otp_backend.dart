import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class OtpFunctions {
  final apiKey = 'Secret API Key';
  static var sessionDetails;

  Future urlResolver(url) async {
    http.Response apiResponse = await http.get(url);
    if (apiResponse.statusCode == 200) {
      var data = convert.jsonDecode(apiResponse.body);
      sessionDetails = data['Details'];
      return sessionDetails;
    }
  }

// Function to send the OTP request
  Future<dynamic> getOtp({String phoneNumber}) async {
    var getOtpUrl =
        'https://2factor.in/API/V1/$apiKey/SMS/+91$phoneNumber/AUTOGEN/Defender+Security';
    var receivedOtp = await urlResolver(getOtpUrl);
    return receivedOtp;
  }

// Function to verify the OTP request
  Future verifyOtp({
    String userEnteredOtp,
    String sessionDetails,
    BuildContext context,
    bool showSpinner,
    TextEditingController textEditingController,
  }) async {
    var verifyOtpUrl =
        'https://2factor.in/API/V1/$apiKey/SMS/VERIFY/$sessionDetails/$userEnteredOtp';

    var verifyOtp = await urlResolver(verifyOtpUrl);
    return verifyOtp;
  }
}
