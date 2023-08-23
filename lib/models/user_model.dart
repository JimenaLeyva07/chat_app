class UserModel {
  const UserModel({
    required this.name,
    required this.email,
    required this.uid,
    this.online = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        name: json['name'].toString(),
        email: json['email'].toString(),
        online: json['online'] as bool,
        uid: json['uid'].toString(),
      );

  factory UserModel.empty() => const UserModel(name: '', email: '', uid: 'uid');

  final String name;
  final String email;
  final bool online;
  final String uid;

  UserModel copyWith({
    String? name,
    String? email,
    bool? online,
    String? uid,
  }) =>
      UserModel(
        name: name ?? this.name,
        email: email ?? this.email,
        online: online ?? this.online,
        uid: uid ?? this.uid,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'email': email,
        'online': online,
        'uid': uid,
      };

  @override
  String toString() {
    return 'Username: $name, email: $email, online: $online, uid: $uid';
  }
}
