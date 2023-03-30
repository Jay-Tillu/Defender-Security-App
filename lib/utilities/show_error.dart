import 'package:defender/utilities/constants.dart';
import 'package:flutter/material.dart';

class ErrorHandling {
  // Method for showing the error if occured during sign in.
  showError({String errorMessage, context}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(errorMessage),
          actions: [
            MaterialButton(
              color: kSecondaryColor,
              onPressed: () {
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
