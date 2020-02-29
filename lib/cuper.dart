import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


class CuperScreen extends StatefulWidget{
  createState() {
    return CuperState();
  }
}

class CuperState extends State{

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          title: Text('WARN'),
          backgroundColor: Colors.redAccent,
        ),
        body:

        Center(
          child: CupertinoAlertDialog(
            title: Text('Mention:'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Divider(color: Colors.transparent, height: 10.0,),
                  Text('Successfully Save The Information',style: TextStyle(fontFamily: "Oswald", fontSize: 15.0),),
                  Divider(color: Colors.transparent, height: 10.0,),
                  Text('Please Return',style: TextStyle(fontFamily: "Oswald", fontSize: 15.0),),
                ],
              ),
            ),

            actions: [
              CupertinoDialogAction(
                child: Text('Yes'),
                onPressed: () => setState(() {Navigator.pop(context);}),
              ),
              CupertinoDialogAction(
                child: Text('Cancel'),
                onPressed: () => setState(() {Navigator.pop(context);}),
              ),
            ],
          ),
        ),

    );
  }
}