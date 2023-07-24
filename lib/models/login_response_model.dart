import 'user_model.dart';

class LoginResponseModel {
  LoginResponseModel({
    required this.ok,
    required this.user,
    required this.token,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      LoginResponseModel(
        ok: json['ok'] as bool,
        user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
        token: json['token'].toString(),
      );

  final bool ok;
  final UserModel user;
  final String token;

  LoginResponseModel copyWith({
    bool? ok,
    UserModel? user,
    String? token,
  }) =>
      LoginResponseModel(
        ok: ok ?? this.ok,
        user: user ?? this.user,
        token: token ?? this.token,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'ok': ok,
        'userDB': user.toJson(),
        'token': token,
      };
}
