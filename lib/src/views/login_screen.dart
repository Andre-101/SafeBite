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
      emailValidator: ValidatorModel(
          validatorCallback: (String? email) => 'What an email! $email'),
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
    final String? res = await _operation?.valueOrCancellation();
    if (_operation?.isCompleted == true) {
      DialogBuilder(context).showResultDialog(res ?? 'Successful.');
    }
    return res;
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

