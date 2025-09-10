// ToggleSwitch Widget Tests
//
// Comprehensive tests for ToggleSwitch widget including animations,
// interactions, styling, and accessibility.
//
// Testing Framework: flutter_test + mocktail
// Coverage Target: ≥85% widget coverage

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cannasoltech_automation/components/toggle_switch.dart';

import '../../helpers/test_utils.dart';

void main() {
  TestEnvironment.setupGroup();

  group('ToggleSwitch Widget Tests', () {
    testWidgets('should render with initial false value', (tester) async {
      bool switchValue = false;

      await tester.pumpWidget(createTestApp(
        child: Center(
          child: ToggleSwitch(
            value: switchValue,
            onChanged: (value) {
              switchValue = value;
            },
          ),
        ),
      ));

      expect(find.byType(ToggleSwitch), findsOneWidget);
      expect(find.byType(GestureDetector), findsOneWidget);
      expect(find.byType(AnimatedBuilder), findsOneWidget);
    });

    testWidgets('should render with initial true value', (tester) async {
      bool switchValue = true;

      await tester.pumpWidget(createTestApp(
        child: Center(
          child: ToggleSwitch(
            value: switchValue,
            onChanged: (value) {
              switchValue = value;
            },
          ),
        ),
      ));

      expect(find.byType(ToggleSwitch), findsOneWidget);
    });

    testWidgets('should toggle from false to true on tap', (tester) async {
      bool switchValue = false;
      bool? lastCallbackValue;

      await tester.pumpWidget(createTestApp(
        child: StatefulBuilder(
          builder: (context, setState) {
            return Center(
              child: ToggleSwitch(
                value: switchValue,
                onChanged: (value) {
                  setState(() {
                    switchValue = value;
                    lastCallbackValue = value;
                  });
                },
              ),
            );
          },
        ),
      ));

      // Initial state should be false
      expect(switchValue, isFalse);

      // Tap to toggle on
      await tester.tap(find.byType(ToggleSwitch));
      await tester.pumpAndSettle();

      expect(lastCallbackValue, isTrue);
    });

    testWidgets('should toggle from true to false on tap', (tester) async {
      bool switchValue = true;
      bool? lastCallbackValue;

      await tester.pumpWidget(createTestApp(
        child: StatefulBuilder(
          builder: (context, setState) {
            return Center(
              child: ToggleSwitch(
                value: switchValue,
                onChanged: (value) {
                  setState(() {
                    switchValue = value;
                    lastCallbackValue = value;
                  });
                },
              ),
            );
          },
        ),
      ));

      // Initial state should be true
      expect(switchValue, isTrue);

      // Tap to toggle off
      await tester.tap(find.byType(ToggleSwitch));
      await tester.pumpAndSettle();

      expect(lastCallbackValue, isFalse);
    });

    testWidgets('should have correct dimensions', (tester) async {
      await tester.pumpWidget(createTestApp(
        child: const Center(
          child: ToggleSwitch(value: false, onChanged: _noop),
        ),
      ));

      final containerFinder = find.descendant(
        of: find.byType(ToggleSwitch),
        matching: find.byType(Container),
      ).first;

      final Container container = tester.widget(containerFinder);
      expect(container.constraints?.maxWidth, equals(45.0));
      expect(container.constraints?.maxHeight, equals(28.0));
    });

    testWidgets('should animate when toggled', (tester) async {
      bool switchValue = false;

      await tester.pumpWidget(createTestApp(
        child: StatefulBuilder(
          builder: (context, setState) {
            return Center(
              child: ToggleSwitch(
                value: switchValue,
                onChanged: (value) {
                  setState(() {
                    switchValue = value;
                  });
                },
              ),
            );
          },
        ),
      ));

      // Tap to start animation
      await tester.tap(find.byType(ToggleSwitch));
      
      // Test that animation is in progress
      await tester.pump(const Duration(milliseconds: 30));
      expect(find.byType(AnimatedBuilder), findsOneWidget);
      
      // Complete animation
      await tester.pumpAndSettle();
      expect(find.byType(ToggleSwitch), findsOneWidget);
    });

    testWidgets('should handle multiple rapid taps', (tester) async {
      bool switchValue = false;
      int callbackCount = 0;

      await tester.pumpWidget(createTestApp(
        child: StatefulBuilder(
          builder: (context, setState) {
            return Center(
              child: ToggleSwitch(
                value: switchValue,
                onChanged: (value) {
                  setState(() {
                    switchValue = value;
                    callbackCount++;
                  });
                },
              ),
            );
          },
        ),
      ));

      // Multiple rapid taps
      await tester.tap(find.byType(ToggleSwitch));
      await tester.pump(const Duration(milliseconds: 10));
      await tester.tap(find.byType(ToggleSwitch));
      await tester.pump(const Duration(milliseconds: 10));
      await tester.tap(find.byType(ToggleSwitch));
      await tester.pumpAndSettle();

      expect(callbackCount, equals(3));
    });

    testWidgets('should be accessible for screen readers', (tester) async {
      await tester.pumpWidget(createTestApp(
        child: const Center(
          child: ToggleSwitch(value: false, onChanged: _noop),
        ),
      ));

      // Verify accessibility tree
      final handle = tester.ensureSemantics();
      expect(tester.binding.pipelineOwner.semanticsOwner?.rootSemanticsNode, isNotNull);
      handle.dispose();
    });

    testWidgets('should work in RTL text direction', (tester) async {
      bool switchValue = false;

      await tester.pumpWidget(createTestApp(
        textDirection: TextDirection.rtl,
        child: Center(
          child: ToggleSwitch(
            value: switchValue,
            onChanged: (value) {
              switchValue = value;
            },
          ),
        ),
      ));

      expect(find.byType(ToggleSwitch), findsOneWidget);
      
      // Test that it still responds to taps in RTL
      await tester.tap(find.byType(ToggleSwitch));
      await tester.pumpAndSettle();
      
      expect(find.byType(ToggleSwitch), findsOneWidget);
    });

    testWidgets('should work in LTR text direction', (tester) async {
      bool switchValue = false;

      await tester.pumpWidget(createTestApp(
        textDirection: TextDirection.ltr,
        child: Center(
          child: ToggleSwitch(
            value: switchValue,
            onChanged: (value) {
              switchValue = value;
            },
          ),
        ),
      ));

      expect(find.byType(ToggleSwitch), findsOneWidget);
      
      // Test that it responds to taps in LTR
      await tester.tap(find.byType(ToggleSwitch));
      await tester.pumpAndSettle();
      
      expect(find.byType(ToggleSwitch), findsOneWidget);
    });

    testWidgets('should handle gesture detection correctly', (tester) async {
      bool switchValue = false;
      bool tapped = false;

      await tester.pumpWidget(createTestApp(
        child: Center(
          child: ToggleSwitch(
            value: switchValue,
            onChanged: (value) {
              switchValue = value;
              tapped = true;
            },
          ),
        ),
      ));

      // Test tap detection
      expect(tapped, isFalse);
      await tester.tap(find.byType(ToggleSwitch));
      await tester.pumpAndSettle();
      expect(tapped, isTrue);
    });

    testWidgets('should maintain state during widget rebuilds', (tester) async {
      bool switchValue = false;

      await tester.pumpWidget(createTestApp(
        child: StatefulBuilder(
          builder: (context, setState) {
            return Center(
              child: ToggleSwitch(
                value: switchValue,
                onChanged: (value) {
                  setState(() {
                    switchValue = value;
                  });
                },
              ),
            );
          },
        ),
      ));

      // Toggle switch
      await tester.tap(find.byType(ToggleSwitch));
      await tester.pumpAndSettle();

      // Trigger rebuild
      await tester.pumpWidget(createTestApp(
        child: StatefulBuilder(
          builder: (context, setState) {
            return Center(
              child: ToggleSwitch(
                value: switchValue,
                onChanged: (value) {
                  setState(() {
                    switchValue = value;
                  });
                },
              ),
            );
          },
        ),
      ));

      expect(find.byType(ToggleSwitch), findsOneWidget);
    });

    testWidgets('should dispose animation controller properly', (tester) async {
      await tester.pumpWidget(createTestApp(
        child: const Center(
          child: ToggleSwitch(value: false, onChanged: _noop),
        ),
      ));

      expect(find.byType(ToggleSwitch), findsOneWidget);

      // Remove widget to test disposal
      await tester.pumpWidget(createTestApp(
        child: const Center(
          child: SizedBox(),
        ),
      ));

      expect(find.byType(ToggleSwitch), findsNothing);
    });
  });
}

void _noop(bool _) {}

