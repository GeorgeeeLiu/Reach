import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'home.dart';

class newVote extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return newVoteState();
  }
}

class newVoteState extends State<newVote> {
  String title = '';
  String option1 = '';
  String option2 = '';
  String option3 = '';
  String option4 = '';

  save() {
    //获取数据库实列
    DatabaseReference rootDbRef = FirebaseDatabase.instance.reference();
    DatabaseReference usersDbRef = rootDbRef.child("easyvote");
    DatabaseReference newEntryRef = usersDbRef.push();
    usersDbRef.push().once().then((onValue) => {Navigator.pop(context)});
    //投票选项列表
    List voteChilds = [];
    //选项一不为空添加，下面类似
    if (option1.isNotEmpty) {
      voteChilds.add(option1);
    }
    if (option2.isNotEmpty) {
      voteChilds.add(option2);
    }
    if (option3.isNotEmpty) {
      voteChilds.add(option3);
    }
    if (option4.isNotEmpty) {
      voteChilds.add(option4);
    }
    if (voteChilds.length <= 1 || title.isEmpty) {
      return;
    }

    //往数据库添加数据
    newEntryRef.set({
      "time": DateTime.now().millisecondsSinceEpoch,
      "title": title,
      "name": username,
      "all": 0,
      "voteChild": voteChilds
          .map(
            (value) => {"content": value, "votes": 0},
          )
          .toList()
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('NEWVOTE'),
          centerTitle: true,
          leading: Builder(builder: (context) {
            return Text("");
          }),
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
      body: SingleChildScrollView(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: _vote(),
          ),
        ),
      ),
    );
  }

  Widget _vote() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TextField(
          autofocus: true,
          onChanged: (v) {
            this.title = v;
          },
          decoration: InputDecoration(
            hintText: "title",
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: TextField(
            autofocus: true,
            onChanged: (v) {
              this.option1 = v;
            },
            decoration: InputDecoration(
              hintText: "Option 1",
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: TextField(
            autofocus: true,
            onChanged: (v) {
              this.option2 = v;
            },
            decoration: InputDecoration(
              hintText: "Option 2",
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: TextField(
            autofocus: true,
            onChanged: (v) {
              this.option3 = v;
            },
            decoration: InputDecoration(
              hintText: "Option 3",
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: TextField(
            autofocus: true,
            onChanged: (v) {
              this.option4 = v;
            },
            decoration: InputDecoration(
              hintText: "Option 4",
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  //存到数据库
                  save();
                }),
          ],
        )
      ],
    );
  }
}
