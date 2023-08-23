class MessagesResponse {
  const MessagesResponse({
    required this.ok,
    required this.messages,
  });

  factory MessagesResponse.fromJson(Map<String, dynamic> json) =>
      MessagesResponse(
        ok: json['ok'] as bool,
        messages: (json['messages'] as List<dynamic>)
            .map(
              (dynamic message) =>
                  Message.fromJson(message as Map<String, dynamic>),
            )
            .toList(),
      );

  final bool ok;
  final List<Message> messages;

  MessagesResponse copyWith({
    bool? ok,
    List<Message>? messages,
  }) =>
      MessagesResponse(
        ok: ok ?? this.ok,
        messages: messages ?? this.messages,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'ok': ok,
        'messages': List<dynamic>.from(
            messages.map((Message message) => message.toJson())),
      };
}

class Message {
  Message({
    required this.from,
    required this.to,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        from: json['from'] as String,
        to: json['to'] as String,
        message: json['message'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );

  final String from;
  final String to;
  final String message;
  final DateTime createdAt;
  final DateTime updatedAt;

  Message copyWith({
    String? from,
    String? to,
    String? message,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Message(
        from: from ?? this.from,
        to: to ?? this.to,
        message: message ?? this.message,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'from': from,
        'to': to,
        'message': message,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  @override
  String toString() {
    return 'From: $from, to: $to, message: $message';
  }
}
