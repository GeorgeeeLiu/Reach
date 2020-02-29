import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'home.dart';

Map selectedPostInfo;

class PhotoShareScreen extends StatefulWidget {
  createState() => PhotoShareState();
}


class PhotoShareState extends State {
  DatabaseReference dbRef; // Reference of Firebase database
  StorageReference stRef; // Reference of Firebase storage
  List<Map> data;

  String titleOfNewPost = "";
  File imgFileOfNewPost;

  void initState() {
    super.initState();

    // Firebase storage reference to the specific url
    FirebaseStorage.instance
        .getReferenceFromUrl("gs://reach2019-82cef.appspot.com")
        .then((ref) => stRef = ref);

    // Firebase database reference to path "/photoShare"
    dbRef = FirebaseDatabase.instance.reference().child("photoShare");

    dbRef.onValue.listen((event) {
      // when the updated data of PhotoShare are ready...
      // obtain the data and sort them
      // by "post_time" in descending order
      data = sort(event.snapshot.value, "post_time", false);

      if (mounted) // refresh the screen if it is still available
        setState(() {});
    });


  }


  @override
  Widget build(BuildContext context) {
    var childWidgets = <Widget>[];

    if (data != null) {
      // if the data of PhotoShare are ready...
      for (int i = 0; i < data.length; i++) {
        // for each post...
        var postData = data[i];

        String title = postData["title"];
        String url = postData["url"];
        String user = postData["user"];
        String score = postData["score"] is int
            ? "${postData["score"]}"
            : postData["score"].toDouble().toStringAsFixed(1);
        String postTime = DateFormat("d MMM yyyy\nh:mm a")
            .format(DateTime.fromMillisecondsSinceEpoch(postData["post_time"]));

        // add a GestureDetector widget

        /* beginning of simple layout
        childWidgets.add(
          GestureDetector(
              onTap: () => openForScore(i),
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    Text("$title ($user) - Score: $score"),
                    Image.network(url),
                    Text(
                      postTime,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )),
        );
        childWidgets.add(Divider(color: Colors.transparent));
        end of simple layout */

        /* beginning of complex layout */
        childWidgets.add(GestureDetector(
          onTap: () => openForScore(i),
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
                      Text(
                          postTime,
                          textAlign: TextAlign.right,
                          style: TextStyle(fontSize: 10.0)
                      ),
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
        ));
         /* end of complex layout */
      }
    }

    return Scaffold(
      backgroundColor: Colors.white70,
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
                  decoration: InputDecoration(labelText: "Title"),
                  controller: TextEditingController(text: titleOfNewPost),
                  maxLines: 1,
                  keyboardType: TextInputType.text,
                  onChanged: (text) => titleOfNewPost = text,
                ),
                Divider(color: Colors.transparent),


                // if imgFile is not null, we put an Image widget here. Otherwise, we put an empty container.
                imgFileOfNewPost != null
                    ? Image.file(imgFileOfNewPost, height: 200)
                    : Container(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.photo_camera),
                      onPressed: () => takePhoto(),
                    ),
                    IconButton(
                      icon: Icon(Icons.photo_library),
                      onPressed: () => getPhotoFromGallery(),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () => uploadData(),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  /* take a photo using camera */
  takePhoto() {
    // require setting changes in /ios/Runner/Info.plist
    ImagePicker.pickImage(source: ImageSource.camera).then((file) {
      imgFileOfNewPost = file; // store the photo data in variable imgFile
      setState(() {});
    });
  }

  /* get a photo from Photo Gallery */
  getPhotoFromGallery() {
    // require setting changes in /ios/Runner/Info.plist
    ImagePicker.pickImage(source: ImageSource.gallery).then((file) {
      imgFileOfNewPost = file; // store the photo data in variable imgFile
      setState(() {});
    });
  }

  uploadData() {
    // upload data to Firebase
    if (titleOfNewPost.trim().length == 0 || imgFileOfNewPost == null)
      return; // do nothing if the data are not ready.

    String myTitle = titleOfNewPost.trim();
    File myFile = imgFileOfNewPost;

    // clear the user inputs

    titleOfNewPost = "";
    imgFileOfNewPost = null;
    setState(() {});

    // reference to a new entry under FB database path "/photoShare"
    DatabaseReference dbNewEntry = dbRef.push();

    // reference to a new entry under FB storage path "/photoShare/{key}"
    StorageReference rfNewEntry = stRef.child("photoShare/${dbNewEntry.key}");

    /*rfNewEntry.putFile(myFile);*/
    rfNewEntry.putFile(myFile).onComplete.then((_) async {
      // upload photo to FB storage
      // when upload is completed...

      rfNewEntry.getDownloadURL().then((url){
        dbNewEntry.set({
          // set the values to the new entry of FB database
          "title": myTitle,
          "url": url,
          "post_time": DateTime.now().millisecondsSinceEpoch,
          "user": username,
          "score": 0,
        });
      });
    });

  }

  /* open a new screen to show the details of the scores of the selected PhotoShare post*/
  openForScore(int index) {
    selectedPostInfo = data[index];
    Navigator.pushNamed(context, "photoShare/score");
  }
}
