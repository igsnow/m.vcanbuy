import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:m_vcanbuy/pages/splash_page.dart';
import 'package:m_vcanbuy/routes/routes.dart';
import 'package:m_vcanbuy/routes/application.dart';


void main() => runApp(new MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final router = Router();
    Routes.configureRoutes(router);
    Application.router = router;
    return MaterialApp(
      title: 'Vcanbuy',
      onGenerateRoute: Application.router.generator,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: SplashPage(),
    );  }
}
