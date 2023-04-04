import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int _pageState = 0;

  var _backgourndColor = Colors.white;
  var _headingColor = Color(0xFFB306060);

  double _headingTop = 100;

  double windowHeight = 0;
  double windowWidth = 0;

  double _loginWidth = 0;

  double _loginYOffset = 0;
  double _registerYOffset = 0;
  double _loginXOffset = 0;

  double _loginOpacity = 1;

  @override
  Widget build(BuildContext context) {
    windowHeight = MediaQuery.of(context).size.height;
    windowWidth = MediaQuery.of(context).size.width;

    switch (_pageState) {
      case 0:
        _backgourndColor = Colors.white;
        _headingColor = Color(0xFFB306060);

        _headingTop = 100;

        _loginWidth = windowWidth;
        _loginOpacity = 1;

        _loginYOffset = windowHeight;
        _registerYOffset = windowHeight;
        _loginXOffset = 0;
        break;
      case 1:
        _backgourndColor = Color(0xFFB306060);
        _headingColor = Colors.white;

        _headingTop = 90;

        _loginWidth = windowWidth;
        _loginOpacity = 1;

        _loginYOffset = 270;
        _registerYOffset = windowHeight;
        _loginXOffset = 0;
        break;
      case 2:
        _backgourndColor = Color(0xFFB306060);
        _headingColor = Colors.white;

        _headingTop = 80;

        _loginWidth = windowWidth - 40;
        _loginOpacity = 0.7;

        _loginYOffset = 250;
        _registerYOffset = 270;
        _loginXOffset = 20;
        break;
    }
    return Stack(
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 1000),
          curve: Curves.fastLinearToSlowEaseIn,
          color: _backgourndColor,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _pageState = 0;
                    });
                  },
                  child: Container(
                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration: Duration(milliseconds: 1000),
                          curve: Curves.fastLinearToSlowEaseIn,
                          margin: EdgeInsets.only(top: _headingTop),
                          child: Text(
                            "Make A New Friend!",
                            style: TextStyle(
                              fontSize: 28,
                              color: _headingColor,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 32),
                          margin: EdgeInsets.all(20),
                          child: Text(
                            "Pets have so much love to give and the won't ever stop giving it to you once you let htem into your heart.",
                            style: TextStyle(
                              fontSize: 16,
                              color: _headingColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: Center(
                    child: Image.asset("images/Pets.png"),
                  ),
                ),
                Container(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_pageState != 0) {
                          _pageState = 0;
                        } else {
                          _pageState = 1;
                        }
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          top: 32, bottom: 100, left: 32, right: 32),
                      padding: EdgeInsets.all(20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Color(0xFFB306060),
                          borderRadius: BorderRadius.circular(50)),
                      child: Center(
                        child: Text(
                          "Get Started!",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                )
              ]),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              _pageState = 2;
            });
          },
          child: AnimatedContainer(
            width: _loginWidth,
            duration: Duration(milliseconds: 1000),
            curve: Curves.fastLinearToSlowEaseIn,
            transform:
                Matrix4.translationValues(_loginXOffset, _loginYOffset, 1),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(_loginOpacity),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              _pageState = 1;
            });
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 1000),
            curve: Curves.fastLinearToSlowEaseIn,
            transform: Matrix4.translationValues(0, _registerYOffset, 1),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
