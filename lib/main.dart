import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:poker_demo/pages/pages.dart';
import 'package:poker_demo/utils/utils.dart';

void main() {
  runApp(MyApp());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
    statusBarColor: Colors.transparent,
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final primary = Colors.blue;
    final accent = Color(0xffab5236);
    final text = TextStyle(
      fontFamily: 'Abaddon',
      fontSize: 24,
      color: Colors.white,
    );
    final textTheme = TextTheme(
      bodyText2: text,
      headline1: text.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      button: text.copyWith(
        fontSize: 24,
        color: Colors.white,
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: primary,
        accentColor: accent,
        textTheme: textTheme,
        dialogTheme: DialogTheme(
          titleTextStyle: textTheme.headline1,
          contentTextStyle: textTheme.bodyText2,
          shape: PixelShapeBorder(radius: 2, border: 1),
          backgroundColor: Color(0xff1d2b53),
        ),
        textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(
          splashFactory: NoSplash.splashFactory,
        )),
        scaffoldBackgroundColor: Color(0xff1d2b53),
      ),
      /// 像素风的路由过渡动画
      onGenerateRoute: (settings) => PageRouteBuilder(
        settings: settings,
        transitionDuration: Duration(milliseconds: 400),
        reverseTransitionDuration: Duration(milliseconds: 400),
        pageBuilder: (context, animation, secondaryAnimation) {
          switch (settings.name) {
            case '/': return HomePage();
            case '/game': return GamePage();
            default: return Scaffold(body: Center(child: Text('Page Not Found'),),);
          }
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final value = (animation.value * 8).floor() / 8;
          return Transform.translate(
            offset: Offset(0, (1 - value) * 80),
            child: Opacity(
              opacity: value,
              child: child,
            ),
          );
        },
      ),
    );
  }
}
