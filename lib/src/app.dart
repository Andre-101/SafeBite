import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:safebite/src/views/profile_screen.dart';
import 'package:safebite/src/views/scanner_screen.dart';
import 'views/home_screen.dart';
import 'views/login_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeBite',
      theme: ThemeData(
        primaryColor: Colors.blue,
        colorScheme: const ColorScheme.light(primary: Colors.blue),
        textTheme: Theme.of(context).textTheme.apply(
            decorationColor: Colors.green), // Ajuste para bug en Flutter
        inputDecorationTheme: const InputDecorationTheme(
          prefixIconColor: Colors.black54,
          suffixIconColor: Colors.black54,
          iconColor: Colors.black54,
          labelStyle: TextStyle(color: Colors.black54),
          hintStyle: TextStyle(color: Colors.black54),
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: FirebaseAuth.instance.currentUser == null ? '/login' : '/home',
      routes: {
        '/login': (BuildContext context) => const LoginScreen(),
        '/home': (BuildContext context) {
          final currentUser = FirebaseAuth.instance.currentUser;
          if (currentUser == null) {
            return const LoginScreen(); // Redirige si no está autenticado
          }
          return HomeScreen(userUid: currentUser.uid); // Pasa el `userUid`
        },
        '/profile': (BuildContext context) {
          final currentUser = FirebaseAuth.instance.currentUser;
          if (currentUser == null) {
            return const LoginScreen(); // Redirige si no está autenticado
          }
          return ProfileScreen(userUid: currentUser.uid); // Pasa el `userUid`
        },
        '/scanner': (BuildContext context) => const ScannerScreen(),
      },
    );
  }
}
