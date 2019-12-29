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
  String splashImg =
      "https://res.vcanbuy.com/misc/93b2c9fbb3401e66e29a345b5bff85bf.png";

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
    // 启动图加载完毕后加载广告闪图
    _initSplash();
  }

  _initSplash() {
    setState(() {
      _status = 1;
    });

    // 闪图倒计时
    _timer = Timer.periodic(new Duration(seconds: 1), (timer) {
      setState(() {
        if (_count <= 0) {
          // 倒计时结束后销毁定时器，表面内存泄漏
          _timer.cancel();
          _timer = null;
          _loadPage();
        } else {
          _count -= 1;
        }
      });
    });
  }

  // 加载引导图
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
                child: Opacity(
                  opacity: 0.0,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 35.0),
                    child: new Material(
                      child: new Ink(
                        child: new InkWell(
                            onTap: () {
                              _goMain();
                            },
                            child: Container(
                              alignment: Alignment(0, 0),
                              height: 80,
                              width: 300,
                            )),
                      ),
                    ),
                  ),
                )),
          ],
        ));
      } else {
        _bannerList.add(new Image.asset(
          _guideList[i],
          fit: BoxFit.fill,
          width: double.infinity,
          height: double.infinity,
        ));
      }
    }
  }

  // 判断跳转主页或者引导页
  void _loadPage() async {
    // 获取本地存储实例
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // 如果是第一次启动app，加载引导图
    bool isGuide = prefs.getBool(Constant.key_guide) ?? true;
    if (isGuide) {
      _initGuideBanner();
      prefs.setBool(Constant.key_guide, false);
    } else {
      // 如果不是第一次启动app，直接跳转首页
      _goMain();
    }
  }

  // 跳转到首页
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
    return new Image.network(
      splashImg,
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
              alignment: Alignment.topRight,
              margin: EdgeInsets.fromLTRB(0, 28.0, 20.0, 0),
              child: InkWell(
                onTap: () {
                  _loadPage();
                },
                child: new Container(
                    padding: EdgeInsets.all(5.0),
                    child: new Text(
                      '${_count}s skip',
                      style: new TextStyle(fontSize: 14.0, color: Colors.white),
                    ),
                    decoration: new BoxDecoration(
                        color: Color(0x66000000),
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        border: new Border.all(
                          width: 0.33,
                          color: Colors.grey,
                        ))),
              ),
            ),
          ),
          new Offstage(
            offstage: !(_status == 1),
            child: new Container(
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.only(bottom: 70),
              child: new Image.asset(
                Utils.getImgPath("logo"),
                width: 250,
                fit: BoxFit.fill,
              ),
            ),
          ),
          new Offstage(
            offstage: !(_status == 2),
            child: _bannerList.isEmpty
                ? new Container()
                : new Swiper(
                    autoStart: false,
                    circular: false,
                    children: _bannerList,
                  ),
          ),
        ],
      ),
    );
  }
}
