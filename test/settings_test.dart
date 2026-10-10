import 'package:anidong/providers/theme_provider.dart';
import 'package:anidong/screens/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('SettingsScreen displays theme, notifications, storage and version info',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({}); // Mock SharedPreferences for ThemeProvider

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: const MaterialApp(
          home: SettingsScreen(),
        ),
      ),
    );

    // Verify section headers
    expect(find.text('Tampilan'), findsOneWidget);
    expect(find.text('Notifikasi'), findsOneWidget);
    expect(find.text('Penyimpanan & Data'), findsOneWidget);
    expect(find.text('Tentang Aplikasi'), findsOneWidget);

    // Verify switches (Dark Mode, New Episode Notifications)
    expect(find.byType(Switch), findsNWidgets(2));

    // Verify App version and Clear History
    expect(find.text('Hapus Riwayat Tontonan'), findsOneWidget);
    expect(find.text('v1.0.0'), findsOneWidget);

    // Tap dark mode switch
    final darkModeSwitchFinder = find.byType(Switch).first;
    await tester.tap(darkModeSwitchFinder);
    await tester.pumpAndSettle();

    // Tap notification switch
    final notifSwitchFinder = find.byType(Switch).at(1);
    final initialNotifValue = tester.widget<Switch>(notifSwitchFinder).value;
    await tester.tap(notifSwitchFinder);
    await tester.pumpAndSettle();
    final updatedNotifValue = tester.widget<Switch>(notifSwitchFinder).value;
    expect(updatedNotifValue, !initialNotifValue);
  });
}
