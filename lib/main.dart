import 'package:flutter/material.dart';
import 'package:m_vcanbuy/widgets/browser.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vcanbuy',
      home: new Browser(
        url: "http://m.vcanbuy.com",
      ),
    );
  }
}
