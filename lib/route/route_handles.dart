import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:m_vcanbuy/widgets/browser.dart';

// 跳转到主页
var homeHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
  return Browser(
    url: "http:m.vcanbuy.com",
  );
});
