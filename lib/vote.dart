import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Vote extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return VoteState();
  }
}

class VoteState extends State<Vote> {
  String Value = '';

  Widget _vote(Map map) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          map["title"],
          style: TextStyle(fontSize: 20.0, color: Colors.blueAccent),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
        ),
        Divider(height: 1.0, indent: 0.0, color: Colors.grey),
        Column(
            children: (map["voteChild"] as List)
                .map((value) => RadioListTile(
                      groupValue: Value,
                      onChanged: (value) {
                        setState(() {
                          Value = value;
                        });
                      },
                      value: value["content"],
                      title: Row(
                        children: <Widget>[
                          Expanded(child: Container()),
                          Text(
                            value["content"],
                            style: TextStyle(fontSize: 16.0),
                          )
                        ],
                      ),
                    ))
                .toList()),
        Divider(height: 1.0, indent: 0.0, color: Colors.grey),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.send),
                //投票更新数据
                onPressed: () {
                  update(map, Value);
                }),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map map = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
          title: Text('VOTE'),
          leading: Builder(builder: (context) {
            return Text("");
          }),
          centerTitle: true,
          actions: <Widget>[
            Center(
                child: FlatButton(
              child: Text(
                "Discard",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )),
          ]),
      //页面渲染
      body: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: _vote(map),
        ),
      ),
    );
  }

  // update vote data
  update(Map vote, String voteS) {
    //如果没投票返回
    if (voteS.length <= 0) {
      return;
    }
    //根据id更新数据库该投票项数据
    DatabaseReference rootDbRef = FirebaseDatabase.instance.reference();
    DatabaseReference usersDbRef = rootDbRef.child("easyvote/" + vote["key"]);
    usersDbRef.push().once().then((onValue) => {
          //更新完返回
          Navigator.pop(context)
        });
//更新数据
    usersDbRef.update({
      "all": vote["all"] + 1,
      "voteChild": vote["voteChild"]
          .map(
            (value) => {
              "content": value["content"],
              "votes": value["content"] == voteS
                  ? value["votes"] + 1
                  : value["votes"],
            },
          )
          .toList()
    });
  }
}
