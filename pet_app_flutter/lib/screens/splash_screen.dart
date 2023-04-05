import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:pet_app/drawer/hidden_drawer.dart';

import '../utils/helpers/shared_pref_helper.dart';
import '../utils/services/auth.dart';
import '../utils/services/database.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  TextEditingController _emailController;
  TextEditingController _passwordController;

  int _pageState = 0;

  var _backgourndColor = Colors.white;
  var _headingColor = Color(0xFFB306060);

  double _headingTop = 100;

  double windowHeight = 0;
  double windowWidth = 0;

  double _loginWidth = 0;
  double _loginHeight = 0;

  double _loginYOffset = 0;
  double _registerYOffset = 0;
  double _registerHeight = 0;
  double _loginXOffset = 0;

  double _loginOpacity = 1;

  bool _keyboardVisible = false;

  bool isLoading = false;

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  SharedPrefHelper sharedPrefHelper = new SharedPrefHelper();
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        setState(() {
          _keyboardVisible = visible;
        });
      },
    );
  }

  void signUpUser() {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      authMethods.SignUpWithEmailAndPassword(
              _emailController.text, _passwordController.text)
          .then((val) {
        if (val != null) {
          Map<String, String> userInfoMap = {
            'email': _emailController.text,
          };

          databaseMethods.uploadUserInfo(userInfoMap);
          sharedPrefHelper.saveUserEmailSharedPref(_emailController.text);
          sharedPrefHelper.saveUserLoggedInSharedPref(true);

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => SplashScreen()));
        } else {
          setState(() {
            isLoading = false;
          });
          SnackBar snackBar = SnackBar(
            content: Text('Email already exists!',
                style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.red,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    windowHeight = MediaQuery.of(context).size.height;
    windowWidth = MediaQuery.of(context).size.width;

    _loginHeight = windowHeight - 270;
    _registerHeight = windowHeight - 270;

    switch (_pageState) {
      case 0:
        _backgourndColor = Colors.white;
        _headingColor = Color(0xFFB306060);

        _headingTop = 100;

        _loginWidth = windowWidth;
        _loginOpacity = 1;

        _loginYOffset = windowHeight;
        _loginHeight = _keyboardVisible ? windowHeight : windowHeight - 270;

        _registerYOffset = windowHeight;
        _loginXOffset = 0;
        break;
      case 1:
        _backgourndColor = Color(0xFFB306060);
        _headingColor = Colors.white;

        _headingTop = 90;

        _loginWidth = windowWidth;
        _loginOpacity = 1;

        _loginYOffset = _keyboardVisible ? 40 : 270;
        _loginHeight = _keyboardVisible ? windowHeight : windowHeight - 270;

        _registerYOffset = windowHeight;
        _loginXOffset = 0;
        break;
      case 2:
        _backgourndColor = Color(0xFFB306060);
        _headingColor = Colors.white;

        _headingTop = 80;

        _loginWidth = windowWidth - 40;
        _loginOpacity = 0.7;

        _loginYOffset = _keyboardVisible ? 40 : 240;
        _loginHeight = _keyboardVisible ? windowHeight : windowHeight - 240;
        _registerHeight = _keyboardVisible ? windowHeight : windowHeight - 270;

        _registerYOffset = _keyboardVisible ? 50 : 270;
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
                            "Pets have so much love to give and the won't ever stop giving it to you once you let them into your heart.",
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
        AnimatedContainer(
          padding: EdgeInsets.all(32),
          height: _loginHeight,
          width: _loginWidth,
          duration: Duration(milliseconds: 1000),
          curve: Curves.fastLinearToSlowEaseIn,
          transform: Matrix4.translationValues(_loginXOffset, _loginYOffset, 1),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(_loginOpacity),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: Text(
                      "Login To Continue",
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFFB306060),
                      ),
                    ),
                  ),
                  InputWithIcon(
                    icon: Icons.email,
                    hint: "Enter Email...",
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InputWithIcon(
                    icon: Icons.vpn_key,
                    hint: "Enter Password...",
                  ),
                ],
              ),
              Column(
                children: [
                  PrimaryButton(
                    buttonText: "Login",
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _pageState = 2;
                      });
                    },
                    child: OutlineButton(
                      buttonText: "Create New Account",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        AnimatedContainer(
          height: _registerHeight,
          padding: EdgeInsets.all(32),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Form(
                key: formKey,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Text(
                        "Create New Account",
                        style: TextStyle(
                          fontSize: 20,
                          color: Color(0xFFB306060),
                        ),
                      ),
                    ),
                    InputWithIcon(
                      icon: Icons.email,
                      hint: "Enter Email...",
                      validator: (value) {
                        return RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value)
                            ? null
                            : "Enter correct email";
                      },
                      controller: _emailController,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InputWithIcon(
                      icon: Icons.vpn_key,
                      hint: "Enter Password...",
                      validator: (value) {
                        return value.length < 6 ? "Password too small" : null;
                      },
                      controller: _passwordController,
                    ),
                  ],
                ),
              ),
              Column(children: [
                PrimaryButton(
                  buttonText: "Create Account",
                  press: signUpUser,
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _pageState = 1;
                    });
                  },
                  child: OutlineButton(
                    buttonText: "Back to Login",
                  ),
                ),
              ]),
            ],
          ),
        ),
      ],
    );
  }
}

class InputWithIcon extends StatefulWidget {
  final Function validator;
  final TextEditingController controller;
  final IconData icon;
  final String hint;
  InputWithIcon({this.icon, this.hint, this.controller, this.validator});

  @override
  State<InputWithIcon> createState() => _InputWithIconState();
}

class _InputWithIconState extends State<InputWithIcon> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFFBB9B9B9), width: 2),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            child: Icon(
              widget.icon,
              size: 20,
              color: Color(0xFFBB9B9B9),
            ),
          ),
          Expanded(
            child: TextFormField(
              validator: widget.validator,
              controller: widget.controller,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 20),
                border: InputBorder.none,
                hintText: widget.hint,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PrimaryButton extends StatefulWidget {
  final String buttonText;
  final Function press;
  PrimaryButton({this.buttonText, this.press});

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.press,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFB306060),
          borderRadius: BorderRadius.circular(50),
        ),
        padding: EdgeInsets.all(20),
        child: Center(
          child: Text(
            widget.buttonText,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

class OutlineButton extends StatefulWidget {
  final String buttonText;
  OutlineButton({this.buttonText});

  @override
  State<OutlineButton> createState() => _OutlineButtonState();
}

class _OutlineButtonState extends State<OutlineButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Color(0xFFB306060),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(50),
      ),
      padding: EdgeInsets.all(20),
      child: Center(
        child: Text(
          widget.buttonText,
          style: TextStyle(
            color: Color(0xFFB306060),
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
