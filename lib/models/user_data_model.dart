class UserDataModel {
  final int coin;
  final String id;
  final String name;
  final String lastName;
  final String? profileUrl;
  final String? mobileNumber;
  final String role;
  final String email;

  UserDataModel({
    required this.coin,
    required this.id,
    required this.name,
    required this.lastName,
    this.profileUrl,
    this.mobileNumber,
    required this.role,
    required this.email,
  });

  factory UserDataModel.fromJson(Map<String, dynamic> json) {
    return UserDataModel(
      coin: json['coin'] as int,
      id: json['id'] as String,
      name: json['name'] as String,
      lastName: json['lastName'] as String,
      profileUrl: json['profileUrl'] as String?,
      mobileNumber: json['mobileNumber'] as String?,
      role: json['role'] as String,
      email: json['email'] as String,
    );
  }
}