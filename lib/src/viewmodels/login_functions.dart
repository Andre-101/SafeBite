import 'package:animated_login/animated_login.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD

=======
>>>>>>> isaac
import '../services/authentication_service.dart';

class LoginFunctions {

  const LoginFunctions(this.context);
  final BuildContext context;

  Future<String?> onLogin(LoginData loginData) async {
<<<<<<< HEAD

    final String? errorMessage = await AuthenticationService(context)
        .loginWithEmailAndPassword(loginData.email, loginData.password);

    if (errorMessage != null) {
      return errorMessage;
    }

    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    return null;
=======
    return await AuthenticationService(context)
        .loginWithEmailAndPassword(loginData.email, loginData.password);
>>>>>>> isaac
  }

  Future<String?> onSignup(SignUpData signupData) async {
    if (signupData.password != signupData.confirmPassword) {
<<<<<<< HEAD
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
    return 'Function no available';
    /*
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    return null; */
=======
      return 'Las contraseñas no coinciden';
    }
    return await AuthenticationService(context)
        .signUpWithEmailAndPassword(signupData.email, signupData.password);
  }

  Future<String?> socialLogin(String type) async {
    return 'Function no available';
    await Future.delayed(const Duration(seconds: 2));
    return null;
>>>>>>> isaac
  }
}