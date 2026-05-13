import 'package:flutter/material.dart';
import '../../core/utils/deep_link_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCity = 'Shanghai';
  
  final List<String> _cities = [
    'Shanghai', 'Beijing', 'Guangzhou', 'Shenzhen', 
    'Hangzhou', 'Chengdu', 'Xian', 'Suzhou',
  ];

  // App shortcuts - following VOYO's integrated approach
  final List<Map<String, dynamic>> _appShortcuts = [
    {'name': 'Didi', 'icon': '🚗', 'color': Colors.green, 'action': 'didi'},
    {'name': 'Baidu Map', 'icon': '🗺️', 'color': Colors.blue, 'action': 'baidu'},
    {'name': 'Alipay', 'icon': '💳', 'color': const Color(0xFF1677FF), 'action': 'alipay'},
    {'name': 'AutoNavi', 'icon': '🧭', 'color': Colors.teal, 'action': 'autonavi'},
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

            // VOYO-style App Shortcuts (Didi, Baidu Map, Alipay)
            Text(
              '📱 Essential Apps',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Integrated like VOYO - tap to open directly',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: _appShortcuts.map((app) {
                return AppShortcutCard(
                  name: app['name'],
                  icon: app['icon'],
                  color: app['color'],
                  subtitle: '',
                  onTap: () => _handleAppShortcut(app['action']),
                );
              }).toList(),
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
                  onTap: () => _navigateTo(2),
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
                  onTap: () => _showVisaScreen(context),
                ),
                _QuickActionCard(
                  icon: Icons.local_hospital,
                  label: 'Medical',
                  color: Colors.red,
                  onTap: () => _navigateTo(4),
                ),
                _QuickActionCard(
                  icon: Icons.explore,
                  label: 'Culture',
                  color: Colors.teal,
                  onTap: () => _showCultureScreen(context),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Culture Experiences (VOYO-style)
            _buildCultureSection(context),

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
                    subtitle: 'Get a local SIM or use eSIM',
                    onTap: () => _showSIMGuide(context),
                  ),
                  const Divider(height: 1),
                  _TipTile(
                    icon: Icons.payments,
                    title: 'Mobile Payment',
                    subtitle: 'Alipay & WeChat Pay are essential',
                    onTap: () => _showPaymentGuide(context),
                  ),
                  const Divider(height: 1),
                  _TipTile(
                    icon: Icons.tips_and_updates,
                    title: 'Offline Mode',
                    subtitle: 'Download city guides for offline use',
                    onTap: () => _showOfflineDialog(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCultureSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '🎭 Culture Experiences',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            TextButton(
              onPressed: () => _showCultureScreen(context),
              child: const Text('See All'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 160,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _CultureCard(
                image: '🏯',
                title: 'Dragon Boat',
                desc: 'Experience the ancient sport',
                price: '\$15',
                onTap: () => _showCultureDetail('dragon_boat'),
              ),
              const SizedBox(width: 12),
              _CultureCard(
                image: '🧘',
                title: 'Tai Chi',
                desc: 'Morning practice with master',
                price: '\$12',
                onTap: () => _showCultureDetail('tai_chi'),
              ),
              const SizedBox(width: 12),
              _CultureCard(
                image: '👘',
                title: 'Hanfu',
                desc: 'Try traditional Chinese clothing',
                price: '\$20',
                onTap: () => _showCultureDetail('hanfu'),
              ),
              const SizedBox(width: 12),
              _CultureCard(
                image: '🎨',
                title: 'Calligraphy',
                desc: 'Learn Chinese characters art',
                price: '\$18',
                onTap: () => _showCultureDetail('calligraphy'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _handleAppShortcut(String action) {
    switch (action) {
      case 'didi':
        DeepLinkService.openDidi();
        break;
      case 'baidu':
        DeepLinkService.openBaiduMap();
        break;
      case 'alipay':
        DeepLinkService.openAlipay();
        break;
      case 'autonavi':
        DeepLinkService.openAutoNavi();
        break;
    }
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

  void _showVisaScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const VisaScreen()),
    );
  }

  void _showCultureScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CultureScreen()),
    );
  }

  void _showCultureDetail(String activity) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('🎭 ${activity.replaceAll('_', ' ').toUpperCase()}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Duration: 2 hours'),
            const SizedBox(height: 8),
            const Text('Includes: Equipment, Instructor, Photos'),
            const SizedBox(height: 8),
            const Text('Location: Downtown Shanghai'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Book via DeepLink or in-app
              },
              child: const Text('Book Now'),
            ),
          ],
        ),
      ),
    );
  }

  void _showSIMGuide(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('📱 SIM Card Guide'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('🇨🇳 China Mobile', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('• Most widely covered'),
              Text('• eSIM available for iPhone'),
              SizedBox(height: 8),
              Text('🇨🇳 China Unicom', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('• Good for cities'),
              Text('• Fast 4G/5G'),
              SizedBox(height: 8),
              Text('🇨🇳 China Telecom', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('• Best for rural areas'),
              SizedBox(height: 16),
              Text('💡 Tip: Get eSIM before arrival if your phone supports it'),
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

  void _showPaymentGuide(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('💳 Payment Guide'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Alipay (Recommended)', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('• Most widely accepted'),
              Text('• Foreign credit cards accepted'),
              Text('• Link foreign card directly'),
              SizedBox(height: 8),
              Text('WeChat Pay', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('• Requires Chinese bank account'),
              Text('• Use Alipay instead'),
              SizedBox(height: 8),
              Text('Cash', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('• Still needed for small vendors'),
              Text('• RMB only'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              DeepLinkService.openAlipay();
            },
            child: const Text('Open Alipay'),
          ),
        ],
      ),
    );
  }

  void _showOfflineDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('📴 Offline Mode'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Download city guides for offline use:'),
            SizedBox(height: 12),
            Text('• City maps & directions'),
            Text('• Emergency numbers'),
            Text('• Visa information'),
            Text('• Essential phrases'),
            SizedBox(height: 12),
            Text('Available cities: Shanghai, Beijing, Guangzhou, Shenzhen'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Trigger offline download
            },
            child: const Text('Download Shanghai'),
          ),
        ],
      ),
    );
  }
}

// ==================== Visa Screen ====================

class VisaScreen extends StatelessWidget {
  const VisaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📋 Visa Assistant'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Visa Types Overview
          _buildSectionTitle('Visa Types'),
          const SizedBox(height: 8),
          _VisaTypeCard(
            title: 'Tourist Visa (L)',
            desc: 'Most common for visitors',
            duration: 'Up to 30 days',
            icon: '🎫',
          ),
          _VisaTypeCard(
            title: 'Business Visa (M)',
            desc: 'For business visits',
            duration: 'Up to 90 days',
            icon: '💼',
          ),
          _VisaTypeCard(
            title: 'Transit Visa (G)',
            desc: '144-hour visa-free',
            duration: '6 days',
            icon: '✈️',
          ),
          _VisaTypeCard(
            title: 'Student Visa (X)',
            desc: 'For studying',
            duration: 'Based on program',
            icon: '🎓',
          ),
          _VisaTypeCard(
            title: 'Work Visa (Z)',
            desc: 'For employment',
            duration: 'Up to 90 days',
            icon: '💼',
          ),

          const SizedBox(height: 24),
          _buildSectionTitle('144h Transit (Visa Free)'),
          const SizedBox(height: 8),
          Card(
            color: Colors.blue.shade50,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('🇨🇳 Available Cities:', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Shanghai, Beijing, Guangzhou, Shenzhen, Chengdu, Xian, Hangzhou, Nanjing, etc.'),
                  SizedBox(height: 12),
                  Text('📋 Requirements:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('• Onward ticket required'),
                  Text('• Passport valid 6+ months'),
                  Text('• Not from restricted countries'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),
          _buildSectionTitle('Step-by-Step Application'),
          const SizedBox(height: 8),
          _StepCard(step: '1', title: 'Choose Visa Type', desc: 'Match your purpose'),
          _StepCard(step: '2', title: 'Prepare Documents', desc: 'Passport, photo, invitation'),
          _StepCard(step: '3', title: 'Fill Application', desc: 'Online form at embassy'),
          _StepCard(step: '4', title: 'Book Appointment', desc: 'Schedule interview'),
          _StepCard(step: '5', title: 'Pay & Submit', desc: 'Pay fee, submit documents'),

          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // Deep link to visa check or external site
            },
            icon: const Icon(Icons.check_circle),
            label: const Text('Check My Visa Eligibility'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _VisaTypeCard extends StatelessWidget {
  final String title;
  final String desc;
  final String duration;
  final String icon;

  const _VisaTypeCard({
    required this.title,
    required this.desc,
    required this.duration,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Text(icon, style: const TextStyle(fontSize: 28)),
        title: Text(title),
        subtitle: Text('$desc • $duration'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // Show visa detail
        },
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final String step;
  final String title;
  final String desc;

  const _StepCard({
    required this.step,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          child: Text(step, style: const TextStyle(color: Colors.white)),
        ),
        title: Text(title),
        subtitle: Text(desc),
      ),
    );
  }
}

// ==================== Culture Screen ====================

class CultureScreen extends StatelessWidget {
  const CultureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎭 Culture Experiences'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Filter chips
          Wrap(
            spacing: 8,
            children: [
              FilterChip(label: const Text('All'), selected: true, onSelected: (_) {}),
              FilterChip(label: const Text('Sports'), onSelected: (_) {}),
              FilterChip(label: const Text('Arts'), onSelected: (_) {}),
              FilterChip(label: const Text('Food'), onSelected: (_) {}),
            ],
          ),
          const SizedBox(height: 16),

          // Dragon Boat
          _CultureActivityCard(
            image: '🐉',
            title: 'Dragon Boat Racing',
            desc: 'Experience China\'s traditional team sport. Paddles, drums, and competition!',
            duration: '3 hours',
            price: '\$25',
            location: 'Shanghai Rowing Club',
            rating: '⭐⭐⭐⭐⭐',
          ),
          const SizedBox(height: 12),

          // Tai Chi
          _CultureActivityCard(
            image: '🧘',
            title: 'Morning Tai Chi',
            desc: 'Start your day with a master. Learn breathing and movement techniques.',
            duration: '2 hours',
            price: '\$15',
            location: 'Yu Garden Park',
            rating: '⭐⭐⭐⭐⭐',
          ),
          const SizedBox(height: 12),

          // Hanfu
          _CultureActivityCard(
            image: '👘',
            title: 'Hanfu Experience',
            desc: 'Traditional Chinese clothing. Professional photos included.',
            duration: '4 hours',
            price: '\$40',
            location: 'Tianzi Mountain',
            rating: '⭐⭐⭐⭐',
          ),
          const SizedBox(height: 12),

          // Calligraphy
          _CultureActivityCard(
            image: '🖌️',
            title: 'Chinese Calligraphy',
            desc: 'Learn the art of Chinese characters. Take home your creation.',
            duration: '2 hours',
            price: '\$20',
            location: 'Old Town',
            rating: '⭐⭐⭐⭐⭐',
          ),
          const SizedBox(height: 12),

          // Tea Ceremony
          _CultureActivityCard(
            image: '🍵',
            title: 'Tea Ceremony',
            desc: 'Traditional Chinese tea ceremony. Learn about tea culture.',
            duration: '2 hours',
            price: '\$18',
            location: 'Longjing Tea House',
            rating: '⭐⭐⭐⭐',
          ),
        ],
      ),
    );
  }
}

class _CultureActivityCard extends StatelessWidget {
  final String image;
  final String title;
  final String desc;
  final String duration;
  final String price;
  final String location;
  final String rating;

  const _CultureActivityCard({
    required this.image,
    required this.title,
    required this.desc,
    required this.duration,
    required this.price,
    required this.location,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            width: double.infinity,
            color: Colors.grey.shade200,
            child: Center(
              child: Text(image, style: const TextStyle(fontSize: 48)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(price, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(desc),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 14, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(duration, style: TextStyle(color: Colors.grey.shade600)),
                    const SizedBox(width: 12),
                    Icon(Icons.location_on, size: 14, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(location, style: TextStyle(color: Colors.grey.shade600)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(rating),
                    ElevatedButton(
                      onPressed: () {
                        // Book activity
                      },
                      child: const Text('Book'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== Supporting Widgets ====================

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
  final VoidCallback onTap;

  const _TipTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
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
        Navigator.pop(context);
      },
    );
  }
}

class _CultureCard extends StatelessWidget {
  final String image;
  final String title;
  final String desc;
  final String price;
  final VoidCallback onTap;

  const _CultureCard({
    required this.image,
    required this.title,
    required this.desc,
    required this.price,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: 140,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 80,
                width: 140,
                color: Colors.grey.shade200,
                child: Center(
                  child: Text(image, style: const TextStyle(fontSize: 36)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 2),
                    Text(desc, style: TextStyle(fontSize: 11, color: Colors.grey.shade600), maxLines: 1),
                    const SizedBox(height: 4),
                    Text(price, style: const TextStyle(fontSize: 12, color: Colors.blue)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}