import 'package:dummy/Login/login.dart';
import 'package:flutter/material.dart';
import 'package:dummy/Login/RegisterPage.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({Key? key}) : super(key: key);

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool showLoginPage=true;
  void togglepages(){
    setState((){
      {
        showLoginPage=!showLoginPage;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    if(showLoginPage)
      {
        return LoginPage(onTap: togglepages);
      }
    else {
      return RegisterPage(onTap: togglepages,);
    }
  }
}
