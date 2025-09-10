// System App Bar Tests
//
// Verifies drawer button behavior and title content.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cannasoltech_automation/components/system_app_bar.dart';

import '../../helpers/test_utils.dart';

class _FakeStatusMessage {
  final String text;
  final Color color;
  _FakeStatusMessage(this.text, this.color);
}

class _FakeState {
  final _FakeStatusMessage statusMessage;
  _FakeState(this.statusMessage);
}

class _FakeDevice {
  final String id;
  final String name;
  final _FakeState? state;
  _FakeDevice({required this.id, required this.name, this.state});
}

void main() {
  TestEnvironment.setupGroup();

  testWidgets('drawer button opens drawer', (tester) async {
    await tester.pumpWidget(createTestApp(
      child: Scaffold(
        appBar: systemAppBar(null, null),
        drawer: const Drawer(child: Text('Drawer')),
        body: const Center(child: Text('Body')),
      ),
    ));

    // Tap menu icon
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    expect(find.text('Drawer'), findsOneWidget);
  });

  testWidgets('title reflects device status', (tester) async {
    final device = _FakeDevice(
      id: 'd1',
      name: 'Device 1',
      state: _FakeState(_FakeStatusMessage('Idle', Colors.yellow)),
    );

    await tester.pumpWidget(createTestApp(
      child: Scaffold(
        appBar: systemAppBar(null, device),
        body: const SizedBox(),
      ),
    ));

    expect(find.text('Device 1'), findsOneWidget);
    expect(find.text('Idle'), findsOneWidget);
  });
}

