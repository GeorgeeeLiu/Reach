import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'message.dart';

class MessageDetailScreen extends StatefulWidget {
  createState() => MessageDetailState();
}

class MessageDetailState extends State {

  @override
  Widget build(BuildContext context) {
    String subject = selectedMessage["subject"];
    String from = selectedMessage["from"];
    String to = selectedMessage["to"];
    String content = selectedMessage["content"];
    String time = DateFormat("dd/MM/yyyy, h:mm a").format(DateTime.fromMillisecondsSinceEpoch(selectedMessage["time"]));


    return Scaffold(
        backgroundColor:  Color.fromARGB(255, 96, 96, 96),
        appBar: AppBar(title: Text("$subject",
            style: TextStyle(fontFamily: "Oswald", fontSize: 30)),
        ),
      body:
      Column(children: <Widget>[
        Expanded(
         child:
         ListView(children: <Widget>[
          ListTile(
           leading: RichText(overflow: TextOverflow.ellipsis,
                text:TextSpan(style: Theme.of(context).textTheme.body1,
               children: [
              TextSpan(text: ' $from ',style: TextStyle(color: Colors.white,fontSize: 14.0,),),
              WidgetSpan(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: Icon(Icons.arrow_forward,size:18,color: Colors.white,),
                ),
              ),
              TextSpan(text: ' $to ',style: TextStyle(color: Colors.white,fontSize: 14.0),),
            ],),),

            trailing:  Text(time, textAlign: TextAlign.right,
                style: TextStyle(fontSize: 12.0,color:Colors.white),)
          ),
           Card( color: Colors.white,
              margin:EdgeInsets.all(15.0),
              elevation: 15.0,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
            child: Container(
                margin: EdgeInsets.all(15.0),
                width: MediaQuery.of(context).size.width,
                constraints: BoxConstraints(minHeight: 100,),
              child:
              Text("$content", style: new TextStyle(fontSize: 20.0, ),
                        softWrap: true, textAlign: TextAlign.left,),

              ),
            ),
      ])
        ),
      ]),
    );
  }
}