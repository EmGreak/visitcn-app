import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// DeepLink utility for external app integration
/// Following VOYO's approach of integrating essential Chinese apps
class DeepLinkService {
  // App Store IDs for iOS universal links
  static const String didiAppStore = 'id478903460';
  static const String alipayAppStore = 'id333206289';
  static const String baiduMapAppStore = 'id315661156';
  static const String autoNaviMapAppStore = 'id461703208';

  // WeChat is not available on App Store for foreigners
  // We'll guide users to use Alipay for WeChat Pay equivalent

  /// Check if an app is installed and launch it
  static Future<bool> launchApp(String scheme, {String? fallback}) async {
    try {
      final uri = Uri.parse(scheme);
      final canLaunch = await canLaunchUrl(uri);
      
      if (canLaunch) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return true;
      } else if (fallback != null) {
        return await launchUrl(
          Uri.parse(fallback),
          mode: LaunchMode.externalApplication,
        );
      }
      return false;
    } catch (e) {
      debugPrint('DeepLink error: $e');
      return false;
    }
  }

  // ==================== DIDI ====================

  /// Open Didi app for ride-hailing
  /// iOS: didi://
  /// Android: Intent scheme or direct APK link
  static Future<bool> openDidi({
    double? lat,
    double? lng,
    String? address,
  }) async {
    // For iOS, we try the universal link first, then App Store
    final schemes = [
      'didi://didi/open',
      'https://www.didiglobal.com/',
    ];

    // Try direct scheme first
    for (final scheme in schemes) {
      final uri = Uri.parse(scheme);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return true;
      }
    }

    // Fallback to App Store
    return await launchUrl(
      Uri.parse('https://apps.apple.com/app/id$didiAppStore'),
      mode: LaunchMode.externalApplication,
    );
  }

  // ==================== Baidu Map ====================

  /// Open Baidu Map for navigation
  static Future<bool> openBaiduMap({
    double? lat,
    double? lng,
    String? locationName,
    String? addr,
  }) async {
    // Baidu Map URL scheme
    String scheme;
    
    if (lat != null && lng != null) {
      // Navigation to coordinates
      scheme = 'baidumap://map/direction?origin=current&destination=name:${locationName ?? ''}|latlng:$lat,$lng&mode=driving';
    } else {
      // Open the app
      scheme = 'baidumap://map/';
    }

    final uri = Uri.parse(scheme);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      return true;
    }

    // Fallback to App Store
    return await launchUrl(
      Uri.parse('https://apps.apple.com/app/id$baiduMapAppStore'),
      mode: LaunchMode.externalApplication,
    );
  }

  // ==================== AutoNavi Map (高德地图) ====================

  /// Open AutoNavi Map (高德地图) - preferred for foreigners
  static Future<bool> openAutoNavi({
    double? lat,
    double? lng,
    String? name,
    String? addr,
  }) async {
    String scheme;
    
    if (lat != null && lng != null) {
      scheme = 'amapuri://rideRoute?sourceApplication=VisitCN&slat=&slon=&sname=&dlat=$lat&dlon=$lng&dname=${name ?? ''}&dev=0';
    } else {
      scheme = 'amapuri://';
    }

    final uri = Uri.parse(scheme);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      return true;
    }

    // Fallback to App Store
    return await launchUrl(
      Uri.parse('https://apps.apple.com/app/id$autoNaviMapAppStore'),
      mode: LaunchMode.externalApplication,
    );
  }

  // ==================== Alipay ====================

  /// Open Alipay for payments
  /// Alipay can handle both Alipay and WeChat Pay scenarios
  static Future<bool> openAlipay({String? code}) async {
    if (code != null && code.isNotEmpty) {
      // Scan QR code
      final scheme = 'alipay://platformapi/startapp?appId=20000056&actionType=scan&bizData={"fromAppId":"VisitCN","code":"$code"}';
      final uri = Uri.parse(scheme);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return true;
      }
    }

    // Open Alipay main app
    final scheme = 'alipay://platformapi/startapp?appId=60000002';
    final uri = Uri.parse(scheme);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      return true;
    }

    // Fallback to App Store
    return await launchUrl(
      Uri.parse('https://apps.apple.com/app/id$alipayAppStore'),
      mode: LaunchMode.externalApplication,
    );
  }

  // ==================== WeChat Pay (via Alipay) ====================

  /// WeChat Pay typically requires WeChat app
  /// For foreigners without Chinese bank account, Alipay is the better option
  /// This guides users to use Alipay as the primary payment method
  static Future<bool> openWeChatPay() async {
    // WeChat doesn't support international accounts well
    // Guide users to use Alipay instead
    // We can also provide QR code scanning via Alipay
    return await openAlipay();
  }

  // ==================== SIM Card Purchase ====================

  /// Open China Mobile/联通/电信 store locator
  static Future<bool> openCarrierStore({
    String carrier = 'china-mobile', // china-mobile, china-unicom, china-telecom
  }) async {
    final urls = {
      'china-mobile': 'https://shop.10086.cn/',
      'china-unicom': 'https://www.10010.com/',
      'china-telecom': 'https://www.189.cn/',
    };

    final url = urls[carrier] ?? urls['china-mobile']!;
    return await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
  }

  // ==================== eSIM Activation ====================

  /// Guide for eSIM activation (for compatible devices)
  static Future<bool> openESIMGuide() async {
    // Open settings guide for eSIM
    return await launchUrl(
      Uri.parse('https://support.apple.com/en-us/HT209096'),
      mode: LaunchMode.externalApplication,
    );
  }
}

/// Quick access buttons widget for home screen
class AppShortcutCard extends StatelessWidget {
  final String name;
  final String icon;
  final Color color;
  final VoidCallback onTap;
  final String? subtitle;

  const AppShortcutCard({
    super.key,
    required this.name,
    required this.icon,
    required this.color,
    required this.onTap,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                icon,
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(height: 8),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: TextStyle(
                    fontSize: 9,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Quick access buttons data for easy mapping
class AppShortcutData {
  static const List<Map<String, dynamic>> essentialApps = [
    {
      'name': 'Didi',
      'icon': '🚗',
      'color': 0xFF4CAF50,
      'action': 'openDidi',
      'subtitle': 'Ride-hailing',
    },
    {
      'name': 'Baidu Map',
      'icon': '🗺️',
      'color': 0xFF2196F3,
      'action': 'openBaiduMap',
      'subtitle': 'Navigation',
    },
    {
      'name': 'Alipay',
      'icon': '💳',
      'color': 0xFF1677FF,
      'action': 'openAlipay',
      'subtitle': 'Payments',
    },
    {
      'name': 'AutoNavi',
      'icon': '🧭',
      'color': 0xFF00C853,
      'action': 'openAutoNavi',
      'subtitle': '高德地图',
    },
  ];
}