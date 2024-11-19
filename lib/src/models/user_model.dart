class UserModel {
  final String uid;
  final String email;
  final String name;
  final String photoUrl;

  UserModel._({
    required this.uid,
    required this.email,
    required this.name,
    this.photoUrl = '',
  });

  static UserModel? _instance;

  static UserModel get instance {
    if (_instance == null) {
      throw Exception("UserModel no ha sido inicializado. Llama a initialize primero.");
    }
    return _instance!;
  }

  static void initialize({
    required String uid,
    required String email,
    required String name,
    String photoUrl = '',
  }) {
    if (_instance == null) {
      _instance = UserModel._(
        uid: uid,
        email: email,
        name: name,
        photoUrl: photoUrl,
      );
    } else {
      throw Exception("UserModel ya ha sido inicializado.");
    }
  }

  static void clear() {
    _instance = null;
  }
}

