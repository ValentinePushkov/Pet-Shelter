import 'package:flutter/material.dart';
import 'package:pet_app/constants/constants.dart';
import 'package:pet_app/screens/splash_screen.dart';
import 'package:pet_app/utils/services/auth.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _backgourndColor = Colors.white;
  final _headingColor = Color(0xFFB306060);
  final _forgetPasswordFormKey = GlobalKey<FormState>();
  final TextEditingController _forgotPassowrdController =
      TextEditingController();
  AuthMethods authMethods = AuthMethods();

  final double _headingTop = 100;

  void resetPasswordHandler() {
    if (_forgetPasswordFormKey.currentState.validate()) {
      try {
        authMethods.resetPassword(_forgotPassowrdController.text);
        SnackBar snackBar = SnackBar(
          duration: Duration(seconds: 1),
          content:
              Text('Письмо отправлено!', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.green,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Future.delayed(Duration(seconds: 1), () {
          Navigator.of(context).pop();
        });
      } catch (e) {
        SnackBar snackBar = SnackBar(
          content:
              Text('Some error occured', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      SnackBar snackBar = SnackBar(
        content: Text(
          'Введите корректный email!',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0),
      body: Stack(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 1000),
            curve: Curves.fastLinearToSlowEaseIn,
            color: _backgourndColor,
            child: Column(
              children: [
                Column(
                  children: [
                    AnimatedContainer(
                      duration: Duration(milliseconds: 1000),
                      curve: Curves.fastLinearToSlowEaseIn,
                      margin: EdgeInsets.only(top: _headingTop),
                      child: Text(
                        "Восстановить пароль",
                        style: TextStyle(
                          fontSize: 28,
                          color: _headingColor,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      margin: EdgeInsets.all(20),
                      child: Text(
                        "Введите адрес электронной почты, связанный с вашей учетной записью, и мы отправим электронное письмо с инструкциями по сбросу пароля.",
                        style: TextStyle(
                          fontSize: 16,
                          color: _headingColor,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Form(
                  key: _forgetPasswordFormKey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Email:",
                            style: TextStyle(
                              color: Constants.kPrimaryColor,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        InputWithIcon(
                          controller: _forgotPassowrdController,
                          icon: Icons.edit,
                          hint: "Email",
                          validator: (value) {
                            return RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                            ).hasMatch(value)
                                ? null
                                : "Введите корректный email";
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 28),
                  child: PrimaryButton(
                    buttonText: "Восстановить",
                    press: resetPasswordHandler,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
