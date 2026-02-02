class UserModel {
  final String email;
  final String passwordHash;

  UserModel({
    required this.email,
    required this.passwordHash,
  });

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "passwordHash": passwordHash,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      passwordHash: json['passwordHash'],
    );
  }
}
