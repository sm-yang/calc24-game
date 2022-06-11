import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:poker_demo/utils/utils.dart';
import 'package:poker_demo/widgets/widgets.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  ThemeData get theme => Theme.of(context);
  TextTheme get text => theme.textTheme;
  /// 扑克牌的四种花色
  static final List<String> types = ['diamond', 'club', 'heart', 'spade'];
  /// 运算符号
  static final operators = ['(', ')', '+', '-', '*', '/'];

  final numbers = <int>[];
  late final String solution;
  final images = <Image>[
    Image.asset('assets/images/back_black.png'),
  ];

  late Timer timer;
  final stepVN = ValueNotifier(0);
  final timeVN = ValueNotifier(0);
  final answerVN = ValueNotifier(<String>[]);
  String get answerStr => answerVN.value.map((item) {
    final index = int.tryParse(item);
    return index == null ? item : numbers[index];
  }).join();

  @override
  void initState() {
    super.initState();
    /// 数字生成 & 图片加载完成后，以500ms的速度逐张揭牌，揭开所有牌后开始计时器
    init().then((_) async {
      for (stepVN.value = 0; stepVN.value < 4; stepVN.value ++)
        await Future.delayed(Duration(milliseconds: 500));
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        timeVN.value ++;
      });
    });
  }

  Future init () async {
    /// 随机生成四个数字，并确保这些数字有解
    while (true) {
      numbers.clear();
      for (var i = 0; i < 4; i ++) numbers.add(Random().nextInt(9) + 1);
      final res = Calc24Util.getSolution(numbers);
      if (res.isNotEmpty) {
        solution = res;
        break;
      }
    }
    /// 加载图片
    await Future.delayed(Duration.zero);
    precacheImage(images.first.image, context);
    types.shuffle();
    for (var i = 0; i < 4; i ++) {
      images.insert(i, Image.asset('assets/images/${numbers[i]}_${types[i]}.png'));
      precacheImage(images[i].image, context);
    }
  }

  @override
  void dispose() {
    if (stepVN.value == 3) timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ///
            /// 计时器（以秒为单位）
            ///
            ValueListenableBuilder<int>(
              valueListenable: timeVN,
              builder: (context, time, child) => Text('Time: ${time}s',),
            ),
            SizedBox(height: 32,),
            ///
            /// 生成的数字，每张只能用一次
            ///
            ValueListenableBuilder<int>(
              valueListenable: stepVN,
              builder: (context, step, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var i = 0; i < 4; i ++) Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: i >= step ? images.last : ValueListenableBuilder<List<String>>(
                        valueListenable: answerVN,
                        builder: (context, answer, child) {
                          final index = i.toString();
                          return Opacity(
                            opacity: answer.contains(index) ? 0.5 : 1,
                            child: GestureDetector(
                              onTap: () => addNumber(index),
                              child: images[i],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 32,),
            ///
            /// 玩家的表达式
            ///
            Text('Your answer'),
            ValueListenableBuilder<List<String>>(
              valueListenable: answerVN,
              builder: (context, answer, child) => Text(answerStr, style: text.headline1!.copyWith(
                letterSpacing: 8,
              ),),
            ),
            SizedBox(height: 16,),
            ///
            /// 运算符按钮区
            ///
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 8,),
                for (var i = 0, len = operators.length; i < len; i ++) Container(
                  width: 64,
                  height: 48,
                  margin: EdgeInsets.only(right: i % 2 == 1 ? 16 : 4),
                  child: ButtonWidget(operators[i], () => addOperator(operators[i])),
                ),
                /// 删除按钮，只有玩家答案不为空时才可按下
                ValueListenableBuilder<List<String>>(
                  valueListenable: answerVN,
                  builder: (context, answer, child) => Container(
                    width: 64,
                    height: 48,
                    margin: EdgeInsets.only(right: 4),
                    child: ButtonWidget('DEL', delete, disabled: answer.isEmpty,),
                  ),
                ),
                /// 判断按钮，只有所有数字都用上了才可按下
                ValueListenableBuilder<List<String>>(
                  valueListenable: answerVN,
                  builder: (context, answer, child) => Container(
                    width: 64,
                    height: 48,
                    margin: EdgeInsets.only(right: 4),
                    child: ButtonWidget('OK', checkAnswer, disabled: (() {
                      /// 判断玩家的答案中是否包含了四个数字
                      for (var i = 0, len = numbers.length; i < len; i ++)
                        if (!answer.contains(i.toString())) return true;
                      return false;
                    })(),),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 玩家点击扑克牌添加数字，加到答案最后
  addNumber (final String index) {
    if (!answerVN.value.contains(index))
      answerVN..value.add(index)..notifyListeners();
  }

  /// 玩家点击运算符加入到答案最后
  addOperator (final String operator) {
    if (!timer.isActive) return;
    answerVN..value.add(operator)..notifyListeners();
  }

  /// 删除按钮点击事件，删除玩家答案的最后一位
  delete () {
    if (!timer.isActive) return;
    answerVN..value.removeLast()..notifyListeners();
  }

  /// 检查玩家答案是否正确
  checkAnswer () {
    if (!timer.isActive) return;
    try {
      final result = Calc24Util.computeStr(answerStr);
      if (result == 24) win();
      else lose('$answerStr = $result');
    } catch (e) {
      lose('Your answer cannot be compute.');
    }
  }

  /// 游戏胜利，停止计时器
  win () {
    timer.cancel();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('You win!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.popUntil(context, ModalRoute.withName('/')),
            child: Text('Back'),
          ),
        ],
      ),
    );
  }

  /// 玩家答案不正确，弹框提示答案错误
  lose (final String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
      ),
    );
  }
}
