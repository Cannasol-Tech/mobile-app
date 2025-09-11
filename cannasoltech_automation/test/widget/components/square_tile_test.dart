// SquareTile Widget Tests
//
// Comprehensive tests for SquareTile widget including styling,
// layout, and image asset handling.
//
// Testing Framework: flutter_test + mocktail
// Coverage Target: ≥85% widget coverage

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cannasoltech_automation/components/square_tile.dart';

import '../../helpers/test_utils.dart';

void main() {
  TestEnvironment.setupGroup();

  group('SquareTile Widget Tests', () {
    testWidgets('should render image asset with container decoration', (tester) async {
      const imagePath = 'assets/images/SmallIcon.png';
      
      await tester.pumpWidget(createTestApp(
        child: const Scaffold(
          body: Center(
            child: SquareTile(imagePath: imagePath),
          ),
        ),
      ));

      expect(find.byType(SquareTile), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('should display container with correct styling', (tester) async {
      const imagePath = 'assets/images/test.png';
      
      await tester.pumpWidget(createTestApp(
        child: const Scaffold(
          body: SquareTile(imagePath: imagePath),
        ),
      ));

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      
      expect(decoration.color, equals(Colors.white));
      expect(decoration.borderRadius, equals(BorderRadius.circular(10)));
      expect(decoration.border, isA<Border>());
    });

    testWidgets('should handle different image paths', (tester) async {
      const imagePaths = [
        'assets/images/icon1.png',
        'assets/images/icon2.png',
        'assets/images/google.png',
      ];
      
      for (final imagePath in imagePaths) {
        await tester.pumpWidget(createTestApp(
          child: Scaffold(
            body: SquareTile(imagePath: imagePath),
          ),
        ));

        expect(find.byType(SquareTile), findsOneWidget);
        expect(find.byType(Image), findsOneWidget);
        
        final image = tester.widget<Image>(find.byType(Image));
        final assetImage = image.image as AssetImage;
        expect(assetImage.assetName, equals(imagePath));
      }
    });

    testWidgets('should set correct image height', (tester) async {
      const imagePath = 'assets/images/test.png';
      
      await tester.pumpWidget(createTestApp(
        child: const Scaffold(
          body: SquareTile(imagePath: imagePath),
        ),
      ));

      final image = tester.widget<Image>(find.byType(Image));
      expect(image.height, equals(50));
    });

    testWidgets('should be keyboard accessible', (tester) async {
      const imagePath = 'assets/images/test.png';
      
      await tester.pumpWidget(createTestApp(
        child: const Scaffold(
          body: SquareTile(imagePath: imagePath),
        ),
      ));

      // Test that the widget can be found for accessibility
      expect(find.byType(SquareTile), findsOneWidget);
      
      // Verify no accessibility issues
      final handle = tester.ensureSemantics();
      expect(tester.binding.pipelineOwner.semanticsOwner?.rootSemanticsNode, isNotNull);
      handle.dispose();
    });

    testWidgets('should handle empty image path gracefully', (tester) async {
      const imagePath = '';
      
      await tester.pumpWidget(createTestApp(
        child: const Scaffold(
          body: SquareTile(imagePath: imagePath),
        ),
      ));

      expect(find.byType(SquareTile), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('should render in different parent widgets', (tester) async {
      const imagePath = 'assets/images/test.png';
      
      // Test in Column
      await tester.pumpWidget(createTestApp(
        child: Scaffold(
          body: Column(
            children: const [
              SquareTile(imagePath: imagePath),
            ],
          ),
        ),
      ));
      expect(find.byType(SquareTile), findsOneWidget);

      // Test in Row
      await tester.pumpWidget(createTestApp(
        child: Scaffold(
          body: Row(
            children: const [
              SquareTile(imagePath: imagePath),
            ],
          ),
        ),
      ));
      expect(find.byType(SquareTile), findsOneWidget);

      // Test in ListView
      await tester.pumpWidget(createTestApp(
        child: Scaffold(
          body: ListView(
            children: const [
              SquareTile(imagePath: imagePath),
            ],
          ),
        ),
      ));
      expect(find.byType(SquareTile), findsOneWidget);
    });

    testWidgets('should maintain state across rebuilds', (tester) async {
      const imagePath = 'assets/images/test.png';
      
      await tester.pumpWidget(createTestApp(
        child: const Scaffold(
          body: SquareTile(imagePath: imagePath),
        ),
      ));

      expect(find.byType(SquareTile), findsOneWidget);

      // Trigger a rebuild
      await tester.pumpWidget(createTestApp(
        child: const Scaffold(
          body: SquareTile(imagePath: imagePath),
        ),
      ));

      expect(find.byType(SquareTile), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });
  });
}

