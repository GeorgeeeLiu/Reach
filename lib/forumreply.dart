import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'home.dart';
import 'forum.dart';

class ForumreplyScreen extends StatefulWidget {
  createState() => ForumreplyState();
}

class ForumreplyState extends State {
  DatabaseReference replyDbRef;
  String replyContent = "";
  String key = "";
  List<Map> replyData;


  uploadData1() {
    if (replyContent.trim().length <= 0) return;

    String myreply = replyContent.trim();
    // clear the user inputs
    replyContent = "";
    setState(() {});
    // new reference to path "/photoShare/{post_ID}/{username}/"
    var newEntryRef = replyDbRef.push();

    newEntryRef.set({
      // set the values
      "replyer": username,
      "replycontent": myreply,
      // "score": newScore,
      "post_time": DateTime.now().millisecondsSinceEpoch
    });

    replyDbRef.once().then((snapshot) {
      int count = 0;
      Map records = snapshot.value as Map;
      records.values.forEach((r) {
        count++;
      });
      var total = count;
      selectedPostInfo["replyCount"] = total;
      var selectedPostKey = selectedPostInfo["key"];
      var countDbRef =
      FirebaseDatabase.instance.reference().child("forum/$selectedPostKey");
      countDbRef.update({
        "replyCount": total,
      });
    });

    resetScreen();
  }


  @override
  Widget build(BuildContext context) {
    var childWidget = <Widget>[];
    var postData = selectedPostInfo;
    String topic = postData["topic"];
    String content = postData["content"];
    String people = postData["user"];

    String postTime = DateFormat("d MMM yyyy h:mm a")
        .format(DateTime.fromMillisecondsSinceEpoch(postData["post_time"]));
    childWidget.insert(
      0, // position 0 means the beginning of the list
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "$content",
            style: TextStyle(fontFamily: "Oswald", fontSize: 24.0),
          ),
          VerticalDivider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.person_outline,
                    size: 25,
                  ),
                  Text(
                    people,
                    textAlign: TextAlign.right,
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              VerticalDivider(),
              VerticalDivider(),
              Row(
//                  crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.access_time,
                    size: 13,
                  ),
                  Text(postTime,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 13.0,
                      )),
                ],
              ),
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.comment,
                    size: 25,
                  ),
                  VerticalDivider(),
                  Text(postData["replyCount"].toString(),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: 25.0,
                          color: Colors.indigo,
                          fontWeight: FontWeight.bold))
                ],
              ),
            ],
          ),
        ],
      ),
    );

    if (replyData != null) {
      // if the value of variable scoresData is ready...
      for (int i = 0; i < replyData.length; i++) {
        // for each post...
        var record = replyData[i];

        String replyer = record["replyer"];
        String replycontent = record["replycontent"];
        String postTime = DateFormat("d MMM yyyy\nh:m a")
            .format(DateTime.fromMillisecondsSinceEpoch(record["post_time"]));

        // add a ListTile with the score data
        childWidget.add(ListTile(
          leading: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.person,
                size: 22,
                color: Colors.black45,
              ),
              Text("$replyer")
            ],
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                replycontent,
                style: TextStyle(fontFamily: "Oswald", fontSize: 27.0),
              ),
            ],
          ),
          trailing: Text(postTime, textAlign: TextAlign.right),
        ));
        childWidget.add(Divider());
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("$topic",
            style: TextStyle(fontFamily: "Oswald", fontSize: 30)),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(children: childWidget),
          ),
          Container(
            // this widget (after an Expanded widget) will be put at the bottom of the screen
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                  color: Colors.black38,
                  offset: Offset(0, -1.5),
                  blurRadius: 10.0),
            ]),
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(hintText: "You reply"),
                  controller: TextEditingController(text: replyContent),
                  onChanged: (text) => replyContent = text,
                  maxLines: 5,
                ),
                IconButton(
                    icon: Icon(Icons.send), onPressed: () => uploadData1())
              ],
            ),
          ),
        ],
      ),
    );
  }

  resetScreen() {
    setState(() {
      replyContent = "";
    });
  }


  void initState() {
    super.initState();

    var selectedPostKey = selectedPostInfo["key"];
    // Firebase database reference to the scores of the PhotoShare post
    replyDbRef = FirebaseDatabase.instance
        .reference()
        .child("forum/$selectedPostKey/Reply");

    // when the data of the scores of the PhotoShare post are ready...
    replyDbRef.onValue.listen((event) {
      // obtain the data and sort them by "post_time" in desc. order
      replyData = sort(event.snapshot.value, "post_time", false);
      if (mounted) setState(() {});
    });
  }



}
