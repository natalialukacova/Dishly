import 'package:flutter/cupertino.dart';
import 'package:mobile/widgets/chat/typing_indicator.dart';

import 'chat_message_item.dart';

class ChatListView extends StatelessWidget {
  final List<Map<String, String>> messages;
  final bool showTyping;
  final bool isStreaming;
  final GlobalKey<AnimatedListState> listKey;
  final ScrollController scrollController;

  const ChatListView({
    super.key,
    required this.messages,
    required this.showTyping,
    required this.isStreaming,
    required this.listKey,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: AnimatedList(
            key: listKey,
            controller: scrollController,
            initialItemCount: messages.length,
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, index, animation) {
              final msg = messages[index];
              return ChatMessageItem(
                key: ValueKey(index),
                role: msg['role'] ?? 'assistant',
                content: msg['content'] ?? '',
                animation: animation,
                isLatest: index == messages.length - 1 && isStreaming,
              );
            },
          ),
        ),
        if (showTyping)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: TypingIndicator(),
          ),
      ],
    );
  }
}
