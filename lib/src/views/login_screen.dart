import 'package:animated_login/animated_login.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';

import '../viewmodels/login_functions.dart';
import '../widgets/dialog_builders.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  AuthMode currentMode = AuthMode.login;

  CancelableOperation? _operation;

  @override
  Widget build(BuildContext context) {
    return AnimatedLogin(
      onLogin: (LoginData data) async =>
          _authOperation(LoginFunctions(context).onLogin(data)),
      onSignup: (SignUpData data) async =>
          _authOperation(LoginFunctions(context).onSignup(data)),
      logo: Image.asset('assets/images/logo.png'),
      // backgroundImage: 'images/background_image.jpg',
      signUpMode: SignUpModes.both,
      socialLogins: _socialLogins(context),
      loginDesktopTheme: _desktopTheme,
      loginMobileTheme: _mobileTheme,
      loginTexts: _loginTexts,
      passwordValidator: ValidatorModel(
        validatorCallback: (String? password) {
          if (password == null || password.isEmpty) {
            return 'La contraseña es requerida';
          }
          if (password.length < 8) {
            return 'La contraseña debe tener al menos 8 caracteres';
          }
          if (!password.contains(RegExp(r'[A-Z]'))) {
            return 'La contraseña debe contener al menos una mayúscula';
          }
          if (!password.contains(RegExp(r'[a-z]'))) {
            return 'La contraseña debe contener al menos una minúscula';
          }
          if (!password.contains(RegExp(r'[0-9]'))) {
            return 'La contraseña debe contener al menos un número';
          }
          return '';
        },
      ),
      initialMode: currentMode,
      onAuthModeChange: (AuthMode newMode) async {
        currentMode = newMode;
        await _operation?.cancel();
      },
    );
  }

 Future<String?> _authOperation(Future<String?> func) async {
  await _operation?.cancel();
  _operation = CancelableOperation.fromFuture(func);

  try {
    final String? res = await _operation?.valueOrCancellation();

    if (_operation?.isCompleted == true) {
      if (res == null || res.isEmpty) {
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      } else {
        DialogBuilder(context).showResultDialog(res);
      }
    }
    return res;
  } catch (e) {
    DialogBuilder(context).showResultDialog('Error inesperado: $e');
    return 'Error inesperado: $e';
  }
  }

  LoginViewTheme get _desktopTheme => _mobileTheme.copyWith(
    // To set the color of button text, use foreground color.
    actionButtonStyle: ButtonStyle(
      foregroundColor: MaterialStateProperty.all(Colors.white),
    ),
    dialogTheme: const AnimatedDialogTheme(
      languageDialogTheme: LanguageDialogTheme(
          optionMargin: EdgeInsets.symmetric(horizontal: 80)),
    ),
    loadingSocialButtonColor: Colors.green,
    loadingButtonColor: Colors.white,
    privacyPolicyStyle: const TextStyle(color: Colors.black87),
    privacyPolicyLinkStyle: const TextStyle(
        color: Colors.green, decoration: TextDecoration.underline),
  );

  LoginViewTheme get _mobileTheme => LoginViewTheme(
    // showLabelTexts: false,
    backgroundColor: Colors.green, // const Color(0xFF6666FF),
    formFieldBackgroundColor: Colors.white,
    formWidthRatio: 60,
    actionButtonStyle: ButtonStyle(
      foregroundColor: MaterialStateProperty.all(Colors.green),
    ),
    animatedComponentOrder: const <AnimatedComponent>[
      AnimatedComponent(
        component: LoginComponents.logo,
        animationType: AnimationType.right,
      ),
      AnimatedComponent(component: LoginComponents.title),
      AnimatedComponent(component: LoginComponents.description),
      AnimatedComponent(component: LoginComponents.formTitle),
      AnimatedComponent(component: LoginComponents.socialLogins),
      AnimatedComponent(component: LoginComponents.useEmail),
      AnimatedComponent(component: LoginComponents.form),
      AnimatedComponent(component: LoginComponents.notHaveAnAccount),
      AnimatedComponent(component: LoginComponents.changeActionButton),
      AnimatedComponent(component: LoginComponents.actionButton),
    ],
    // privacyPolicyStyle: const TextStyle(color: Colors.white70),
    // privacyPolicyLinkStyle: const TextStyle(
       // color: Colors.white, decoration: TextDecoration.underline),
  );

  LoginTexts get _loginTexts => LoginTexts(
    // nameHint: _username,
    // login: _login,
    // signUp: _signup,
    // signupEmailHint: 'Signup Email',
    // loginEmailHint: 'Login Email',
    // signupPasswordHint: 'Signup Password',
    // loginPasswordHint: 'Login Password',
  );

  List<SocialLogin> _socialLogins(BuildContext context) => <SocialLogin>[
    SocialLogin(
        callback: () async => _socialCallback('Google'),
        iconPath: 'assets/images/google.png'),
    SocialLogin(
        callback: () async => _socialCallback('Facebook'),
        iconPath: 'assets/images/facebook.png'),
  ];

  Future<String?> _socialCallback(String type) async {
    await _operation?.cancel();
    _operation = CancelableOperation.fromFuture(
        LoginFunctions(context).socialLogin(type));
    final String? res = await _operation?.valueOrCancellation();
    if (_operation?.isCompleted == true && res == null) {
      DialogBuilder(context)
          .showResultDialog('Successfully logged in with $type.');

      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    }
    return res;
  }
}

