import 'package:animated_login/animated_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/authentication_service.dart';
import '../services/user_service.dart';

class LoginFunctions {

  const LoginFunctions(this.context);
  final BuildContext context;

  Future<String?> onLogin(LoginData loginData) async {

    try {
      final credential = await AuthenticationService(context)
          .loginWithEmailAndPassword(loginData.email, loginData.password);

      buildUser(credential);
      
    } catch (e) {
      return e.toString();
    }
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    return null;
  }

  Future<String?> onSignup(SignUpData signupData) async {
    if (signupData.password != signupData.confirmPassword) {
      return 'The passwords you entered do not match, check again.';
    }

    try {
      final credential = await AuthenticationService(context)
          .signUpWithEmailAndPassword(signupData.email, signupData.password);
      UserModel.initialize(
          uid: credential.user!.uid,
          email: signupData.email,
          name: signupData.name,
          photoUrl: ''
      );
      await UserService(context).saveUser(UserModel.instance);
    } catch (e) {
      return e.toString();
    }

    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    return null;
  }

  Future<String?> socialLogin(String type) async {
    try {
      final UserCredential credential;

      switch (type) {
        case 'Google':
          credential = await AuthenticationService(context).signInWithGoogle();
          break;
        case 'Facebook':
          return 'Function no available';
        default:
          throw Exception("Tipo de inicio de sesión no soportado: $type");
      }

      final user = credential.user;
      if (user == null) {
        throw Exception("Error: No se pudo obtener el usuario después del inicio de sesión.");
      }

      if (await UserService(context).doesUserExist(user.uid)) {
        buildUser(credential);
      } else {
        UserModel.initialize(
          uid: user.uid,
          email: user.email ?? "",
          name: user.displayName ?? "",
          photoUrl: user.photoURL ?? "",
        );
        await UserService(context).saveUser(UserModel.instance);
      }

      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> buildUser(UserCredential credential) async {

    Map<String, dynamic>? userData = await UserService(context)
        .getUserData(credential.user!.uid);

    UserModel.initialize(
      uid: credential.user!.uid,
      email: userData?['email'] ?? '',
      name: userData?['name'] ?? '',
      photoUrl: userData?['photoUrl'] ?? '',
    );
  }
}