import 'package:flutter/material.dart';

String username = "";

List<Map> sort(dynamic json, String orderBy, bool asc) {
  var list = <Map>[];
  var map = json as Map;
  if (map != null)
    map.forEach((k, v) {
      var value = v as Map;
      value["key"] = k;
      list.add(value);
    });

  list.sort((a, b) => (a[orderBy] - b[orderBy]) * (asc ? 1 : -1));

  return list;
}

class HomeScreen extends StatefulWidget {
  createState() => HomeState();
}

class HomeState extends State {
  build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "REACH",
                style: TextStyle(
                  fontFamily: "Oswald",
                  fontSize: 100,
                ),
              ),
              Text(
                "University, Teachers, Classmates, and Group Mates",
                style: TextStyle(
                  fontFamily: "Times New Roman",
                  fontSize: 16,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50.0, left:50.0, right:50.0, bottom: 20.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Your name here",
                    icon: Icon(Icons.perm_identity),
                  ),
                  textAlign: TextAlign.center,
                  onChanged: (text) => username = text,
                ),
              ),
              FlatButton(
                child: Column(
                  children: <Widget>[
                    Icon(Icons.fingerprint, size: 64,),
                    Text("Sign In", style: TextStyle(fontFamily: "Oswald"),),
                  ],
                ),
                onPressed: () {
                  if (username.length > 0) Navigator.pushNamed(context, "menu");
                },
              ),
            ],
          ),
        ));
  }
}
