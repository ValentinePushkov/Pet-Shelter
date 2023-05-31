import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pet_app/constants/constants.dart';
import 'package:pet_app/drawer/admin_hidden_drawer.dart';
import 'package:pet_app/drawer/hidden_drawer.dart';
import 'package:pet_app/models/user.dart';
import 'package:pet_app/screens/forget_password_screen.dart';

import 'package:pet_app/utils/helpers/shared_pref_helper.dart';
import 'package:pet_app/utils/services/auth.dart';
import 'package:pet_app/utils/services/database.dart';
import 'package:pet_app/utils/services/encryption.dart';
import 'package:pet_app/utils/services/local_database.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  TextEditingController _emailController;
  TextEditingController _passwordController;
  TextEditingController _repeatPasswordController;
  TextEditingController _loginEmailController;
  TextEditingController _loginPasswordController;
  TextEditingController _signupUserNameController;

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
  Encryption encrypter = new Encryption();
  final formKey = GlobalKey<FormState>();
  final loginFormKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");
    _repeatPasswordController = TextEditingController(text: "");
    _loginEmailController = TextEditingController(text: "");
    _loginPasswordController = TextEditingController(text: "");
    _signupUserNameController = TextEditingController(text: "");
    /*KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        setState(() {
          _keyboardVisible = visible;
        });
      },
    );*/
  }

  void signUpUser(LocalDatabase key, BuildContext context) {
    if (formKey.currentState.validate()) {
      if (_passwordController.text == _repeatPasswordController.text) {
        setState(() {
          isLoading = true;
        });

        authMethods
            .signUpWithEmailAndPassword(
          _emailController.text,
          _passwordController.text,
        )
            .then((val) async {
          if (val != null) {
            await encrypter.generateKeys();
            await key.addKey(
              _signupUserNameController.text,
              json.encode(encrypter.privateKeyJwk),
            );

            Map<String, dynamic> userInfoMap = {
              'username': _signupUserNameController.text,
              'email': _emailController.text,
              'publicKey': json.encode(encrypter.publicKeyJwk),
              'picUrl': null,
            };

            databaseMethods.uploadUserInfo(
              _signupUserNameController.text,
              userInfoMap,
            );
            sharedPrefHelper.saveUsernameSharedPref(_loginEmailController.text);
            sharedPrefHelper.saveUserEmailSharedPref(_emailController.text);
            sharedPrefHelper.saveUserLoggedInSharedPref(true);

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SplashScreen(),
              ),
            );
          } else {
            setState(() {
              isLoading = false;
            });
            SnackBar snackBar = SnackBar(
              content: Text(
                'Email уже существует',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        });
      } else {
        SnackBar snackBar = SnackBar(
          content: Text(
            'Пароли не совпадают',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  void route(String role) {
    if (role == 'Admin') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminHiddenDrawer()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HiddenDrawer()),
      );
    }
  }

  void loginUser() {
    if (loginFormKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      authMethods
          .loginWithEmailAndPassword(
        _loginEmailController.text,
        _loginPasswordController.text,
      )
          .then((val) async {
        if (val != null) {
          UserClass login = await databaseMethods
              .getUserInfoByEmail(_loginEmailController.text);
          sharedPrefHelper.saveUserEmailSharedPref(login.email);
          sharedPrefHelper.saveUsernameSharedPref(login.username);
          sharedPrefHelper.saveUserLoggedInSharedPref(true);

          route(login.role);
        } else {
          setState(() {
            isLoading = false;
          });
          SnackBar snackBar = SnackBar(
            content: Text(
              'Email or Password incorrect!',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var key = Provider.of<LocalDatabase>(context);
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

      case 3:
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
    }
    return Scaffold(
      key: scaffoldKey,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(
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
                        child: Column(
                          children: [
                            AnimatedContainer(
                              duration: Duration(milliseconds: 1000),
                              curve: Curves.fastLinearToSlowEaseIn,
                              margin: EdgeInsets.only(top: _headingTop),
                              child: Text(
                                "Заведи нового друга!",
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
                                "Домашние животные могут дарить так много любви, и они никогда не перестанут дарить ее вам, как только вы впустите их в свое сердце.",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: _headingColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Image.asset("images/Pets.png"),
                      ),
                      GestureDetector(
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
                            top: 32,
                            bottom: 100,
                            left: 32,
                            right: 32,
                          ),
                          padding: EdgeInsets.all(20),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Color(0xFFB306060),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                            child: Text(
                              "Начать!",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                AnimatedContainer(
                  padding: EdgeInsets.all(32),
                  height: _loginHeight,
                  width: _loginWidth,
                  duration: Duration(milliseconds: 1000),
                  curve: Curves.fastLinearToSlowEaseIn,
                  transform: Matrix4.translationValues(
                    _loginXOffset,
                    _loginYOffset,
                    1,
                  ),
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
                      Form(
                        key: loginFormKey,
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 20),
                              child: Text(
                                "Войдите для продолжения",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xFFB306060),
                                ),
                              ),
                            ),
                            InputWithIcon(
                              icon: Icons.email,
                              hint: "Email",
                              controller: _loginEmailController,
                              validator: (value) {
                                return RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                                ).hasMatch(value)
                                    ? null
                                    : "Введите корректный email";
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            InputWithIcon(
                              icon: Icons.vpn_key,
                              hint: "Пароль",
                              controller: _loginPasswordController,
                              validator: (value) {
                                return value.length < 6
                                    ? "Пароль слишком короткий"
                                    : null;
                              },
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          PrimaryButton(
                            buttonText: "Вход",
                            press: () => loginUser(),
                          ),
                          SizedBox(height: 20),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _pageState = 2;
                              });
                            },
                            child: OutlineButton(
                              buttonText: "Создать новый аккаунт",
                            ),
                          ),
                          SizedBox(height: 20),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ForgetPassword(),
                                  ),
                                );
                              });
                            },
                            child: Text(
                              "Забыли пароль?",
                              style: TextStyle(
                                color: Constants.kPrimaryColor,
                                fontSize: 16,
                              ),
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
                                "Создать новый аккаунт",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xFFB306060),
                                ),
                              ),
                            ),
                            InputWithIcon(
                              icon: Icons.email,
                              hint: "Email",
                              validator: (value) {
                                return RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                                ).hasMatch(value)
                                    ? null
                                    : "Введите корректный email";
                              },
                              controller: _emailController,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            InputWithIcon(
                              icon: Icons.supervised_user_circle,
                              hint: "Имя пользователя",
                              controller: _signupUserNameController,
                              validator: (value) {
                                return value.length < 2
                                    ? "Имя слишком короткое"
                                    : null;
                              },
                            ),
                            SizedBox(height: 20),
                            InputWithIcon(
                              icon: Icons.vpn_key,
                              hint: "Пароль",
                              validator: (value) {
                                return value.length < 6
                                    ? "Пароль слишком короткий"
                                    : null;
                              },
                              controller: _passwordController,
                            ),
                            SizedBox(height: 20),
                            InputWithIcon(
                              icon: Icons.vpn_key,
                              hint: "Повторите пароль",
                              validator: (value) {
                                return value.length < 6
                                    ? "Пароль слишком короткий"
                                    : null;
                              },
                              controller: _repeatPasswordController,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          PrimaryButton(
                            buttonText: "Создать аккаунт",
                            press: () => signUpUser(key, context),
                          ),
                          SizedBox(height: 20),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _pageState = 1;
                              });
                            },
                            child: OutlineButton(
                              buttonText: "Вернутся к Регистрации",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
        border: Border.all(color: Constants.kPrimaryColor, width: 2),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Icon(
              widget.icon,
              size: 20,
              color: Constants.kPrimaryColor,
            ),
          ),
          Expanded(
            child: TextFormField(
              minLines: 1,
              maxLines: 8,
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
