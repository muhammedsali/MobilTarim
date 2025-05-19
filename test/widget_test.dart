import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tarim_uygulamasi/main.dart';

void main() {
  testWidgets('Bluetooth screen smoke test', (WidgetTester tester) async {
    // Build the Bluetooth screen and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: BluetoothDataScreen()));

    // Check for basic widget presence (like AppBar title).
    expect(find.text('Bluetooth Veri Okuma'), findsOneWidget);
    expect(find.textContaining('Bluetooth cihaz aranıyor'), findsOneWidget);
  });
}
