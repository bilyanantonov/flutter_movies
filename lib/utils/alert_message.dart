import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlertMessage {
  static Future<void> alertMessage(
      BuildContext context, String warning, String message) {
    return showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(warning),
            content: Text(message),
            actions: [
              FlatButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
