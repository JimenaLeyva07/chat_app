import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/chat_message.dart';

final List<ChatMessage> messages = <ChatMessage>[
  // const ChatMessage(text: 'Hello world', uid: '123mine'),
  // const ChatMessage(text: 'Hello world', uid: '123mine'),
  // const ChatMessage(text: 'Hello world', uid: '12sd3mine'),
  // const ChatMessage(text: 'Hello world', uid: '12s2d3mine'),
  // const ChatMessage(text: 'Hello world', uid: '123mine'),
  // const ChatMessage(text: 'Hello world', uid: '123mine'),
  // const ChatMessage(text: 'Hello world', uid: '12s5d3mine'),
  // const ChatMessage(text: 'Hello world', uid: '123mine'),
];

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final TextEditingController inputChatController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  bool isWriting = false;

  @override
  void dispose() {
    for (final ChatMessage message in messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Column(
          children: <Widget>[
            CircleAvatar(
              maxRadius: 18,
              child: Text(
                'Te',
                style: TextStyle(fontSize: 12),
              ),
            ),
            SizedBox(
              height: 3,
            ),
            Text(
              'Jimena Leyva',
              style: TextStyle(color: Colors.black87, fontSize: 12),
            )
          ],
        ),
        elevation: 1,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                itemCount: messages.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) =>
                    messages[index],
                reverse: true,
              ),
            ),
            const Divider(
              height: 1,
            ),
            //TODO TextBox
            SafeArea(
              child: Container(
                height: 66,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                color: Colors.white,
                child: InputChat(
                  inputChatController: inputChatController,
                  focusNode: focusNode,
                  isWriting: isWriting,
                  handleSubmit: (String text) {
                    if (text.isEmpty) {
                      return;
                    }
                    print(text);
                    inputChatController.clear();
                    focusNode.requestFocus();
                    final ChatMessage newMessage = ChatMessage(
                      text: text,
                      uid: '123mine',
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
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // dynamic handleSubmit(String text) {}
}

class InputChat extends StatefulWidget {
  const InputChat({
    required this.inputChatController,
    required this.focusNode,
    required this.isWriting,
    required this.handleSubmit,
    super.key,
  });
  final TextEditingController inputChatController;
  final FocusNode focusNode;
  final bool isWriting;
  final Function(String text) handleSubmit;

  @override
  State<InputChat> createState() => _InputChatState();
}

class _InputChatState extends State<InputChat> {
  @override
  Widget build(BuildContext context) {
    bool isWriting = widget.isWriting;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Flexible(
          child: TextField(
            controller: widget.inputChatController,
            onSubmitted: (String value) => widget.handleSubmit(value),
            onChanged: (String value) {
              setState(() {
                if (value.trim().isNotEmpty) {
                  isWriting = true;
                } else {
                  isWriting = false;
                }
              });
            },
            decoration:
                const InputDecoration.collapsed(hintText: 'Send message'),
            focusNode: widget.focusNode,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 3.0),
          child: Platform.isIOS
              ? CupertinoButton(
                  onPressed: isWriting
                      ? () =>
                          widget.handleSubmit(widget.inputChatController.text)
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
                          ? () => widget
                              .handleSubmit(widget.inputChatController.text)
                          : null,
                      icon: const Icon(Icons.send),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
        )
      ],
    );
  }
}
