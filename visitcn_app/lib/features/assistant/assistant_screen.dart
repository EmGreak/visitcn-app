import 'package:flutter/material.dart';
import '../../../core/api/minimax_client.dart';

class AssistantScreen extends StatefulWidget {
  const AssistantScreen({super.key});

  @override
  State<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends State<AssistantScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Predefined quick questions with category icons
  final List<QuickQuestion> _quickQuestions = [
    QuickQuestion('Create a 3-day Shanghai itinerary', Icons.travel_explore, 'itinerary'),
    QuickQuestion('How do I apply for a China visa?', Icons.badge, 'visa'),
    QuickQuestion('How to use Alipay as a foreigner?', Icons.payment, 'payment'),
    QuickQuestion('What\'s the best way from airport to city?', Icons.directions_transit, 'transport'),
    QuickQuestion('Emergency contacts in China', Icons.emergency, 'emergency'),
    QuickQuestion('SIM card options for tourists', Icons.sim_card, 'sim'),
  ];

  @override
  void initState() {
    super.initState();
    _messages.add(ChatMessage(
      isUser: false,
      message: '👋 Welcome to VisitCN!\n\nI\'m your AI travel assistant for China. Tell me what you need:\n\n• 📅 Itinerary planning\n• 🛂 Visa guidance\n• 💳 Payment setup\n• 🚇 Transportation\n• 🏥 Emergency help\n• 🍜 Food recommendations',
      time: DateTime.now(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.smart_toy),
            SizedBox(width: 8),
            Text('AI Assistant'),
          ],
        ),
        actions: [
          if (_messages.length > 1)
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'New conversation',
              onPressed: () {
                setState(() {
                  _messages.clear();
                  _messages.add(ChatMessage(
                    isUser: false,
                    message: '👋 Let\'s start fresh! How can I help you?',
                    time: DateTime.now(),
                  ));
                  _errorMessage = null;
                });
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // Error banner
          if (_errorMessage != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              color: Colors.red.shade100,
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red.shade700, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red.shade700, fontSize: 12),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 16),
                    onPressed: () => setState(() => _errorMessage = null),
                  ),
                ],
              ),
            ),

          // Quick questions (only show when conversation is short)
          if (_messages.length <= 2)
            Container(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Try these:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _quickQuestions.map((q) {
                      return ActionChip(
                        avatar: Icon(q.icon, size: 14),
                        label: Text(q.text, style: const TextStyle(fontSize: 11)),
                        onPressed: () => _sendMessage(q.text, category: q.category),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

          // Chat messages
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _ChatBubble(message: msg);
              },
            ),
          ),

          // Loading indicator
          if (_isLoading)
            Container(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text('VisitCN AI is thinking...'),
                ],
              ),
            ),

          // Input area
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
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
                      decoration: InputDecoration(
                        hintText: 'Ask me anything about traveling in China...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      onSubmitted: (text) => _sendMessage(text),
                      textInputAction: TextInputAction.send,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: _isLoading ? null : () => _sendMessage(_controller.text),
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage(String text, {String? category}) async {
    if (text.trim().isEmpty) return;

    // Add user message
    setState(() {
      _messages.add(ChatMessage(
        isUser: true,
        message: text,
        time: DateTime.now(),
      ));
      _controller.clear();
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Build messages for API
      final userText = category != null
          ? '[${category.toUpperCase()}] $text'
          : text;
      
      final apiMessages = MiniMaxClient.buildTravelAssistantMessages(userText);
      
      // Call MiniMax API
      final response = await MiniMaxClient.chat(messages: apiMessages);

      setState(() {
        _messages.add(ChatMessage(
          isUser: false,
          message: response,
          time: DateTime.now(),
        ));
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(
          isUser: false,
          message: '⚠️ Sorry, I couldn\'t connect to the AI service right now.\n\n'
              'Please try again in a moment, or check your internet connection.\n\n'
              'Error: ${e.toString()}',
          time: DateTime.now(),
        ));
        _isLoading = false;
        _errorMessage = 'Connection failed: ${e.toString()}';
      });
    }
  }
}

class QuickQuestion {
  final String text;
  final IconData icon;
  final String category;

  QuickQuestion(this.text, this.icon, this.category);
}

class ChatMessage {
  final bool isUser;
  final String message;
  final DateTime time;

  ChatMessage({
    required this.isUser,
    required this.message,
    required this.time,
  });
}

class _ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        decoration: BoxDecoration(
          color: message.isUser
              ? Theme.of(context).primaryColor
              : Colors.grey.shade100,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(message.isUser ? 18 : 6),
            bottomRight: Radius.circular(message.isUser ? 6 : 18),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectableText(
              message.message,
              style: TextStyle(
                color: message.isUser ? Colors.white : Colors.black87,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${message.time.hour}:${message.time.minute.toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: 10,
                color: message.isUser ? Colors.white60 : Colors.black38,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
