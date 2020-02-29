import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'home.dart';


Map selectedMessage;
class MessageInboxScreen extends StatefulWidget {
  createState() => MessageInboxState();
}

class MessageInboxState extends State {
  void initState() {super.initState();
    dbRef = FirebaseDatabase.instance.reference().child("message/inbox/$username");
    dbRef.onValue.listen((event) {
      messageInbox = sort(event.snapshot.value, "time", false);
      if (mounted) setState(() {});});
  }
  DatabaseReference dbRef;
  StorageReference stRef;
  List<Map> messageInbox;

  @override
  Widget build(BuildContext context) {
    var childWidgets = <Widget>[];
    if (messageInbox != null) {
      for (int i = 0; i < messageInbox.length; i++) {
        var message = messageInbox[i];
        String subject = message["subject"];
        String otherUser = message["from"];
        String content = message["content"];
        String time = DateFormat("dd/MM/yyyy\nh:mm a").format(DateTime.fromMillisecondsSinceEpoch(message["time"]));

        childWidgets.add(
            GestureDetector(
              behavior: HitTestBehavior.opaque,
          onTap: () => openForMessage(i),
          child: Container(width: double.infinity,
            child: Column(
            children: <Widget>[
              Divider(color: Colors.transparent,height: 5.5,),
              Row(mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(padding: EdgeInsets.all(1),
                    height: 55,
                    width: MediaQuery.of(context).size.width *0.2,
                    child: Column(
                        children: <Widget>[
                          Text('$otherUser',
                            style: TextStyle(fontSize: 14.0),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,),
                          Icon(Icons.arrow_downward, size: 18,color: Colors.grey,),
                          Text('$username',
                            style: TextStyle(fontSize: 14.0),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ]),
                  ),
                  Container(height: 55,
                    padding: EdgeInsets.all(1),
                    width: MediaQuery.of(context).size.width *0.6,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('$subject',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: "Oswald", fontSize: 20.0,
                              color: Color.fromARGB(255, 32, 52, 112),),),
                          Text('$content',maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 14.0, color: Colors.grey)),
                        ]),),
                  Container(height: 55,
                    padding: EdgeInsets.all(1),
                     width: MediaQuery.of(context).size.width *0.2,
                    child: Text(time, textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 14.0)),),
                ],),

              Divider(color: Colors.transparent,height: 5),
            ],
          ),
          ),
        )
        );
        childWidgets.add(Divider(height: 1.0, color: Colors.black38));
      }
    }

        return Scaffold(
            appBar: AppBar(
                title: Text("INBOX", style: TextStyle(fontFamily: "Oswald", fontSize: 30)),

            ),

            floatingActionButton: FloatingActionButton(
              backgroundColor: Color.fromARGB(255, 32, 52, 112),
              child: Icon(Icons.add),

              onPressed: () {
                Navigator.pushNamed(context, "message/compose");
              },
            ),

            endDrawer:
            Container(
                width: MediaQuery.of(context).size.width / 3,
                color: Colors.white60,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton.icon(
                        icon: Icon(Icons.email),
                        label: Text("Inbox"),
                        onPressed: () {Navigator.pop(context);},
                        shape: RoundedRectangleBorder(
                          side: BorderSide(style: BorderStyle.none,),
                          borderRadius: BorderRadius.all(Radius.circular(15)),),
                      ),
                      RaisedButton.icon(
                        icon: Icon(Icons.send),
                        label: Text("Sent "),
                        onPressed: () {Navigator.pushNamed(context, "message/sent");},
                        shape: RoundedRectangleBorder(
                          side: BorderSide(style: BorderStyle.none,),
                          borderRadius: BorderRadius.all(Radius.circular(15)),),)
                    ])),

            body: Column(
                children: <Widget>[Expanded(
                  child: ListView(children: childWidgets),
                  ),
                ])
        );
      }

  openForMessage(int index) {
    selectedMessage = messageInbox[index];
    Navigator.pushNamed(context, "message/detail");}
}




class MessageSentScreen extends StatefulWidget {
  createState() => MessageSentState();}

class MessageSentState extends State {

  void initState() {super.initState();
    dbRef = FirebaseDatabase.instance.reference().child("message/sent/$username");
    dbRef.onValue.listen((event) {
      messageSent = sort(event.snapshot.value, "time", false);
      if (mounted)
        setState(() {});
    });
  }
  DatabaseReference dbRef;
  StorageReference stRef;
  List<Map> messageSent;

  @override
  Widget build(BuildContext context) {
    var childWidgets = <Widget>[];

    if (messageSent != null) {
      for (int i = 0; i < messageSent.length; i++) {
        var message = messageSent[i];
        String subject = message["subject"];
        String otherUser = message["to"];
        String content = message["content"];
        String time = DateFormat("dd/MM/yyyy\nh:mm a").format(DateTime.fromMillisecondsSinceEpoch(message["time"]));

        childWidgets.add(GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => openForMessage(i),
          child: Container(width: double.infinity,
            child: Column(
              children: <Widget>[
                Divider(color: Colors.transparent,height: 5.5,),
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(padding: EdgeInsets.all(1),
                      height: 55,
                      width: MediaQuery.of(context).size.width *0.2,
                      child: Column(
                          children: <Widget>[
                            Text('$username',
                              style: TextStyle(fontSize: 14.0),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,),
                            Icon(Icons.arrow_downward, size: 18,color: Colors.grey,),
                            Text('$otherUser',
                              style: TextStyle(fontSize: 14.0),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ]),
                    ),
                    Container(height: 55,
                      padding: EdgeInsets.all(1),
                      width: MediaQuery.of(context).size.width *0.6,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('$subject',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: "Oswald", fontSize: 20.0,
                                color: Color.fromARGB(255, 32, 52, 112),),),
                            Text('$content',maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 14.0, color: Colors.grey)),
                          ]),),
                    Container(height: 55,
                      padding: EdgeInsets.all(1),
                      width: MediaQuery.of(context).size.width *0.2,
                      child: Text(time, textAlign: TextAlign.right,
                          style: TextStyle(fontSize: 14.0)),),
                  ],),

                Divider(color: Colors.transparent,height: 5),
              ],
            ),
          ),
        ));
        childWidgets.add(Divider(height: 1.0, color: Colors.black38));
      }
    }



    return Scaffold(
        appBar: AppBar(
            title: Text("SENT",
                style: TextStyle(fontFamily: "Oswald", fontSize: 30)),
         ),

        endDrawer: Container(
            width: MediaQuery.of(context).size.width / 3,
            color: Colors.white60,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  RaisedButton.icon(
                    icon: Icon(Icons.email),
                    label: Text("Inbox"),
                    onPressed: () {Navigator.pop(context);Navigator.pop(context);Navigator.pop(context);},
                    shape: RoundedRectangleBorder(
                      side: BorderSide(style: BorderStyle.none,),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                  RaisedButton.icon(
                    icon: Icon(Icons.send),
                    label: Text("Sent "),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    shape: RoundedRectangleBorder(
                      side: BorderSide(style: BorderStyle.none,),
                      borderRadius: BorderRadius.all(Radius.circular(15)),),
                  )])
        ),


        floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromARGB(255, 32, 52, 112),
          child: Icon(Icons.add),

          onPressed: () {
            Navigator.pushNamed(context, "message/compose");
          },
        ),

        body:
        Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  children:
                  childWidgets,
                ),
              ),
            ])
    );
  }

  openForMessage(int index) {
    selectedMessage = messageSent[index];
    Navigator.pushNamed(context, "message/detail");
  }

}







