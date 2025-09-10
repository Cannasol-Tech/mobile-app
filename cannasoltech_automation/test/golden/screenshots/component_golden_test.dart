/**
 * @file component_golden_test.dart
 * @author Assistant
 * @date 2025-01-05
 * @brief Golden tests for UI components visual regression testing
 * @details Tests visual consistency of key UI components across different
 *          states, themes, and screen sizes using golden file comparison
 * @version 1.0
 * @since 1.0
 */

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cannasoltech_automation/components/square_tile.dart';
import 'package:cannasoltech_automation/components/toggle_switch.dart';
import 'package:cannasoltech_automation/components/title_text.dart';
import 'package:cannasoltech_automation/components/sign_out_button.dart';

import '../../helpers/test_utils.dart';

void main() {
  // Only run golden tests when explicitly enabled
  const enableGoldenTests = bool.fromEnvironment('ENABLE_GOLDEN_TESTS', defaultValue: false);
  
  group('Component Golden Tests', () {
    testWidgets('SquareTile golden test - default state', (tester) async {
      if (!enableGoldenTests) return;

      await tester.pumpWidget(createTestApp(
        child: const Scaffold(
          body: Center(
            child: SquareTile(imagePath: 'assets/images/SmallIcon.png'),
          ),
        ),
      ));

      await expectLater(
        find.byType(SquareTile),
        matchesGoldenFile('golden/square_tile_default.png'),
      );
    });

    testWidgets('ToggleSwitch golden test - off state', (tester) async {
      if (!enableGoldenTests) return;

      await tester.pumpWidget(createTestApp(
        child: Scaffold(
          body: Center(
            child: ToggleSwitch(
              value: false,
              onChanged: (_) {},
            ),
          ),
        ),
      ));

      await expectLater(
        find.byType(ToggleSwitch),
        matchesGoldenFile('golden/toggle_switch_off.png'),
      );
    });

    testWidgets('ToggleSwitch golden test - on state', (tester) async {
      if (!enableGoldenTests) return;

      await tester.pumpWidget(createTestApp(
        child: Scaffold(
          body: Center(
            child: ToggleSwitch(
              value: true,
              onChanged: (_) {},
            ),
          ),
        ),
      ));

      // Allow animation to complete
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(ToggleSwitch),
        matchesGoldenFile('golden/toggle_switch_on.png'),
      );
    });

    testWidgets('TitleText golden test - default style', (tester) async {
      if (!enableGoldenTests) return;

      await tester.pumpWidget(createTestApp(
        child: const Scaffold(
          body: Center(
            child: TitleText(title: 'Test Title'),
          ),
        ),
      ));

      await expectLater(
        find.byType(TitleText),
        matchesGoldenFile('golden/title_text_default.png'),
      );
    });

    testWidgets('SignOutButton golden test - default state', (tester) async {
      if (!enableGoldenTests) return;

      await tester.pumpWidget(createTestApp(
        child: Scaffold(
          body: Center(
            child: SignOutButton(onTap: () {}),
          ),
        ),
      ));

      await expectLater(
        find.byType(SignOutButton),
        matchesGoldenFile('golden/sign_out_button_default.png'),
      );
    });

    testWidgets('Components in different themes', (tester) async {
      if (!enableGoldenTests) return;

      // Test components in dark theme
      await tester.pumpWidget(createTestApp(
        theme: ThemeData.dark(),
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SquareTile(imagePath: 'assets/images/SmallIcon.png'),
              ToggleSwitch(value: false, onChanged: (_) {}),
              const TitleText(title: 'Dark Theme Test'),
              SignOutButton(onTap: () {}),
            ],
          ),
        ),
      ));

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('golden/components_dark_theme.png'),
      );

      // Test components in light theme
      await tester.pumpWidget(createTestApp(
        theme: ThemeData.light(),
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SquareTile(imagePath: 'assets/images/SmallIcon.png'),
              ToggleSwitch(value: true, onChanged: (_) {}),
              const TitleText(title: 'Light Theme Test'),
              SignOutButton(onTap: () {}),
            ],
          ),
        ),
      ));

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('golden/components_light_theme.png'),
      );
    });

    testWidgets('Components in RTL layout', (tester) async {
      if (!enableGoldenTests) return;

      await tester.pumpWidget(createTestApp(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SquareTile(imagePath: 'assets/images/SmallIcon.png'),
              ToggleSwitch(value: true, onChanged: (_) {}),
              const TitleText(title: 'RTL Layout Test'),
              SignOutButton(onTap: () {}),
            ],
          ),
        ),
      ));

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('golden/components_rtl_layout.png'),
      );
    });

    testWidgets('Components at different screen sizes', (tester) async {
      if (!enableGoldenTests) return;

      final widget = createTestApp(
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SquareTile(imagePath: 'assets/images/SmallIcon.png'),
              ToggleSwitch(value: false, onChanged: (_) {}),
              const TitleText(title: 'Screen Size Test'),
            ],
          ),
        ),
      );

      // Test phone size
      await tester.binding.setSurfaceSize(const Size(375, 667));
      await tester.pumpWidget(widget);
      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('golden/components_phone_size.png'),
      );

      // Test tablet size
      await tester.binding.setSurfaceSize(const Size(768, 1024));
      await tester.pumpWidget(widget);
      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('golden/components_tablet_size.png'),
      );
    });

    testWidgets('Component state variations', (tester) async {
      if (!enableGoldenTests) return;

      // Test ToggleSwitch in various states
      await tester.pumpWidget(createTestApp(
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ToggleSwitch(value: false, onChanged: (_) {}),
              ToggleSwitch(value: true, onChanged: (_) {}),
            ],
          ),
        ),
      ));

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('golden/toggle_switch_states.png'),
      );
    });

    testWidgets('Component layout variations', (tester) async {
      if (!enableGoldenTests) return;

      // Test components in different layouts
      await tester.pumpWidget(createTestApp(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Row layout
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SquareTile(imagePath: 'assets/images/SmallIcon.png'),
                    ToggleSwitch(value: true, onChanged: (_) {}),
                  ],
                ),
                const SizedBox(height: 32),
                // Column layout
                const Column(
                  children: [
                    TitleText(title: 'Column Layout'),
                    SizedBox(height: 16),
                    SquareTile(imagePath: 'assets/images/SmallIcon.png'),
                  ],
                ),
                const SizedBox(height: 32),
                // Center alignment
                Center(
                  child: SignOutButton(onTap: () {}),
                ),
              ],
            ),
          ),
        ),
      ));

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('golden/component_layouts.png'),
      );
    });
  }, skip: !enableGoldenTests ? 'Golden tests disabled' : null);
}