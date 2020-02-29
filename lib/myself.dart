import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';

class MyselfScreen extends StatefulWidget{
  createState() {
    return MyselfState();
  }
}

class MyselfState extends State{

  var imgFileOfNewPost;
  String userInput = "text";
  String selectedDropdownItem = "Female";

  takePhoto() {
    ImagePicker.pickImage(source: ImageSource.camera).then((file) {
      imgFileOfNewPost = file;
      setState(() {});
    });
  }

  build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text("Information"),
        backgroundColor: Colors.greenAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save_alt),
            onPressed: () => Navigator.pushNamed(context, "cuper"),)],
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: <Widget>[
            Image.network("https://pics.me.me/ill-just-show-myself-out-mematic-net-buh-bye-37508885.png"),
            Divider(color: Colors.transparent, height: 5.0,),
            Icon(
              Icons.person,
              size: 100,
              color: Colors.black,
            ),
            IconButton(
              icon: Icon(Icons.camera_alt),
              iconSize: 30.0,
              color: Colors.blueGrey,
              onPressed: () => takePhoto(),
            ),

            Divider(color: Colors.transparent, height: 10.0,),

            Text("Input Your Name:",textAlign: TextAlign.center, style: TextStyle(fontFamily: "Oswald", fontSize: 17.0),),
            Divider( height: 20.0,),
            TextField(
              decoration: InputDecoration.collapsed(hintText: "Name"),
              keyboardType: TextInputType.text,
              maxLines: 1,
              textAlign: TextAlign.center,
              onChanged: (text) {
                setState(() {
                  userInput = text;
                  print(text);
                });
              },
            ),

            Divider( height: 20.0,),
            Text("Select your gender:",textAlign: TextAlign.center, style: TextStyle(fontFamily: "Oswald", fontSize: 17.0),),
            Divider( height: 5.0,),
            DropdownButton(
              value: selectedDropdownItem,
              items: <DropdownMenuItem>[
                DropdownMenuItem(value: "Female", child: Text("Female")),
                DropdownMenuItem(value: "Male", child: Text("Male")),
              ],
              onChanged: (result) {
                setState(() {
                  selectedDropdownItem = result;
                });
              },
            ),

              Card(
                  color: Colors.grey,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      maxLines: 6,
                      decoration: InputDecoration.collapsed(hintText: "Describe Yourself"),
                      onChanged: (text) {
                        setState(() {
                          userInput = text;
                          print(text);
                        });
                      },
                    ),
                  )
              )





          ],
        ),
      ),
    );
  }

}