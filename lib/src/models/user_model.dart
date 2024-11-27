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

  static void update({
    required String uid,
    required String email,
    required String name,
    String photoUrl = '',
  }) {
    _instance = UserModel._(
      uid: uid,
      email: email,
      name: name,
      photoUrl: photoUrl,
    );
  }

  static void reset() {
    _instance = null;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel._(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel._(
      uid: json['uid'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      photoUrl: json['photoUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
    };
  }
}


