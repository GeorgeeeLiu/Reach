import 'package:flutter/material.dart';

class UnavailableScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("Unavailable", style: TextStyle(fontSize: 50.0),),
                Text("Tap to back", style: TextStyle(fontSize: 20.0),),
              ],
            ),
          )),
    );
  }
}
