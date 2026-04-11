import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class TransportScreen extends StatelessWidget {
  const TransportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transport'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTransportCard(
              context,
              title: 'Metro/Subway',
              icon: Icons.subway,
              color: AppTheme.secondaryColor,
              description: 'Fast and cheap way to get around major cities.',
              items: [
                'Download apps: Metro Union or local city metro app',
                'Purchase single journey tokens at machines (use cash/card)',
                'Get a transportation card (易通行/一卡通) for convenience',
                'Tap card at entrance and exit gates',
                'Transfer within 30-60 min is free or discounted',
              ],
            ),
            const SizedBox(height: 16),

            _buildTransportCard(
              context,
              title: 'Taxi / Didi',
              icon: Icons.local_taxi,
              color: Colors.orange,
              description: 'Convenient with English support in major cities.',
              items: [
                'Use Didi app (available in English)',
                'Link foreign credit card for payment',
                'Enter destination in English or show address to driver',
                'Didi has English interface option in settings',
                'Sample phrase: "请到这个地址" (Please go to this address)',
              ],
            ),
            const SizedBox(height: 16),

            _buildTransportCard(
              context,
              title: 'Bus',
              icon: Icons.directions_bus,
              color: Colors.green,
              description: 'Extensive network but complex routes.',
              items: [
                'Exact fare required (check route fare)',
                'Scan QR code with Alipay/WeChat',
                'Press bell to request stop',
                'Announcements are in Chinese (check app for stops)',
              ],
            ),
            const SizedBox(height: 16),

            _buildTransportCard(
              context,
              title: 'High-Speed Rail (高铁)',
              icon: Icons.train,
              color: AppTheme.primaryColor,
              description: 'Fast and comfortable between cities.',
              items: [
                'Book via 12306 app (in Chinese) or at station',
                'Foreign passports accepted for booking',
                'Show passport at ticket pickup machines',
                'Arrive 30 min before departure',
                'Platform number shown 15 min before departure',
              ],
            ),
            const SizedBox(height: 16),

            _buildTransportCard(
              context,
              title: 'Airport Shuttle',
              icon: Icons.flight,
              color: Colors.purple,
              description: 'Connect to/from airports.',
              items: [
                'Airport metro lines in Beijing, Shanghai, Guangzhou',
                'Airport buses cover major city areas',
                'Didi available at airport pickup zones',
                'Pre-book airport transfers for convenience',
              ],
            ),
            const SizedBox(height: 24),

            // Useful Phrases
            _buildUsefulPhrases(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTransportCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required String description,
    required List<String> items,
  }) {
    return Card(
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          description,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: items.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check_circle, size: 18, color: AppTheme.primaryColor),
                      const SizedBox(width: 12),
                      Expanded(child: Text(item)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsefulPhrases(BuildContext context) {
    final phrases = [
      {'en': 'Where is the metro station?', 'cn': '地铁站在哪里？'},
      {'en': 'I want to go to...', 'cn': '我想去...'},
      {'en': 'Please take me to this address', 'cn': '请带我去这个地址'},
      {'en': 'How much is the fare?', 'cn': '多少钱？'},
      {'en': 'Stop here please', 'cn': '请在这里停车'},
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.translate, color: AppTheme.primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Useful Transport Phrases',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...phrases.map((phrase) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(phrase['en']!, style: const TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 4),
                    Text(
                      phrase['cn']!,
                      style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
