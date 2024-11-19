import 'package:flutter/material.dart';
import 'package:safebite/src/views/profile_screen.dart';
import 'package:safebite/src/views/scanner_screen.dart';

import 'views/home_screen.dart';
import 'views/login_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeBite',
      theme: ThemeData(
        primaryColor: Colors.blue,
        colorScheme: const ColorScheme.light(primary: Colors.blue),
        textTheme: Theme.of(context).textTheme.apply(
          // Note: The below line is required due to a current bug in Flutter:
          // https://github.com/flutter/flutter/issues/129553
            decorationColor: Colors.green),
        inputDecorationTheme: const InputDecorationTheme(
          prefixIconColor: Colors.black54,
          suffixIconColor: Colors.black54,
          iconColor: Colors.black54,
          labelStyle: TextStyle(color: Colors.black54),
          hintStyle: TextStyle(color: Colors.black54),
        ),
        // primaryColor: Colors.green,
        // colorScheme: const ColorScheme.light(primary: Colors.lightGreen),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (BuildContext context) => const LoginScreen(),
        '/home': (BuildContext context) => const HomeScreen(),
        '/profile': (BuildContext context) => const ProfileScreen(),
        '/scanner': (BuildContext context) => const ScannerScreen()
      },
    );
  }
}