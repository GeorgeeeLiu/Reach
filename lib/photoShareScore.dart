import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'home.dart'; // require its variable username and sort() method
import 'photoShare.dart'; // require its variable selectedPostKey

class PhotoShareScoreScreen extends StatefulWidget {
  createState() => PhotoShareScoreState();
}

class PhotoShareScoreState extends State {

  void initState() {
    super.initState();
    var selectedPostKey = selectedPostInfo["key"];

    scoresDbRef = FirebaseDatabase.instance.reference().child("photoShareScore/$selectedPostKey");

    scoresDbRef.onValue.listen((event) {
// obtain the data and sort them by "post_time" in desc. order
      scoresData = sort(event.snapshot.value, "post_time", false);
      if (mounted) setState(() {});
    });
  }

  DatabaseReference scoresDbRef;
  List scoresData;
  var newScore = 0;

  @override
  Widget build(BuildContext context) {
    var childWidgets = <Widget>[];

    var postData = selectedPostInfo;
    String title = postData["title"];
    String url = postData["url"];
    String user = postData["user"];
    String postTime = DateFormat("d MMM yyyy, h:m a")
        .format(DateTime.fromMillisecondsSinceEpoch(postData["post_time"]));

    // if postData["score"] is integer, it just returns it as a string,
    // otherwise, convert it to double and cut the decimal places then return it as a string
    String score = postData["score"] is int
        ? "${postData["score"]}"
        : postData["score"].toDouble().toStringAsFixed(1);

    // add a Card widget to the beginning of the childWidgets list
    childWidgets.insert(
      0, // position 0 means the beginning of the list
      Card(
        // the code for creating a Card widget is copied from photoShare.dart
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ListTile(
              title: Text(
                title,
                style: TextStyle(fontFamily: "Oswald", fontSize: 24.0),
              ),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(user, textAlign: TextAlign.right, style:
                  TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                  ),
                  Text(postTime,
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 10.0)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Image.network(
                url,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Icon(Icons.star_border),
                  Text(score),
                ],
              ),
            )
          ],
        ),
      ),
    );

    if (scoresData != null) {
      // if the value of variable scoresData is ready...
      scoresData.forEach(
            (record) {
          // for each score record...

          String scorer = record["scorer"];
          int score = record["score"];
          String postTime = DateFormat("d MMM yyyy\nh:m a")
              .format(DateTime.fromMillisecondsSinceEpoch(record["post_time"]));

          // add a ListTile with the score data
          childWidgets.add(ListTile(
            leading: Text(scorer),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.star_border,
                  size: 32,
                  color: Colors.amber,
                ),
                Text(
                  "$score",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            trailing: Text(postTime, textAlign: TextAlign.right),
          ));

          childWidgets.add(Divider());
        },
      );
    }

    return Scaffold(
      appBar: AppBar(

          title: Text("PHOTO SHARE",
              style: TextStyle(fontFamily: "Oswald", fontSize: 30))),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: childWidgets,
            ),
          ),
          Container(
            // this widget (added after an Expanded widget) will be put at the bottom of the screen
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                  color: Colors.black38,
                  offset: Offset(0, -1.5),
                  blurRadius: 10.0),
            ]),
            padding: EdgeInsets.all(20.0),
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                      icon: Icon(
                        Icons.star_border,
                        color: newScore >= 1 ? Colors.amber : Colors.black,
                      ),
                      iconSize: 32,
                      onPressed: () => mark(1)),
                  IconButton(
                      icon: Icon(
                        Icons.star_border,
                        color: newScore >= 2 ? Colors.amber : Colors.black,
                      ),
                      iconSize: 32,
                      onPressed: () => mark(2)),
                  IconButton(
                      icon: Icon(
                        Icons.star_border,
                        color: newScore >= 3 ? Colors.amber : Colors.black,
                      ),
                      iconSize: 32,
                      onPressed: () => mark(3)),
                ],
              ),
              trailing: IconButton(
                  icon: Icon(Icons.send, color: Colors.black),
                  iconSize: 32,
                  onPressed: () => uploadData()),
            ),
          ),
        ],
      ),
    );
  }

  /* set the value to variable newScore */
  mark(int score) {
    setState(() => newScore = score);
  }

  /* upload the new score data to Firebase database */
  uploadData() {


    if (newScore == 0) return;
// new reference to path "/photoShare/{post_ID}/{username}/"
    var newEntryRef = scoresDbRef.child(username);
    newEntryRef.set({
// set the values
      "scorer": username,
      "score": newScore,
      "post_time": DateTime.now().millisecondsSinceEpoch
    });

    scoresDbRef.once().then((snapshot) {
// obtain the updated data of the scores
      int total = 0;
      int count = 0;
      Map records = snapshot.value as Map;
      records.values.forEach((r) {
// for each score record...
        Map data = r as Map;
        total += data["score"]; // calculate the sum of the scores
        count++; // count the number of records
      });
      var average = total / count;
      selectedPostInfo["score"] = average;
      var selectedPostKey = selectedPostInfo["key"];
      var postDbRef = FirebaseDatabase.instance
          .reference().child("photoShare/$selectedPostKey");
      postDbRef.update({
        "score": average,
      }); // put the average score to the PhotoShare post
    });

  }


}
