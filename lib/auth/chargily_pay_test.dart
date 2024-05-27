

import 'package:flutter_test/flutter_test.dart';
import 'package:trys_1/chargily_pay.dart';

void main() {
  test('fetches balance from actual API', () async {
    final service = ChargilyPayService(
      baseUrl: "https://pay.chargily.net/test/api/v2",
      apiKey:
      'test_pk_hltuu4RLw2vBssLtfFxFvq5gMDzN5OwfHWEFm30LWcss', // Replace with your own API key
      secret:
      'live_sk_q9ROTn4V6P78lxe2iRt5Ok3aPY96RqHPObNXaSSX', // Replace with your own secret
    );

    final result = await service.getBalance();

    expect(result, isA<Map<String, dynamic>>()); // Expect a map response
    expect(result.containsKey('entity'), true); // Check for expected keys
    expect(result.containsKey('livemode'), true);
    // You can add further assertions based on your API response structure
  });
}