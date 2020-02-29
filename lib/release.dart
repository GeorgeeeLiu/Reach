import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'home.dart';

Map selectedPostInfo;

class ReleaseScreen extends StatefulWidget {
  createState() => ReleaseState();
}


class ReleaseState extends State {
  DatabaseReference dbRef;
  StorageReference stRef;
  List<Map> data;


  String titleOfNewPost = "";
  String titleOfNewPost1 = "";
  File imgFileOfNewPost;

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

      }
    }

    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
          title: Text("RELEASE PRODUCT",
              style: TextStyle(fontFamily: "Oswald", fontSize: 20)),
        backgroundColor: Colors.pink,),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: childWidgets,
            ),
          ),
          Container(

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
                  decoration: InputDecoration(labelText: "Price"),
                  controller: TextEditingController(text: titleOfNewPost),
                  maxLines: 1,
                  keyboardType: TextInputType.text,
                  onChanged: (text) => titleOfNewPost = text,
                ),
                Divider(color: Colors.transparent),

                TextField(
                  decoration: InputDecoration(labelText: "Describe"),
                  controller: TextEditingController(text: titleOfNewPost1),
                  maxLines: 1,
                  keyboardType: TextInputType.text,
                  onChanged: (text) => titleOfNewPost1 = text,
                ),


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



  takePhoto() {
    ImagePicker.pickImage(source: ImageSource.camera).then((file) {
      imgFileOfNewPost = file; // store the photo data in variable imgFile
      setState(() {});
    });
  }


  getPhotoFromGallery() {
    ImagePicker.pickImage(source: ImageSource.gallery).then((file) {
      imgFileOfNewPost = file;
      setState(() {});
    });
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
