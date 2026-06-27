import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:electricity_bill_calculator/app.dart';
import 'package:electricity_bill_calculator/core/providers/app_providers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App launches splash screen', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          appInitializationProvider.overrideWith((ref) async {}),
        ],
        child: const ElectricityBillApp(),
      ),
    );

    await tester.pump();
    expect(find.byType(ElectricityBillApp), findsOneWidget);
  });
}
