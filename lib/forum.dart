
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'home.dart';


Map selectedPostInfo;

class ForumScreen extends StatefulWidget {
  createState() => ForumState();
}

class ForumState extends State {
  DatabaseReference dbRef; // Reference of Firebase database
  List<Map> data;

  String titleOfNewPost = "";
  String contentOfNewPost="";

  uploadData1() {
    if (titleOfNewPost
        .trim()
        .length == 0 || contentOfNewPost == null)
      return;
    String myTitle = titleOfNewPost.trim();
    String myContent = contentOfNewPost.trim();
    // clear the user inputs
    titleOfNewPost = "";
    setState(() {});
    DatabaseReference newEntryRef = dbRef.push();
    newEntryRef.set({
      "topic": myTitle,
      "post_time": DateTime.now().millisecondsSinceEpoch,
      "user": username,
      "content": myContent,
      "replyCount": 0
    });
    resetScreen();
  }

  @override
  Widget build(BuildContext context) {
    List childWidget = <Widget>[];

    if (data != null) {
        // if the data of PhotoShare are ready...
        for (int i = 0; i < data.length; i++) {
          // for each post...
          var postData = data[i];

        String topic = postData["topic"];
        String content = postData["content"];
        String people = postData["user"];
        String postTime = DateFormat("d MMM yyyy\nh:mm a")
            .format(DateTime.fromMillisecondsSinceEpoch(postData["post_time"]));

        childWidget.add(GestureDetector(
            onTap: () => openForReply(i),
            child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[



                     ListTile(
                          leading: Text(postData["replyCount"].toString(),style: TextStyle(fontSize: 18)),
                          title: Text(
                            topic,
                            style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                              color: Colors.indigo,
                           ),
                           ),
                         subtitle: Text(
                           content,
                           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                           ),
                         trailing: Column(
                           crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                               people,
                             textAlign: TextAlign.right,
                             style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                           ),
                              Text(postTime,
                               textAlign: TextAlign.right,
                                style: TextStyle(fontSize: 10.0)),
                             ],
                             ),

                              ),

                            ],
                        ),

                   )));

      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Text("FORUM",
              style: TextStyle(fontFamily: "Oswald", fontSize: 30))),
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
                  decoration: InputDecoration(hintText: "topic"),
                  controller: TextEditingController(text: titleOfNewPost),
                  onChanged: (text) => titleOfNewPost = text,
                ),
                TextField(
                  decoration: InputDecoration(hintText: "cotent"),
                  controller: TextEditingController(text: contentOfNewPost),
                  onChanged: (text) => contentOfNewPost = text,
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
      titleOfNewPost = "";
      contentOfNewPost = "";
    });
  }
  openForReply(int index) {
    selectedPostInfo = data[index];
    Navigator.pushNamed(context, "forumreply");
  }

  void initState() {
    dbRef = FirebaseDatabase.instance.reference().child("forum");
    dbRef.onValue.listen((event) {
      // when the updated data of PhotoShare are ready...
      // obtain the data and sort them
      // by "post_time" in descending order
      data = sort(event.snapshot.value, "post_time", false);

      if (mounted) // refresh the screen if it is still available
        setState(() {});
    });

  }



}
