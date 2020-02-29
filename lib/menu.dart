import 'package:flutter/material.dart';
import 'home.dart';

class MenuScreen extends StatefulWidget {
  createState() => MenuState();
}

class MenuState extends State {
  var features = [
    [
      "PHOTO SHARE",
      "photoShare",
      "https://www.comp.hkbu.edu.hk/~mandel/comp7510/images/photos.jpg"
    ],
    [
      "FORUM",
      "forum",
      "https://www.comp.hkbu.edu.hk/~mandel/comp7510/images/forum.jpg"
    ],
    [
      "EASY VOTE",
      "vote",
      "https://www.comp.hkbu.edu.hk/~mandel/comp7510/images/vote.jpg"
    ],
    [
      "MESSAGES",
      "message",
      "https://www.comp.hkbu.edu.hk/~mandel/comp7510/images/messages.jpg"
    ],
    [
      "PRODUCT",
      "other",
      "https://www.comp.hkbu.edu.hk/~mandel/comp7510/images/codes.jpg"
    ],
  ];

  createButton(BuildContext context, String title, String route, String url) {
    return GestureDetector(
      child: Container(
        height: 100.0,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10.0),
          image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
        ),
        padding: EdgeInsets.only(right: 10.0),
        child: Text(
          title,
          textAlign: TextAlign.right,
          style: TextStyle(
            fontSize: 30.0,
            fontFamily: "Oswald",
            color: Colors.white,
            shadows: [
              Shadow(
                  color: Colors.blue,
                  blurRadius: 10.0,
                  offset: Offset(-3, -3)),
              Shadow(
                  color: Colors.red,
                  blurRadius: 10.0,
                  offset: Offset(3, 3)),
            ],
          ),
        ),
      ),
      onTap: () => Navigator.pushNamed(context, route),
    );
  }

  build(BuildContext context) {
    var children = <Widget>[];

    features.forEach((f) {
      children.add(createButton(context, f[0], f[1], f[2]));
      children.add(Divider(color: Colors.transparent));
    });

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 96, 96, 96),
      appBar: AppBar(
        automaticallyImplyLeading: false, // remove leading
        title:
            Text("REACH", style: TextStyle(fontFamily: "Oswald", fontSize: 30)),
        actions: <Widget>[
          Center(child: Text(username)),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(10.0),
        children: children,
      ),
    );
  }
}
