import 'package:animated_login/animated_login.dart';
import 'package:flutter/material.dart';
import '../services/authentication_service.dart';

class LoginFunctions {

  const LoginFunctions(this.context);
  final BuildContext context;

  Future<String?> onLogin(LoginData loginData) async {
    return await AuthenticationService(context)
        .loginWithEmailAndPassword(loginData.email, loginData.password);
  }

  Future<String?> onSignup(SignUpData signupData) async {
    if (signupData.password != signupData.confirmPassword) {
      return 'Las contraseñas no coinciden';
    }
    return await AuthenticationService(context)
        .signUpWithEmailAndPassword(signupData.email, signupData.password);
  }

  Future<String?> socialLogin(String type) async {
    return 'Function no available';
    await Future.delayed(const Duration(seconds: 2));
    return null;
  }
}