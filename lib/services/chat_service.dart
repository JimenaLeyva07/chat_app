import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../global/environment.dart';
import '../models/messages_response_model.dart';
import '../models/user_model.dart';
import 'auth_service.dart';

class ChatService with ChangeNotifier {
  UserModel userDestiny = UserModel.empty();

  Future<List<Message>> getChat(String userId) async {
    final http.Response response = await http.get(
      Uri.parse('${Environment.apiUrl}/messages/$userId'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken() ?? ''
      },
    );

    final MessagesResponse messagesResponse = MessagesResponse.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );

    return messagesResponse.messages;
  }
}

final chatServiceNotifierProvider =
    ChangeNotifierProvider((ref) => ChatService());
