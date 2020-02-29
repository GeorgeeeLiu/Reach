import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'home.dart';
import 'package:firebase_storage/firebase_storage.dart';



class MessageComposeScreen extends StatefulWidget {
  createState() => MessageComposeState();
}

class MessageComposeState extends State {

//  void initState() {
//    super.initState();
////    FirebaseStorage.instance
////        .getReferenceFromUrl("gs://reachhh-410d1.appspot.com")
////        .then((ref) => stRef = ref);
////    dbRef = FirebaseDatabase.instance.reference().child("message/sent");
//  }
//  DatabaseReference dbRef;
//  StorageReference stRef;

  String otherUser = "";
  String subjectOfNewMessage = "";
  String contentOfNewMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("COMPOSE",
              style: TextStyle(fontFamily: "Oswald", fontSize: 30)),
      ),
        body: Column(children: <Widget>[
          Expanded(
            child: ListView(children: <Widget>[
              TextField(
                autocorrect: false,
                decoration: InputDecoration(hintText: "To",icon:Icon(Icons.perm_identity),),
                controller: TextEditingController(text: otherUser),
                keyboardType: TextInputType.text,
                onChanged: (text) => otherUser = text,),
              Divider(color: Colors.transparent),
              TextField(
               autocorrect: false,
               decoration: InputDecoration(hintText: " Subject",icon:Icon(Icons.short_text)),
               controller: TextEditingController(text: subjectOfNewMessage),
               keyboardType: TextInputType.text,
               onChanged: (text) => subjectOfNewMessage = text,),
              Divider(color: Colors.transparent),
              TextField(
                autocorrect: false,
                decoration: InputDecoration(hintText: " Body",icon:Icon(Icons.subject)),
                controller: TextEditingController(text: contentOfNewMessage),
                textAlign: TextAlign.left,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                onChanged: (text) => contentOfNewMessage = text,),
                   Divider(color: Colors.transparent),
               Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                 FlatButton(
                  textColor: Colors.white,
                  color: Colors.pinkAccent,
                  onPressed: () {Navigator.pop(context);},
                  shape: RoundedRectangleBorder(
                    side: BorderSide(style: BorderStyle.none,),
                    borderRadius: BorderRadius.all(Radius.circular(20)),),
                  child:
                  Icon(Icons.clear, size: 30),),
                 VerticalDivider(color: Colors.transparent),
                 FlatButton(textColor: Colors.white,
                      color: Color.fromARGB(255, 32, 52, 112),
                   onPressed: () => uploadData(),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(style: BorderStyle.none,),
                        borderRadius: BorderRadius.all(Radius.circular(20)),),
                      child:
                      Icon(Icons.send, size: 30),),
              ]
              ),

            ]
                ),
              ),
            ]
        ),
    );
  }
  uploadData() {
    if(otherUser.trim().length == 0
        || subjectOfNewMessage.trim().length == 0
        ||contentOfNewMessage.trim().length == 0)
      return;

    DatabaseReference dbRef1 =
    FirebaseDatabase.instance.reference().child("message/sent/$username");
    DatabaseReference dbRef2 =FirebaseDatabase.instance.reference().child("message/inbox/$otherUser");
    DatabaseReference newEntryRef1 = dbRef1.push();
    DatabaseReference newEntryRef2 = dbRef2.push();

    newEntryRef1.set({
      "from":username,
      "to": otherUser,
      "subject": subjectOfNewMessage,
      "content": contentOfNewMessage,
      "time": DateTime.now().millisecondsSinceEpoch
    });

    newEntryRef2.set({
      "from":username,
      "to": otherUser,
      "subject": subjectOfNewMessage,
      "content": contentOfNewMessage,
      "time": DateTime.now().millisecondsSinceEpoch
    });
    Navigator.pop(context);
  }
}
