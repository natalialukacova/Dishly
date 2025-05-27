import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import '../core/theme.dart';
import '../utils/chat_scroll_utils.dart';
import '../widgets/chat/chat_list_view.dart';
import '../models/recipe.dart';
import '../services/chat_service.dart';

class ChatScreen extends StatefulWidget {
  final Recipe recipe;

  const ChatScreen({super.key, required this.recipe});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  late WebSocketChannel _channel;
  bool _isStreaming = false;
  bool _showTyping = false;

  @override
  void initState() {
    super.initState();
    _initChat();
  }

  Future<void> _initChat() async {
    await storeRecipe(widget.recipe);
    final history = await fetchChatMemory(widget.recipe.id);
    for (var msg in history) {
      _messages.add(msg);
      _listKey.currentState?.insertItem(_messages.length - 1);
    }
    Future.delayed(const Duration(milliseconds: 300), () {
      forceScrollToBottom(_scrollController);
    });
    _channel = connectWebSocket();
    _listenToMessages();
  }

  void _listenToMessages() {
    _channel.stream.listen((data) {
      final response = json.decode(data);

      if (response['stream_start'] == true) {
        setState(() {
          _isStreaming = true;
        });
      } else if (response['delta'] != null) {
        if (_messages.isEmpty || _messages.last['role'] != 'assistant') {
          _messages.add({'role': 'assistant', 'content': response['delta']});
          _listKey.currentState?.insertItem(_messages.length - 1);
        } else {
          _messages.last['content'] = (_messages.last['content'] ?? '') + response['delta'];
        }

        setState(() {
          _showTyping = false;
        });
        scrollToBottom(_scrollController);
      } else if (response['stream_end'] == true) {
        setState(() {
          _isStreaming = false;
        });
      } else if (response.containsKey('message')) {
        _messages.add({'role': 'assistant', 'content': response['message']});
        _listKey.currentState?.insertItem(_messages.length - 1);
        scrollToBottom(_scrollController);
      }
    }, onError: print, onDone: () => print('[WebSocket] Closed'));
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'content': text});
      _listKey.currentState?.insertItem(_messages.length - 1);
      _showTyping = true;
    });

    _channel.sink.add(json.encode({
      'recipeId': widget.recipe.id,
      'message': text,
    }));

    _controller.clear();
    scrollToBottom(_scrollController);
  }

  @override
  void dispose() {
    // Close the WebSocket and dispose of input controller to free resources
    _channel.sink.close(status.goingAway);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat about ${widget.recipe.title}"),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatListView(
              messages: _messages,
              showTyping: _showTyping,
              isStreaming: _isStreaming,
              listKey: _listKey,
              scrollController: _scrollController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(hintText: "Ask something..."),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
