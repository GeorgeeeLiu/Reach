import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class easyVote extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return easyVoteState();
  }
}

class easyVoteState extends State<easyVote> {
  //投票控件列表
  List<Widget> widgetList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text('EASY VOTE'),
        centerTitle: true,
        leading: Builder(builder: (context) {
          return IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              });
        }),
        actions: <Widget>[
          //跳转按钮
          IconButton(
              icon: Icon(Icons.add, color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(context, "NewVote");
              })
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(6.0),
        children: widgetList,
      ),
    );
  }

  getVote() {
    //获取数据库实列
    var dbRef = FirebaseDatabase.instance.reference().child("easyvote");
    dbRef.once().then((snapshot) {
      //数据加载完监听
      List<Map> sortedUsers = sort(snapshot.value, "time", false);
      List<Widget> widgetList = [];
      //循环投票项目列表，渲染条目
      for (int i = 0; i < sortedUsers.length; i++) {
        var data = sortedUsers[i];
        List voteChild = data['voteChild'];

        List<Widget> item = [];
        for (int j = 0; j < voteChild.length; j++) {
          var child = voteChild[j];
          item.add(Container(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(child["content"]),
                Container(
                  margin: EdgeInsets.fromLTRB(30, 0, 0, 0),
                  child: Text(
                      data['all'] == 0
                          ? "0%"
                          : (child["votes"] / data['all'] * 100)
                                  .toStringAsFixed(1) +
                              "%",
                      style: TextStyle(color: Colors.red)),
                )
              ],
            ),
          ));
        }
        widgetList.add(GestureDetector(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(6.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      data['title'],
                      style:
                          TextStyle(fontSize: 22.0, color: Colors.blueAccent),
                    ),
                  ),
                  Divider(height: 0.6, indent: 0.0, color: Colors.blueGrey),
                  Column(
                    children: item,
                  ),
                  Padding(padding: EdgeInsets.only(top: 10)),
                  Row(
                    children: <Widget>[
                      Icon(Icons.face, size: 16),
                      Text(data['all'].toString()),
                      Expanded(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Icon(
                            Icons.person_outline,
                            size: 16,
                          ),
                          Text(
                            data['name'],
                            textAlign: TextAlign.right,
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Icon(Icons.access_time, size: 16),
                          ),
                          Text(
                            parseTime(data['time']),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      )),
                    ],
                  )
                ],
              ),
            ),
          ),
          onTap: () => {
//跳转投票页面
            Navigator.pushNamed(context, "voteIt", arguments: data)
          },
        ));
      }
      //刷新数据
      setState(() {
        this.widgetList = widgetList;
      });
    });
  }

  @override
  void deactivate() {
    //获取投票数据
    getVote();
  }

  @override
  void initState() {
    super.initState();
    //获取投票数据
    getVote();
  }
}

//格式化时间
parseTime(time) {
  var date = DateTime.fromMillisecondsSinceEpoch(time);
  String timestamp =
      "${date.year}/${date.month}/${date.day} ${date.hour}:${date.minute}";
  return timestamp;
}

//排序
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
