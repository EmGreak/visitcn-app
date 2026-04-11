import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VisitCN'),
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
            _buildWelcomeCard(context),
            const SizedBox(height: 24),

            // Quick Actions
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildQuickActions(context),
            const SizedBox(height: 24),

            // Services
            Text(
              'Services',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildServicesGrid(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primaryColor, Color(0xFFFF7043)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.waving_hand, color: Colors.white, size: 28),
              const SizedBox(width: 12),
              Text(
                'Welcome to China!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Your essential guide to navigating China as a foreign visitor.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.explore),
            label: const Text('Explore Now'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      {'icon': Icons.chat, 'label': 'AI Assistant', 'color': AppTheme.primaryColor},
      {'icon': Icons.payment, 'label': 'Payments', 'color': Colors.green},
      {'icon': Icons.subway, 'label': 'Metro', 'color': AppTheme.secondaryColor},
      {'icon': Icons.local_taxi, 'label': 'Taxi', 'color': Colors.orange},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: actions.map((action) {
        return InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(12),
          child: Column(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: (action['color'] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  action['icon'] as IconData,
                  color: action['color'] as Color,
                  size: 28,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                action['label'] as String,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildServicesGrid(BuildContext context) {
    final services = [
      {'icon': Icons.translate, 'title': 'Translation', 'desc': 'Real-time translation'},
      {'icon': Icons.restaurant, 'title': 'Food Guide', 'desc': 'Chinese cuisine tips'},
      {'icon': Icons.attractions, 'title': 'Attractions', 'desc': 'Top tourist spots'},
      {'icon': Icons.health_and_safety, 'title': 'Healthcare', 'desc': 'Medical assistance'},
      {'icon': Icons.sim_card, 'title': 'SIM Card', 'desc': 'Data & calling'},
      {'icon': Icons.currency_exchange, 'title': 'Currency', 'desc': 'Exchange guide'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.9,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return Card(
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    service['icon'] as IconData,
                    size: 32,
                    color: AppTheme.primaryColor,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    service['title'] as String,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    service['desc'] as String,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Language',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildLanguageTile('🇺🇸 English', 'English', true),
              _buildLanguageTile('🇨🇳 中文', 'Chinese', false),
              _buildLanguageTile('🇯🇵 日本語', 'Japanese', false),
              _buildLanguageTile('🇰🇷 한국어', 'Korean', false),
              _buildLanguageTile('🇪🇸 Español', 'Spanish', false),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageTile(String flag, String name, bool selected) {
    return ListTile(
      leading: Text(flag, style: const TextStyle(fontSize: 24)),
      title: Text(name),
      trailing: selected ? const Icon(Icons.check, color: AppTheme.primaryColor) : null,
      onTap: () {},
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
