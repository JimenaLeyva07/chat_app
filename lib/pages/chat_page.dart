import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/messages_response_model.dart';
import '../services/auth_service.dart';
import '../services/chat_service.dart';
import '../services/socket_service.dart';
import '../widgets/chat_message.dart';

final List<ChatMessage> messages = <ChatMessage>[];

class ChatPage extends ConsumerWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String userName =
        ref.watch(chatServiceNotifierProvider).userDestiny.name;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: <Widget>[
            CircleAvatar(
              maxRadius: 18,
              child: Text(
                userName.substring(0, 2),
                style: const TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            Text(
              userName,
              style: const TextStyle(color: Colors.black87, fontSize: 12),
            )
          ],
        ),
        elevation: 1,
      ),
      body: const InputChat(),
    );
  }
}

class InputChat extends ConsumerStatefulWidget {
  const InputChat({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InputChatState();
}

class _InputChatState extends ConsumerState<InputChat>
    with TickerProviderStateMixin {
  final TextEditingController inputChatController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  bool isWriting = false;
  late SocketService socketService;
  late AuthService authService;
  late ChatService chatService;

  @override
  void initState() {
    super.initState();
    socketService = ref.read(socketServiceProvider.notifier);
    authService = ref.read(authNotifierProvider.notifier);
    chatService = ref.read(chatServiceNotifierProvider.notifier);

    socketService.socket.on('message-personal', _listenMessage);

    _loadMessagesHistory(chatService.userDestiny.uid);
  }

  void _loadMessagesHistory(String userId) async {
    final List<Message> chat = await chatService.getChat(userId);
    final chatHistory = chat.map(
      (Message message) => ChatMessage(
        text: message.message,
        uid: message.from,
        animationController:
            AnimationController(vsync: this, duration: Duration.zero)
              ..forward(),
      ),
    );

    setState(() {
      messages.insertAll(0, chatHistory);
    });
  }

  void _listenMessage(dynamic data) {
    print('Obtained message $data');

    ChatMessage incomingMessage = ChatMessage(
      text: data['message'] as String,
      uid: data['from'] as String,
      animationController: AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      ),
    );
    setState(() {
      messages.insert(0, incomingMessage);
    });

    incomingMessage.animationController.forward();
  }

  @override
  void dispose() {
    for (final ChatMessage message in messages) {
      message.animationController.dispose();
    }
    messages.clear();

    socketService.socket.off('message-personal');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Flexible(
          child: ListView.builder(
            itemCount: messages.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (BuildContext context, int index) => messages[index],
            reverse: true,
          ),
        ),
        const Divider(
          height: 1,
        ),
        SafeArea(
          child: Container(
              height: 66,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              color: Colors.white,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Flexible(
                    child: TextField(
                      controller: inputChatController,
                      onSubmitted: (String value) => handleSubmit(value),
                      onChanged: (String value) {
                        setState(() {
                          if (value.trim().isNotEmpty) {
                            isWriting = true;
                          } else {
                            isWriting = false;
                          }
                        });
                      },
                      decoration: const InputDecoration.collapsed(
                        hintText: 'Send message',
                      ),
                      focusNode: focusNode,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3.0),
                    child: Platform.isIOS
                        ? CupertinoButton(
                            onPressed: isWriting
                                ? () => handleSubmit(inputChatController.text)
                                : null,
                            child: const Text('Send'),
                          )
                        : Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: IconTheme(
                              data: IconThemeData(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              child: IconButton(
                                highlightColor: Colors.transparent,
                                onPressed: isWriting
                                    ? () =>
                                        handleSubmit(inputChatController.text)
                                    : null,
                                icon: const Icon(Icons.send),
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                  )
                ],
              )
              //const InputChat(),
              ),
        )
      ],
    );
  }

  handleSubmit(String text) {
    if (text.isEmpty) {
      return;
    }
    print(text);
    inputChatController.clear();
    focusNode.requestFocus();
    final ChatMessage newMessage = ChatMessage(
      text: text,
      uid: authService.user.uid,
      animationController: AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 200),
      ),
    );
    messages.insert(0, newMessage);
    newMessage.animationController.forward();
    setState(() {
      isWriting = false;
    });
    socketService.emit(
      'message-personal',
      <String, String>{
        'from': authService.user.uid,
        'to': chatService.userDestiny.uid,
        'message': text
      },
    );
  }
}
