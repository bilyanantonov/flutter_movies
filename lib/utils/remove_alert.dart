import 'package:flutter/material.dart';

class RemoveAlert {
  static Future<bool> alertMessage(BuildContext context) {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to remove from your favorites'),
            actions: <Widget>[
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(true),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    "YES",
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: 10),
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    "NO",
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }
}
