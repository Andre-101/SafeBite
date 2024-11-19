import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

class AuthenticationService {

  AuthenticationService(this.context);
  final BuildContext context;

  Future<String?> loginWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      
      if (userCredential.user != null) {
        // Guardar datos en SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('uid', userCredential.user!.uid);
        await prefs.setString('email', userCredential.user!.email ?? '');
        await prefs.setString('username', userCredential.user!.displayName ?? 'Usuario');
        
        // Inicializar el modelo de usuario
        UserModel.initialize(
          uid: userCredential.user!.uid,
          email: userCredential.user!.email ?? '',
          name: userCredential.user!.displayName ?? 'Usuario',
        );
        return null;
      }
      return 'Error al iniciar sesión';
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return 'No existe una cuenta con este correo';
        case 'wrong-password':
          return 'Contraseña incorrecta';
        case 'invalid-email':
          return 'Correo electrónico inválido';
        case 'user-disabled':
          return 'Esta cuenta ha sido deshabilitada';
        default:
          return 'Error al iniciar sesión: ${e.message}';
      }
    } catch (e) {
      return 'Error inesperado: $e';
    }
  }

  Future<String?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      
      if (userCredential.user != null) {
        // Guardar datos en SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('uid', userCredential.user!.uid);
        await prefs.setString('email', userCredential.user!.email ?? '');
        await prefs.setString('username', userCredential.user!.displayName ?? 'Usuario');
        
        // Inicializar el modelo de usuario
        UserModel.initialize(
          uid: userCredential.user!.uid,
          email: userCredential.user!.email ?? '',
          name: userCredential.user!.displayName ?? 'Usuario',
        );
        return null;
      }
      return 'Error al crear la cuenta';
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          return 'La contraseña es demasiado débil';
        case 'email-already-in-use':
          return 'Ya existe una cuenta con este correo';
        case 'invalid-email':
          return 'Correo electrónico inválido';
        default:
          return 'Error al crear la cuenta: ${e.message}';
      }
    } catch (e) {
      return 'Error inesperado: $e';
    }
  }

  Future<void> signOut() async {
    try {
      // Cerrar sesión de Firebase
      await FirebaseAuth.instance.signOut();
      
      // Limpiar SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      
      // Limpiar el modelo de usuario
      UserModel.clear();
    } catch (e) {
      debugPrint('Error durante el cierre de sesión: $e');
      rethrow;
    }
  }
}