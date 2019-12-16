import 'package:flutter/material.dart';
import 'package:m_vcanbuy/widget/browser.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Vcanbuy App',
        theme: new ThemeData(
          primarySwatch: Colors.orange,
        ),
        home: new Browser(
//              url: "https://www.douyu.com",
//              url: "https://www.bilibili.com",
          url: "http://m.vcanbuy.com",
//          title: "百度",
        ));
  }
}
