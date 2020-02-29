import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'home.dart';

Map selectedPostInfo;

class ProductShareScreen extends StatefulWidget {
  createState() => ProductShareState();
}


class ProductShareState extends State {
  DatabaseReference dbRef;
  StorageReference stRef;
  List<Map> data;

  String titleOfNewPost = "";
  String titleOfNewPost1 = "";
  File imgFileOfNewPost;

  int selectedIndex1 = 0;


  void initState() {
    super.initState();

    FirebaseStorage.instance
        .getReferenceFromUrl("gs://reach2019-82cef.appspot.com")
        .then((ref) => stRef = ref);

    dbRef = FirebaseDatabase.instance.reference().child("productShare");

    dbRef.onValue.listen((event) {

      data = sort(event.snapshot.value, "post_time", false);

      if (mounted)
        setState(() {});
    });


  }


  @override
  Widget build(BuildContext context) {
    var childWidgets = <Widget>[];



    if (data != null) {

      for (int i = 0; i < data.length; i++) {

        var postData = data[i];

        String title = postData["title"];
        String describe = postData["describe"];
        String url = postData["url"];
        String user = postData["user"];
        String postTime = DateFormat("d MMM yyyy\nh:mm a")
            .format(DateTime.fromMillisecondsSinceEpoch(postData["post_time"]));


        childWidgets.add(GestureDetector(

          child: Card(
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
                      Text(
                        user,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.bold),
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(Icons.local_grocery_store),
                      Text(describe),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
      }
    }

    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
          title: Text("PRODUCT LIST",
              style: TextStyle(fontFamily: "Oswald", fontSize: 30)),
         backgroundColor: Colors.green,
        leading: Icon(null),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),


      body: Column(

        children: <Widget>[
          Expanded(
            child: ListView(
              children: childWidgets,
            ),
          ),
          Container(

            child: Column(
              children: <Widget>[

                BottomNavigationBar(
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      title: Text('Home '),

                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.add_circle),
                      title: Text('Release'),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person),
                      title: Text('Me'),
                    ),
                  ],


                  currentIndex: selectedIndex1,
                  fixedColor: Colors.redAccent,
                  onTap: (index1) {
                    setState(() {
                      selectedIndex1 = index1;
                    });
                    index1 == 0 ? Navigator.pop(context): Container();
                    index1 == 1 ? Navigator.pushNamed(context, "release"): Container();
                    index1 == 2 ? Navigator.pushNamed(context, "myself"): Container();


                  },


                ),

              ],
            ),
          ),
        ],
      ),
    );
  }


  uploadData() {

    if (titleOfNewPost.trim().length == 0 || imgFileOfNewPost == null)
      return;

    String myTitle = titleOfNewPost.trim();
    String myDescribe = titleOfNewPost1;
    File myFile = imgFileOfNewPost;


    titleOfNewPost = "";
    titleOfNewPost1 = "";
    imgFileOfNewPost = null;
    setState(() {});

    DatabaseReference dbNewEntry = dbRef.push();

    StorageReference rfNewEntry = stRef.child("productShare/${dbNewEntry.key}");

    rfNewEntry.putFile(myFile).onComplete.then((_) async {

      rfNewEntry.getDownloadURL().then((url){
        dbNewEntry.set({
          "title": myTitle,
          "describe": myDescribe,
          "url": url,
          "post_time": DateTime.now().millisecondsSinceEpoch,
          "user": username,
        });
      });
    });

  }

}
