//intenté separar las pantallas login y register para añadir los datos de peso y altura :(

// import 'package:animated_login/animated_login.dart';
// import 'package:async/async.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({super.key});

//   @override
//   State<SignUpScreen> createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   // Aquí movemos las funciones _signInWithGoogle y _signInWithFacebook dentro de la clase para que tengan acceso al context.
  
//   Future<String?> _signInWithGoogle() async {
//     try {
//       final GoogleSignIn googleSignIn = GoogleSignIn();
//       final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

//       if (googleUser != null) {
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString('username', googleUser.displayName ?? 'Usuario');

//         // Redireccionar a Home
//         Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
//         return 'Successfully logged in with Google.';
//       } else {
//         return 'Login cancelled by user.';
//       }
//     } catch (error) {
//       return 'Error during Google Sign-In: $error';
//     }
//   }

//   Future<String?> _signInWithFacebook() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString('username', 'FacebookUser');

//       // Redireccionar a Home
//       Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
//       return 'Successfully logged in with Facebook.';
//     } catch (error) {
//       return 'Error during Facebook Sign-In: $error';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedLogin(
//       onSignup: (SignUpData data) async =>
//           _authOperation(LoginFunctions(context).onSignup(data)),
//       logo: Image.asset('assets/images/logo.png'),
//       signUpMode: SignUpModes.both,
//       socialLogins: _socialLogins(context),
//       loginDesktopTheme: _desktopTheme,
//       loginMobileTheme: _mobileTheme,
//       loginTexts: _loginTexts,
//       emailValidator: ValidatorModel(
//           validatorCallback: (String? email) => 'What an email! $email'),
//       initialMode: AuthMode.signup, // Para iniciar directamente en el registro
//       onAuthModeChange: (AuthMode newMode) async {
//         // Lógica de cambio de modo de autenticación si es necesario
//       },
//     );
//   }

//   Future<String?> _authOperation(Future<String?> func) async {
//     // Similar al LoginScreen, navegar a Home después de registrar
//     await func;
//     Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
//     return null;
//   }

//   List<SocialLogin> _socialLogins(BuildContext context) => <SocialLogin>[ 
//     SocialLogin(
//         callback: () async => await _signInWithGoogle(),
//         iconPath: 'assets/images/google.png',),
//     SocialLogin(
//         callback: () async => await _signInWithFacebook(),
//         iconPath: 'assets/images/facebook.png',),
//   ];

//   // Los temas de diseño del formulario (esto podría ser modificado según lo necesites)
//   LoginViewTheme get _mobileTheme => LoginViewTheme(
//     backgroundColor: Colors.green,
//     formFieldBackgroundColor: Colors.white,
//     formWidthRatio: 60,
//     actionButtonStyle: ButtonStyle(
//       foregroundColor: MaterialStateProperty.all(Colors.green),
//     ),
//     animatedComponentOrder: const <AnimatedComponent>[
//       AnimatedComponent(component: LoginComponents.logo),
//       AnimatedComponent(component: LoginComponents.title),
//       AnimatedComponent(component: LoginComponents.description),
//       AnimatedComponent(component: LoginComponents.formTitle),
//       AnimatedComponent(component: LoginComponents.socialLogins),
//       AnimatedComponent(component: LoginComponents.useEmail),
//       AnimatedComponent(component: LoginComponents.form),
//       AnimatedComponent(component: LoginComponents.notHaveAnAccount),
//       AnimatedComponent(component: LoginComponents.changeActionButton),
//       AnimatedComponent(component: LoginComponents.actionButton),
//     ],
//   );

//   LoginTexts get _loginTexts => LoginTexts(
//     // Aquí puedes agregar más texto si es necesario
//   );
// }
