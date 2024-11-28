import 'package:animated_login/animated_login.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';

import '../viewmodels/login_functions.dart';
import '../widgets/dialog_builders.dart';
import 'user_info_screen.dart';
import '../models/user_model.dart'; // Asegúrate de importar el modelo.

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
      onLogin: (LoginData data) async => _authOperation(LoginFunctions(context).onLogin(data)),
      onSignup: (SignUpData data) async {
        await _authOperation(LoginFunctions(context).onSignup(data));

        // Aquí obtienes los datos del usuario desde Firebase después de un registro exitoso.
        String uid = UserModel.instance.uid; // Obtenemos el UID desde el UserModel ya inicializado.
        String email = data.email;
        String name = data.name ?? 'Unknown';
        String photoUrl = 'http://example.com/photo.jpg'; // Foto de perfil opcional.

        // Inicializa UserModel con los datos del usuario.
        try {
          UserModel.initialize(
            uid: uid, // Usamos el UID real del usuario
            email: email,
            name: name,
            photoUrl: photoUrl,
          );
        } catch (e) {
          // Muestra el error si no se ha inicializado previamente.
          DialogBuilder(context).showResultDialog("Error: $e");
        }

        // Luego navega a la siguiente pantalla.
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UserInfoScreen()),
        );
      },
      logo: Image.asset('assets/images/logo.png'),
      signUpMode: SignUpModes.both,
      socialLogins: _socialLogins(context),
      loginDesktopTheme: _desktopTheme,
      loginMobileTheme: _mobileTheme,
      loginTexts: _loginTexts,
      emailValidator: ValidatorModel(validatorCallback: (String? email) => '¿Es esto un correo? $email'),
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
      DialogBuilder(context).showResultDialog(res ?? 'Correcto.');
    }
    return res;
  }

  LoginViewTheme get _desktopTheme => _mobileTheme.copyWith(
    actionButtonStyle: ButtonStyle(
      foregroundColor: MaterialStateProperty.all(Colors.white),
    ),
    dialogTheme: const AnimatedDialogTheme(
      languageDialogTheme: LanguageDialogTheme(optionMargin: EdgeInsets.symmetric(horizontal: 80)),
    ),
    loadingSocialButtonColor: Colors.green,
    loadingButtonColor: Colors.white,
    privacyPolicyStyle: const TextStyle(color: Colors.black87),
    privacyPolicyLinkStyle: const TextStyle(color: Colors.green, decoration: TextDecoration.underline),
  );

  LoginViewTheme get _mobileTheme => LoginViewTheme(
    backgroundColor: Colors.green,
    formFieldBackgroundColor: Colors.white,
    formWidthRatio: 60,
    actionButtonStyle: ButtonStyle(
      foregroundColor: MaterialStateProperty.all(Colors.green),
    ),
    animatedComponentOrder: const <AnimatedComponent>[
      AnimatedComponent(component: LoginComponents.logo, animationType: AnimationType.right),
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
  );

  LoginTexts get _loginTexts => LoginTexts();

  List<SocialLogin> _socialLogins(BuildContext context) => <SocialLogin>[
    SocialLogin(callback: () async => _socialCallback('Google'), iconPath: 'assets/images/google.png'),
    SocialLogin(callback: () async => _socialCallback('Facebook'), iconPath: 'assets/images/facebook.png'),
  ];

  Future<String?> _socialCallback(String type) async {
    await _operation?.cancel();
    _operation = CancelableOperation.fromFuture(LoginFunctions(context).socialLogin(type));
    final String? res = await _operation?.valueOrCancellation();
    if (res != null) {
      DialogBuilder(context).showResultDialog(res);
    }
    if (_operation?.isCompleted == true && res == null) {
      DialogBuilder(context).showResultDialog('Successfully logged in with $type.');
    }
    return res;
  }
}
