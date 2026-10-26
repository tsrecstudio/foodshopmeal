import 'dart:convert';
import 'package:http/http.dart' as http;

enum DegradationLevel { l1, l2, l3 }

class SystemCapabilities {
  final DegradationLevel level;
  final String activeAdapter;
  final bool kuperFeatureEnabled;

  const SystemCapabilities({
    required this.level,
    required this.activeAdapter,
    required this.kuperFeatureEnabled,
  });

  factory SystemCapabilities.fromJson(Map<String, dynamic> json) {
    final raw = (json['effectiveDegradationLevel'] as String? ?? 'L1').toUpperCase();
    final level = switch (raw) {
      'L3' => DegradationLevel.l3,
      'L2' => DegradationLevel.l2,
      _ => DegradationLevel.l1,
    };
    return SystemCapabilities(
      level: level,
      activeAdapter: json['activeAdapter'] as String? ?? 'local_list',
      kuperFeatureEnabled: json['kuperFeatureEnabled'] as bool? ?? false,
    );
  }
}

class CapabilitiesClient {
  final String baseUrl;
  final http.Client _httpClient;

  CapabilitiesClient({
    this.baseUrl = const String.fromEnvironment('BFF_BASE_URL', defaultValue: ''),
    http.Client? httpClient,
  }) : _httpClient = httpClient ?? http.Client();

  Future<SystemCapabilities> fetchCapabilities() async {
    final uri = Uri.parse('$baseUrl/api/v1/system/capabilities');
    final response = await _httpClient.get(uri);
    if (response.statusCode != 200) {
      // Principle: unavailable store/backend -> graceful L1 smart-list fallback, never crash
      return const SystemCapabilities(
        level: DegradationLevel.l1,
        activeAdapter: 'local_list',
        kuperFeatureEnabled: false,
      );
    }
    return SystemCapabilities.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }
}
