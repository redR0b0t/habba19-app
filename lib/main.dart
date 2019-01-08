import 'package:flutter/material.dart';
import 'package:habba2019/screens/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habba 2019',
      theme: new ThemeData(
        textSelectionColor: Colors.grey,
        textSelectionHandleColor: Colors.black38,
        cursorColor: Colors.black45,
        primarySwatch: Colors.grey,
        fontFamily: 'ProductSans',
        primaryColor: Colors.grey,
      ),
      home: HomeScreen(),
    );
  }
}

