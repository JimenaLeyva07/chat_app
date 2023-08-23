import 'dart:convert';

import 'package:http/http.dart' as http;
import '../global/environment.dart';
import '../models/user_model.dart';
import '../models/users_response_model.dart';
import 'auth_service.dart';

class GetUsersService {
  Future<List<UserModel>> getUsers() async {
    try {
      final http.Response response = await http.get(
        Uri.parse('${Environment.apiUrl}/users?desde=0'),
        headers: <String, String>{
          'content-type': 'application/json',
          'x-token': await AuthService.getToken() ?? ''
        },
      );

      final UserResponseModel userList = UserResponseModel.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );

      return userList.users;
    } catch (e) {
      return <UserModel>[];
    }
  }
}
