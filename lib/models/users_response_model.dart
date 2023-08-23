import 'user_model.dart';

class UserResponseModel {
  const UserResponseModel({
    required this.ok,
    required this.users,
  });

  factory UserResponseModel.fromJson(Map<String, dynamic> json) =>
      UserResponseModel(
        ok: json['ok'] as bool,
        users: (json['users'] as List<dynamic>)
            .map(
              (dynamic userMap) =>
                  UserModel.fromJson(userMap as Map<String, dynamic>),
            )
            .toList(),
      );

  final bool ok;
  final List<UserModel> users;

  UserResponseModel copyWith({
    bool? ok,
    List<UserModel>? users,
  }) =>
      UserResponseModel(
        ok: ok ?? this.ok,
        users: users ?? this.users,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'ok': ok,
        'message':
            List<dynamic>.from(users.map((UserModel user) => user.toJson())),
      };
}
