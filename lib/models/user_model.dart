class UserModel {
  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.online = false,
  });

  final String uid;
  final String name;
  final String email;
  final bool online;
}
