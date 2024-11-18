import 'package:animated_login/animated_login.dart';
import 'package:flutter/material.dart';
import 'package:safe_bite/src/services/authentication_service.dart';

class LoginFunctions {

  const LoginFunctions(this.context);
  final BuildContext context;

  Future<String?> onLogin(LoginData loginData) async {

    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    return null;
  }

  Future<String?> onSignup(SignUpData signupData) async {
    if (signupData.password != signupData.confirmPassword) {
      return 'The passwords you entered do not match, check again.';
    }

    final String? errorMessage = await AuthenticationService(context)
        .signUpWithEmailAndPassword(signupData.email, signupData.password);

    if (errorMessage != null) {
      return errorMessage;
    }

    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    return null;
  }

  Future<String?> socialLogin(String type) async {
    await Future.delayed(const Duration(seconds: 2));
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    return null;
  }
}