import 'package:flutter/material.dart';

class AssistantScreen extends StatefulWidget {
  const AssistantScreen({super.key});

  @override
  State<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends State<AssistantScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  // Predefined quick questions
  final List<String> _quickQuestions = [
    'How do I use Alipay?',
    'Where can I exchange money?',
    'How to take subway?',
    'Emergency numbers?',
    'SIM card info?',
    'Wifi hotspots?',
  ];

  @override
  void initState() {
    super.initState();
    // Add welcome message
    _messages.add(ChatMessage(
      isUser: false,
      message: 'Hello! I\'m your VisitCN AI assistant. How can I help you today?',
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
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _messages.clear();
                _messages.add(ChatMessage(
                  isUser: false,
                  message: 'Hello! How can I help you today?',
                  time: DateTime.now(),
                ));
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Quick questions
          if (_messages.length <= 2)
            Container(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Quick Questions:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _quickQuestions.map((q) {
                      return ActionChip(
                        label: Text(q, style: const TextStyle(fontSize: 11)),
                        onPressed: () => _sendMessage(q),
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
            const Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 8),
                  Text('AI is thinking...'),
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
                        hintText: 'Type your question...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      onSubmitted: _sendMessage,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: () => _sendMessage(_controller.text),
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

  void _sendMessage(String text) {
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
    });

    // Simulate AI response
    Future.delayed(const Duration(seconds: 1), () {
      final response = _getAIResponse(text);
      setState(() {
        _messages.add(ChatMessage(
          isUser: false,
          message: response,
          time: DateTime.now(),
        ));
        _isLoading = false;
      });
    });
  }

  String _getAIResponse(String question) {
    final q = question.toLowerCase();
    
    if (q.contains('alipay') || q.contains('payment')) {
      return '''To use Alipay in China:

1. **Download Alipay** app from App Store
2. **Link your card** (Visa/Mastercard accepted)
3. **Verify identity** with passport

**Usage:**
- Scan QR codes to pay
- Show your payment code at stores
- Works everywhere in China

Need more details?''';
    } else if (q.contains('money') || q.contains('exchange')) {
      return '''**Currency Exchange Options:**

1. **Airport** - Available but limited hours, poor rates

2. **Banks** - ICBC, BOC, CCB offer better rates
   - Bring passport
   - Higher minimum amounts

3. **ATMs** - Global ATMs everywhere
   - Accept foreign cards
   - Best rates usually

4. ** hotels** - Convenient but poor rates

**Tip:** Exchange small amount at airport, rest at bank for better rates.''';
    } else if (q.contains('subway') || q.contains('metro') || q.contains('transport')) {
      return '''**Using Subway in $_getCityName():**

1. **Get a transit card** at any station
   - ¥20 deposit required
   - Refill at machines

2. **Or use mobile payment:**
   - Alipay/WeChat Metro card
   - Bank card with NFC

3. **Signs are bilingual:**
   - Chinese + English
   - Color-coded lines

4. **Tips:**
   - Peak hours: 8-9am, 5-7pm
   - Don't miss last train (usually 10-11pm)

Want directions to specific place?''';
    } else if (q.contains('emergency') || q.contains('hospital')) {
      return '''**Emergency Contacts in China:**

🚨 **Emergency Numbers:**
- Police: 110
- Ambulance: 120
- Fire: 119

**Nearest Hospital:**
Search "International Hospital" in your area for English-speaking staff.

**Tip:** Keep your passport and insurance info handy.''';
    } else if (q.contains('sim') || q.contains('phone') || q.contains('card')) {
      return '''**Getting a SIM Card in China:**

**Options:**
1. **eSIM** (if supported)
   - China Unicom, China Mobile
   - Buy online before arrival

2. **Physical SIM**
   - At airport upon arrival
   - Bring passport
   - Choose: China Mobile/Unicom/Telecom

**Data Plans:**
- ¥30-50/month for 10GB+
- Tourist packages available

**Documents needed:**
- Passport
- Local address (hotel OK)''';
    } else if (q.contains('wifi') || q.contains('internet')) {
      return '''**Staying Connected in China:**

**Free WiFi:**
- Hotels (password provided)
- Cafes (Starbucks, etc.)
- Airports, stations

**Mobile Data (Recommended):**
- Get local SIM or eSIM
- Or rent a pocket WiFi

**Note:** Google, Facebook, YouTube blocked
- Use VPN for these
- WeChat works fine without VPN''';
    } else {
      return '''Thanks for your question about "$question"!

I can help you with:
- 💳 Payments & Money
- 🚇 Transportation
- 📋 Visa & Documents
- 🏥 Medical & Emergency
- 📱 SIM & Internet
- 🏛️ Attractions & Tips

Please rephrase or choose a topic above!''';
    }
  }

  String _getCityName() {
    // This would come from state in real app
    return 'Shanghai';
  }
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
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: message.isUser ? Colors.blue : Colors.grey.shade200,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(message.isUser ? 16 : 4),
            bottomRight: Radius.circular(message.isUser ? 4 : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.message,
              style: TextStyle(
                color: message.isUser ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${message.time.hour}:${message.time.minute.toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: 10,
                color: message.isUser ? Colors.white70 : Colors.black45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
