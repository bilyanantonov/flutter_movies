import 'package:flutter/material.dart';

class RemoveAlert {
  static Future<bool> alertMessage(BuildContext context) {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to remove it from your favorites'),
            actions: [
               FlatButton(
                child: Text("Yes"),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
               FlatButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              )
            ],
          ),
        ) ??
        false;
  }
}
