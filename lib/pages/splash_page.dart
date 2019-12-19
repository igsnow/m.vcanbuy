import 'dart:async';
import 'package:flukit/flukit.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:m_vcanbuy/common/common.dart';
import 'package:m_vcanbuy/route/routes.dart';
import 'package:m_vcanbuy/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../application.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new SplashPageState();
  }
}

class SplashPageState extends State<SplashPage> {
  List<String> _guideList = [
    Utils.getImgPath('guide1'),
    Utils.getImgPath('guide2'),
    Utils.getImgPath('guide3'),
    Utils.getImgPath('guide4'),
  ];

  List<Widget> _bannerList = new List();

  Timer _timer;

  int _status = 0; // 启动图类型 1.广告闪图 2.引导图
  int _count = 5; // 倒计时

  @override
  void initState() {
    super.initState();
    _initAsync();
  }

  void _initAsync() async {
    // 获取本地存储实例
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // 启动图加载完毕后加载广告闪图
    _initSplash(prefs);
  }

  _initSplash(prefs) {
    setState(() {
      _status = 1;
    });

    // 闪图倒计时
    _timer = Timer.periodic(new Duration(seconds: 1), (timer) {
      setState(() {
        if (_count <= 1) {
          _timer.cancel();
          _timer = null;
          // 如果是第一次启动app，闪图加载完毕后默认加载引导图
          bool isGuide = prefs.getBool(Constant.key_guide) ?? true;
          if (isGuide) {
            _initGuideBanner();
            prefs.setBool(Constant.key_guide, false);
          } else {
            _goMain();
          }
        } else {
          _count = _count - 1;
        }
      });
    });
  }

  _initGuideBanner() {
    setState(() {
      _status = 2;
    });
    for (int i = 0, length = _guideList.length; i < length; i++) {
      if (i == length - 1) {
        _bannerList.add(new Stack(
          children: <Widget>[
            new Image.asset(
              _guideList[i],
              fit: BoxFit.fill,
              width: double.infinity,
              height: double.infinity,
            ),
            new Align(
              alignment: Alignment.bottomCenter,
              child: new Container(
                margin: EdgeInsets.only(bottom: 65.0),
                child: new InkWell(
                  onTap: () {
                    _goMain();
                  },
                  child: new CircleAvatar(
                    radius: 40.0,
                    backgroundColor: Colors.orange,
                    child: new Padding(
                      padding: EdgeInsets.all(2.0),
                      child: new Text(
                        '立即体验',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
      } else {
        // print(_guideList[i]);
        _bannerList.add(new Image.asset(
          _guideList[i],
          fit: BoxFit.fill,
          width: double.infinity,
          height: double.infinity,
        ));
      }
    }
  }

  // 跳转主页
  void _goMain() {
    Application.router.navigateTo(
      context,
      Routes.home,
      replace: true,
      transition: TransitionType.fadeIn,
    );
  }

  // 构建闪图广告背景
  Widget _buildSplashBg() {
    return new Image.asset(
      Utils.getImgPath('splash_bg'),
      width: double.infinity,
      fit: BoxFit.fill,
      height: double.infinity,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      child: new Stack(
        children: <Widget>[
          new Offstage(
            offstage: !(_status == 1),
            child: _buildSplashBg(),
          ),
          new Offstage(
            offstage: !(_status == 1),
            child: new Container(
              alignment: Alignment.bottomRight,
              margin: EdgeInsets.all(20.0),
              child: InkWell(
                onTap: () {
                  _goMain();
                },
                child: new Container(
                    padding: EdgeInsets.all(12.0),
                    child: new Text(
                      '$_count 跳转',
                      style: new TextStyle(fontSize: 14.0, color: Colors.white),
                    ),
                    decoration: new BoxDecoration(
                        color: Color(0x66000000),
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        border:
                            new Border.all(width: 0.33, color: Colors.grey))),
              ),
            ),
          ),
          new Offstage(
            offstage: !(_status == 2),
            child: _bannerList.isEmpty
                ? new Container()
                : new Swiper(
                    autoStart: false, circular: false, children: _bannerList),
          ),
        ],
      ),
    );
  }
}
