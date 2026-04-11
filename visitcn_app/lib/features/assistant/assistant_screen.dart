import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../core/theme/app_theme.dart';

class AssistantScreen extends StatefulWidget {
  const AssistantScreen({super.key});

  @override
  State<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends State<AssistantScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isLoading = false;

  final List<String> _quickQuestions = [
    'How do I use WeChat Pay?',
    'How to take the metro in Beijing?',
    'What is the emergency number in China?',
    'How to buy a SIM card?',
    'Common Chinese phrases for tourists',
  ];

  @override
  void initState() {
    super.initState();
    _messages.add({
      'role': 'assistant',
      'content': 'Hello! I\'m your AI assistant for traveling in China. How can I help you today?',
      'time': DateTime.now(),
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add({
        'role': 'user',
        'content': text,
        'time': DateTime.now(),
      });
      _isLoading = true;
    });

    _controller.clear();

    try {
      final response = await _callMiniMaxAPI(text);
      setState(() {
        _messages.add({
          'role': 'assistant',
          'content': response,
          'time': DateTime.now(),
        });
      });
    } catch (e) {
      setState(() {
        _messages.add({
          'role': 'assistant',
          'content': 'Sorry, I encountered an error. Please try again.',
          'time': DateTime.now(),
        });
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String> _callMiniMaxAPI(String message) async {
    try {
      final apiKey = dotenv.env['MINIMAX_API_KEY'] ?? '';
      
      final response = await http.post(
        Uri.parse('https://api.minimaxi.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'MiniMax-Text-01',
          'messages': [
            {'role': 'system', 'content': 'You are a helpful travel assistant for foreign visitors to China.'},
            {'role': 'user', 'content': message},
          ],
          'max_tokens': 500,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        throw Exception('API Error: ${response.statusCode}');
      }
    } catch (e) {
      return 'I\'m here to help! For detailed answers, please configure the MiniMax API key.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Assistant'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _messages.clear();
                _messages.add({
                  'role': 'assistant',
                  'content': 'Hello! I\'m your AI assistant for traveling in China. How can I help you today?',
                  'time': DateTime.now(),
                });
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _quickQuestions.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                return ActionChip(
                  label: Text(_quickQuestions[index]),
                  onPressed: () => _sendMessage(_quickQuestions[index]),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg['role'] == 'user';
                return _buildMessageBubble(msg['content'], isUser, msg['time']);
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(String content, bool isUser, DateTime time) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isUser ? AppTheme.primaryColor : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              content,
              style: TextStyle(
                color: isUser ? Colors.white : AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${time.hour}:${time.minute.toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: 10,
                color: isUser ? Colors.white70 : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Ask me anything...',
                  prefixIcon: Icon(Icons.chat_outlined),
                ),
                textInputAction: TextInputAction.send,
                onSubmitted: _sendMessage,
              ),
            ),
            const SizedBox(width: 12),
            _isLoading
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : IconButton.filled(
                    onPressed: () => _sendMessage(_controller.text),
                    icon: const Icon(Icons.send),
                  ),
          ],
        ),
      ),
    );
  }
}
