import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payments'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard(
              context,
              icon: Icons.info_outline,
              title: 'Cashless China',
              description: 'Most places in China prefer digital payments. Cash is rarely used.',
              color: AppTheme.secondaryColor,
            ),
            const SizedBox(height: 24),

            // WeChat Pay Section
            _buildPaymentCard(
              context,
              title: 'WeChat Pay',
              icon: Icons.chat,
              iconColor: const Color(0xFF07C160),
              steps: [
                'Download WeChat & register account',
                'Link your foreign credit card (Visa/MasterCard)',
                'Verify with passport information',
                'Add money to WeChat Pay balance',
                'Scan QR codes to pay',
              ],
              tips: [
                'Supported in most stores and restaurants',
                'Some merchants may charge a small fee for foreign cards',
              ],
            ),
            const SizedBox(height: 16),

            // Alipay Section
            _buildPaymentCard(
              context,
              title: 'Alipay',
              icon: Icons.payment,
              iconColor: const Color(0xFF1677FF),
              steps: [
                'Download Alipay app',
                'Register with phone number',
                'Submit passport for identity verification',
                'Link international credit/debit card',
                'Enable payment password',
              ],
              tips: [
                'Similar to WeChat Pay, widely accepted',
                'Good for ordering food and transportation',
              ],
            ),
            const SizedBox(height: 16),

            // Cash Section
            _buildPaymentCard(
              context,
              title: 'Cash (RMB)',
              icon: Icons.account_balance_wallet,
              iconColor: AppTheme.accentColor,
              steps: [
                'Exchange currency at airport or bank',
                'ATM withdrawals with foreign cards (fees apply)',
                'Some hotels and tourist shops accept cash',
              ],
              tips: [
                'Always carry some cash for small vendors',
                'USD and EUR are easily exchanged',
              ],
            ),
            const SizedBox(height: 24),

            // Exchange Rate Info
            _buildExchangeRates(context),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(description),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<String> steps,
    required List<String> tips,
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
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 28),
                ),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Steps
            Text(
              'How to Set Up:',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            ...steps.asMap().entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${entry.key + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(entry.value),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 12),

            // Tips
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb, size: 16, color: AppTheme.accentColor),
                      const SizedBox(width: 8),
                      Text(
                        'Tips',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.accentColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...tips.map((tip) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('• ', style: TextStyle(color: AppTheme.accentColor)),
                        Expanded(child: Text(tip, style: const TextStyle(fontSize: 13))),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExchangeRates(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Reference Rates',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildRateRow('1 USD', '≈ ¥7.25 CNY'),
            _buildRateRow('1 EUR', '≈ ¥7.85 CNY'),
            _buildRateRow('1 GBP', '≈ ¥9.15 CNY'),
            _buildRateRow('100 JPY', '≈ ¥4.80 CNY'),
            const SizedBox(height: 8),
            Text(
              'Rates are indicative. Check with your bank for actual rates.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRateRow(String from, String to) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(from),
          Text(to, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
