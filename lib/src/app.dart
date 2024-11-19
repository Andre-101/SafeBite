import 'package:flutter/material.dart';
<<<<<<< HEAD

import 'views/home_screen.dart';
import 'views/login_screen.dart';
=======
import 'package:safe_bite/src/views/home_screen.dart';
import 'package:safe_bite/src/views/login_screen.dart';
>>>>>>> isaac

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
<<<<<<< HEAD
            decorationColor: Colors.blue),
=======
          decorationColor: Colors.blue),
>>>>>>> isaac
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
      },
      //home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}