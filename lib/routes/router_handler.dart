import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:m_vcanbuy/main.dart';

// 跳转首页
var homeHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
      return MyApp();
    });
