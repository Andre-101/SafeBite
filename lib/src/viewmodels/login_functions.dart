import 'package:animated_login/animated_login.dart';
import 'package:flutter/material.dart';

class LoginFunctions {

  const LoginFunctions(this.context);
  final BuildContext context;

  Future<String?> onLogin(LoginData loginData) async {
    await Future.delayed(const Duration(seconds: 2));
    return null;
  }

  Future<String?> onSignup(SignUpData signupData) async {
    if (signupData.password != signupData.confirmPassword) {
      return 'The passwords you entered do not match, check again.';
    }
    await Future.delayed(const Duration(seconds: 2));
    return null;
  }

  Future<String?> socialLogin(String type) async {
    await Future.delayed(const Duration(seconds: 2));
    return null;
  }
}