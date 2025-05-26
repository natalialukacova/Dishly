import 'package:flutter/material.dart';

class ChatMessageItem extends StatefulWidget {
  final String role;
  final String content;
  final Animation<double> animation;
  final bool isLatest;

  const ChatMessageItem({
    super.key,
    required this.role,
    required this.content,
    required this.animation,
    this.isLatest = false,
  });

  @override
  State<ChatMessageItem> createState() => _ChatMessageItemState();
}

class _ChatMessageItemState extends State<ChatMessageItem> {
  late String _content;

  @override
  void initState() {
    super.initState();
    _content = widget.content;
  }

  @override
  void didUpdateWidget(covariant ChatMessageItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.content != widget.content) {
      setState(() => _content = widget.content);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isUser = widget.role == "user";

    return SlideTransition(
      position: widget.animation.drive(
        Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOut)),
      ),
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: EdgeInsets.only(
            top: 4,
            bottom: 4,
            left: isUser ? 60 : 8,
            right: isUser ? 8 : 60,
          ),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isUser ? Colors.blue[100] : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            _content,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
