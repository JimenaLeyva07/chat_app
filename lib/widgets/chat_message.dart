import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/auth_service.dart';

class ChatMessage extends ConsumerWidget {
  const ChatMessage({
    required this.text,
    required this.uid,
    required this.animationController,
    super.key,
  });

  final String text;
  final String uid;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(
          parent: animationController,
          curve: Curves.easeOut,
        ),
        child: uid == ref.watch(authNotifierProvider).user.uid
            ? MyMessage(
                text: text,
              )
            : NotMyMessage(
                text: text,
              ),
      ),
    );
  }
}

class MyMessage extends StatelessWidget {
  const MyMessage({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 5, left: 50, right: 5),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceTint.withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class NotMyMessage extends StatelessWidget {
  const NotMyMessage({required this.text, super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 5, left: 5, right: 50),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.black87),
        ),
      ),
    );
  }
}
