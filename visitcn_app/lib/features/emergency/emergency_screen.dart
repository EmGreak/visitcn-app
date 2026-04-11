import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEmergencyBanner(context),
            const SizedBox(height: 24),
            _buildEmergencyNumbers(context),
            const SizedBox(height: 24),
            _buildGuideCard(
              context,
              title: 'Hospital & Medical',
              icon: Icons.local_hospital,
              color: Colors.red,
              items: [
                'Major hospitals have international departments',
                'Bring passport and insurance documents',
                'Many doctors speak basic English in big cities',
                'Emergency treatment is available without pre-payment',
                'Keep your insurance contact number handy',
              ],
            ),
            const SizedBox(height: 16),
            _buildGuideCard(
              context,
              title: 'Police & Security',
              icon: Icons.local_police,
              color: AppTheme.secondaryColor,
              items: [
                'Police stations are called 派出所',
                'For tourist complaints, visit 旅游投诉中心',
                'Police may not speak English - use translation app',
                'Always carry your passport',
                'Report lost/stolen items immediately',
              ],
            ),
            const SizedBox(height: 16),
            _buildEmbassySection(context),
            const SizedBox(height: 24),
            _buildTipsCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(Icons.emergency, color: Colors.white, size: 48),
          const SizedBox(height: 12),
          Text(
            'Emergency Numbers in China',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyNumbers(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _buildEmergencyTile(context, 'Police', '110', Icons.local_police, AppTheme.secondaryColor),
        _buildEmergencyTile(context, 'Ambulance', '120', Icons.medical_services, Colors.red),
        _buildEmergencyTile(context, 'Fire', '119', Icons.local_fire_department, Colors.orange),
        _buildEmergencyTile(context, 'Traffic', '122', Icons.traffic, Colors.blue),
      ],
    );
  }

  Widget _buildEmergencyTile(BuildContext context, String name, String number, IconData icon, Color color) {
    return Card(
      child: InkWell(
        onTap: () => _showCallDialog(context, name, number),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
              Text(
                number,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuideCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required List<String> items,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...items.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check, size: 18, color: color),
                    const SizedBox(width: 8),
                    Expanded(child: Text(item)),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildEmbassySection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.account_balance, color: AppTheme.primaryColor),
                const SizedBox(width: 12),
                Text(
                  'Embassies in China',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildEmbassyTile('🇺🇸 United States', '+86-10-8531-4000'),
            _buildEmbassyTile('🇬🇧 United Kingdom', '+86-10-8529-6600'),
            _buildEmbassyTile('🇯🇵 Japan', '+86-10-8531-9800'),
            _buildEmbassyTile('🇰🇷 South Korea', '+86-10-8531-2700'),
            const SizedBox(height: 8),
            Text(
              'Search for your country embassy for complete contact info.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmbassyTile(String flag, String phone) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Text(flag, style: const TextStyle(fontSize: 24)),
      title: Text(flag.split(' ').last),
      trailing: IconButton(
        icon: const Icon(Icons.phone, color: AppTheme.primaryColor),
        onPressed: () {},
      ),
    );
  }

  Widget _buildTipsCard(BuildContext context) {
    return Card(
      color: AppTheme.accentColor.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.tips_and_updates, color: AppTheme.accentColor),
                const SizedBox(width: 8),
                Text(
                  'Safety Tips',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildTip('Keep copies of important documents (passport, visa)'),
            _buildTip('Save emergency contacts in your phone'),
            _buildTip('Download translation app with offline capability'),
            _buildTip('Register with your embassy when arriving'),
            _buildTip('Learn basic Chinese emergency phrases'),
          ],
        ),
      ),
    );
  }

  Widget _buildTip(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: TextStyle(color: AppTheme.accentColor, fontWeight: FontWeight.bold)),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  void _showCallDialog(BuildContext context, String service, String number) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Call $service?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.phone, size: 48, color: AppTheme.primaryColor),
              const SizedBox(height: 16),
              Text(
                number,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Calling $service: $number'),
                    backgroundColor: AppTheme.primaryColor,
                  ),
                );
              },
              icon: const Icon(Icons.call),
              label: const Text('Call'),
            ),
          ],
        );
      },
    );
  }
}
