import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCity = 'Shanghai';
  
  final List<String> _cities = [
    'Shanghai',
    'Beijing',
    'Guangzhou',
    'Shenzhen',
    'Hangzhou',
    'Chengdu',
    'Xian',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('🇨🇳 ', style: TextStyle(fontSize: 24)),
            const Text('VisitCN'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () => _showLanguageDialog(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Card
            Card(
              color: Colors.red.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.waving_hand, color: Colors.orange),
                        const SizedBox(width: 8),
                        Text(
                          'Welcome to China!',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your all-in-one guide for traveling in China',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // City Selector
            Text(
              '📍 Select Your City',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _cities.length,
                itemBuilder: (context, index) {
                  final city = _cities[index];
                  final isSelected = city == _selectedCity;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(city),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() => _selectedCity = city);
                      },
                    ),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Quick Actions Grid
            Text(
              '🚀 Quick Actions',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: [
                _QuickActionCard(
                  icon: Icons.translate,
                  label: 'Translate',
                  color: Colors.blue,
                  onTap: () => _showTranslateDialog(context),
                ),
                _QuickActionCard(
                  icon: Icons.currency_yen,
                  label: 'Payments',
                  color: Colors.green,
                  onTap: () => _navigateTo(1),
                ),
                _QuickActionCard(
                  icon: Icons.directions_bus,
                  label: 'Transport',
                  color: Colors.orange,
                  onTap: () => _navigateTo(3),
                ),
                _QuickActionCard(
                  icon: Icons.assignment,
                  label: 'Visa',
                  color: Colors.purple,
                  onTap: () => _showVisaInfo(context),
                ),
                _QuickActionCard(
                  icon: Icons.local_hospital,
                  label: 'Medical',
                  color: Colors.red,
                  onTap: () => _navigateTo(4),
                ),
                _QuickActionCard(
                  icon: Icons.explore,
                  label: 'Explore',
                  color: Colors.teal,
                  onTap: () => _showExploreInfo(context),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Tips Section
            Text(
              '💡 Travel Tips',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Card(
              child: Column(
                children: [
                  _TipTile(
                    icon: Icons.wifi,
                    title: 'Stay Connected',
                    subtitle: 'Get a local SIM card or use eSIM',
                  ),
                  const Divider(height: 1),
                  _TipTile(
                    icon: Icons.payments,
                    title: 'Mobile Payment',
                    subtitle: 'Alipay & WeChat Pay are essential',
                  ),
                  const Divider(height: 1),
                  _TipTile(
                    icon: Icons.tips_and_updates,
                    title: 'Cash',
                    subtitle: 'Some places still prefer cash',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateTo(int index) {
    // Navigate to tab
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _LanguageOption(flag: '🇺🇸', name: 'English', code: 'en'),
            _LanguageOption(flag: '🇨🇳', name: '中文', code: 'zh'),
            _LanguageOption(flag: '🇯🇵', name: '日本語', code: 'ja'),
            _LanguageOption(flag: '🇰🇷', name: '한국어', code: 'ko'),
            _LanguageOption(flag: '🇪🇸', name: 'Español', code: 'es'),
          ],
        ),
      ),
    );
  }

  void _showTranslateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🌐 Quick Translate'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Type text to translate...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Chip(label: Text('EN → CN')),
                Chip(label: Text('CN → EN')),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Translate'),
          ),
        ],
      ),
    );
  }

  void _showVisaInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('📋 Visa Information'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Visa Types:', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('• Tourist Visa (L) - Most common'),
              Text('• Business Visa (M)'),
              Text('• Transit Visa (G) - 144h free'),
              SizedBox(height: 16),
              Text('144h Transit:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Available in Shanghai, Beijing, and 20+ cities'),
              Text('Requires onward ticket'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showExploreInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🏛️ Must-Visit Places'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_selectedCity == 'Shanghai') ...[
                _PlaceCard(name: 'The Bund', desc: 'Iconic waterfront'),
                _PlaceCard(name: 'Yu Garden', desc: 'Classical Chinese garden'),
                _PlaceCard(name: 'Nanjing Road', desc: 'Best shopping street'),
                _PlaceCard(name: 'Oriental Pearl', desc: 'Famous TV tower'),
              ] else ...[
                _PlaceCard(name: 'Popular Attraction 1', desc: 'City landmark'),
                _PlaceCard(name: 'Popular Attraction 2', desc: 'Cultural heritage'),
                _PlaceCard(name: 'Popular Attraction 3', desc: 'Natural beauty'),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _TipTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _TipTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String flag;
  final String name;
  final String code;

  const _LanguageOption({
    required this.flag,
    required this.name,
    required this.code,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(flag, style: const TextStyle(fontSize: 24)),
      title: Text(name),
      onTap: () {
        // Change language
        Navigator.pop(context);
      },
    );
  }
}

class _PlaceCard extends StatelessWidget {
  final String name;
  final String desc;

  const _PlaceCard({required this.name, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.place, color: Colors.red),
        title: Text(name),
        subtitle: Text(desc),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}
