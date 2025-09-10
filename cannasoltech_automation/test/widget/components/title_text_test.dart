// Title Text Widgets Tests
//
// Verifies rendering and behavior of titleText, subTitleText, and titleTextWithStatus.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cannasoltech_automation/components/title_text.dart';

import '../../helpers/test_utils.dart';

// Simple fakes to satisfy titleTextWithStatus dynamic access
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

  group('Title Text Components', () {
    testWidgets('titleText renders with provided text and color', (tester) async {
      const text = 'Main Title';
      const color = Colors.blue;

      await tester.pumpWidget(createTestApp(child: Center(child: titleText(text, color))));

      expect(find.text(text), findsOneWidget);
      final widget = tester.widget<Text>(find.text(text));
      expect(widget.style?.color, equals(color));
      expect(widget.textAlign, equals(TextAlign.center));
    });

    testWidgets('subTitleText renders with provided text and color', (tester) async {
      const text = 'Subtitle';
      const color = Colors.green;

      await tester.pumpWidget(createTestApp(child: Center(child: subTitleText(text, color))));

      expect(find.text(text), findsOneWidget);
      final widget = tester.widget<Text>(find.text(text));
      expect(widget.style?.color, equals(color));
      expect(widget.style?.fontWeight, equals(FontWeight.bold));
    });

    testWidgets('titleTextWithStatus shows no device selected state', (tester) async {
      final device = _FakeDevice(id: 'None', name: 'N/A');

      await tester.pumpWidget(createTestApp(child: Center(child: titleTextWithStatus(device))));

      expect(find.text('No Device Selected'), findsOneWidget);
    });

    testWidgets('titleTextWithStatus shows device name and status', (tester) async {
      final device = _FakeDevice(
        id: 'dev-1',
        name: 'Pump A',
        state: _FakeState(_FakeStatusMessage('Running', Colors.green)),
      );

      await tester.pumpWidget(createTestApp(child: Center(child: titleTextWithStatus(device))));

      expect(find.text('Pump A'), findsOneWidget);
      expect(find.text('Running'), findsOneWidget);
    });
  });
}

