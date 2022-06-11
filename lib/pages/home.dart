import 'package:flutter/material.dart';
import 'package:poker_demo/widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 320,
              height: 64,
              child: ButtonWidget('Start Game', startGame),
            ),
            SizedBox(height: 8,),
            SizedBox(
              width: 320,
              height: 64,
              child: ButtonWidget('How to Play?', showHowToPlay),
            ),
          ],
        ),
      ),
    );
  }

  /// 开始游戏
  startGame () {
    Navigator.pushNamed(context, '/game');
  }

  /// 游戏简介
  showHowToPlay () {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('How To Play'),
        content: SizedBox(
          width: 480,
          child: Text('Play calc, this game is the four numbers specified by the add, subtract, multiply and divide method to get 24. Is to find a way to manipulate four integers so that the end result is 24.'),
        ),
      ),
    );
  }
}
