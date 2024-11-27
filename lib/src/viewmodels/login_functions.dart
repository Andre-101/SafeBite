import 'package:animated_login/animated_login.dart';
import 'package:flutter/material.dart';

import '../services/authentication_service.dart';

class LoginFunctions {

  const LoginFunctions(this.context);
  final BuildContext context;

  Future<String?> onLogin(LoginData loginData) async {

    final String? errorMessage = await AuthenticationService(context)
        .loginWithEmailAndPassword(loginData.email, loginData.password);

    if (errorMessage != null) {
      return errorMessage;
    }

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
    var res;
    if(type == 'Google'){
      res =  await AuthenticationService(context).signInWithGoogle();
    }else if(type == 'Facebook'){
      res = await AuthenticationService(context).signInWithFacebook();
    }

    if (res != null) {
      return res;
    }

    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);

    return null;
  }
}