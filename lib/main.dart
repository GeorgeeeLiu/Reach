import 'package:flutter/material.dart';
import 'home.dart';
import 'menu.dart';
import 'photoShare.dart';
import 'unavailable.dart';
import 'productShare.dart';
import 'release.dart';
import 'myself.dart';
import 'cuper.dart';
import 'forum.dart';
import 'forumreply.dart';
import 'message.dart';
import 'messageCompose.dart';
import 'messageDetail.dart';
import 'vote.dart';
import 'newvote.dart';
import 'easyVote.dart';


void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(color: Color.fromARGB(255, 32, 52, 112)),
      ),
      home: HomeScreen(),
      routes: <String, WidgetBuilder>{
        "menu": (context) => MenuScreen(),
        "photoShare": (context) => PhotoShareScreen(),
        "photoShare/score": (context) => UnavailableScreen(),
        "forum": (context) => ForumScreen(),

        "message":(context) => MessageInboxScreen(),
        "message/compose":(context)=>MessageComposeScreen(),
        "message/detail":(context)=>MessageDetailScreen(),
        "message/sent":(context) => MessageSentScreen(),
        "other":(context) => ProductShareScreen(),
        "release":(context) => ReleaseScreen(),
        "myself":(context) => MyselfScreen(),
        "cuper":(context) => CuperScreen(),
        "forumreply":(context)=>ForumreplyScreen(),
        "vote":(context) => easyVote(),
        "NewVote":(context) => newVote(),
        "voteIt":(context) => Vote(),



      },
    );
  }
}


