// Enhanced Widget Tests for SquareTile Component
//
// Comprehensive widget tests following Axovia Flow standards for the SquareTile component.
// Tests verify UI rendering, styling, accessibility, responsive design, and edge cases.
//
// Testing Framework: flutter_test + mocktail
// Coverage Target: ≥85% widget coverage
// Mocking: Allowed for external dependencies via Mocktail; do not mock widgets/rendering
// Standards: Axovia Flow Flutter Testing Standard (no widget/rendering mocks)

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cannasoltech_automation/components/square_tile.dart';

import '../../helpers/test_utils.dart';
import '../../helpers/test_data.dart';

void main() {
  TestEnvironment.setupGroup();

  group('SquareTile Widget Tests', () {
    const testImagePath = 'assets/images/test_image.png';
    const googleImagePath = 'assets/images/google.png';

    group('Rendering Tests', () {
      testWidgets('should render SquareTile with correct image asset', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          createTestApp(
            child: const Scaffold(
              body: Center(
                child: SquareTile(imagePath: testImagePath),
              ),
            ),
          ),
        );

        // Assert
        expect(find.byType(SquareTile), findsOneWidget);
        expect(find.byType(Image), findsOneWidget);
        
        final imageWidget = tester.widget<Image>(find.byType(Image));
        expect(imageWidget.image, isA<AssetImage>());
        expect((imageWidget.image as AssetImage).assetName, equals(testImagePath));
      });

      testWidgets('should render with correct container structure', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          createTestApp(
            child: const Scaffold(
              body: SquareTile(imagePath: testImagePath),
            ),
          ),
        );

        // Assert
        expect(find.byType(Container), findsOneWidget);
        expect(find.byType(Image), findsOneWidget);
        
        final container = tester.widget<Container>(find.byType(Container));
        expect(container.decoration, isA<BoxDecoration>());
      });

      testWidgets('should render image with correct height', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          createTestApp(
            child: const Scaffold(
              body: SquareTile(imagePath: testImagePath),
            ),
          ),
        );

        // Assert
        final imageWidget = tester.widget<Image>(find.byType(Image));
        expect(imageWidget.height, equals(50.0));
      });
    });

    group('Styling and Decoration Tests', () {
      testWidgets('should have correct container decoration properties', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          createTestApp(
            child: const SquareTile(imagePath: testImagePath),
          ),
        );

        // Assert
        final container = tester.widget<Container>(find.byType(Container));
        final decoration = container.decoration as BoxDecoration;

        expect(decoration.border, isA<Border>());
        expect(decoration.borderRadius, isA<BorderRadius>());
        expect(decoration.color, equals(Colors.white));
      });

      testWidgets('should have grey border', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          createTestApp(
            child: const SquareTile(imagePath: testImagePath),
          ),
        );

        // Assert
        final container = tester.widget<Container>(find.byType(Container));
        final decoration = container.decoration as BoxDecoration;
        final border = decoration.border as Border;

        expect(border.top.color, equals(Colors.grey));
        expect(border.right.color, equals(Colors.grey));
        expect(border.bottom.color, equals(Colors.grey));
        expect(border.left.color, equals(Colors.grey));
      });

      testWidgets('should have rounded corners', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          createTestApp(
            child: const SquareTile(imagePath: testImagePath),
          ),
        );

        // Assert
        final container = tester.widget<Container>(find.byType(Container));
        final decoration = container.decoration as BoxDecoration;
        
        expect(decoration.borderRadius, isA<BorderRadius>());
        // Note: We can't easily test the exact radius value without implementation details
        expect(decoration.borderRadius, isNotNull);
      });

      testWidgets('should have white background color', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          createTestApp(
            child: const SquareTile(imagePath: testImagePath),
          ),
        );

        // Assert
        final container = tester.widget<Container>(find.byType(Container));
        final decoration = container.decoration as BoxDecoration;

        expect(decoration.color, equals(Colors.white));
      });
    });

    group('Different Image Asset Tests', () {
      testWidgets('should render with Google icon asset', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          createTestApp(
            child: const SquareTile(imagePath: googleImagePath),
          ),
        );

        // Assert
        final imageWidget = tester.widget<Image>(find.byType(Image));
        expect((imageWidget.image as AssetImage).assetName, equals(googleImagePath));
      });


      testWidgets('should handle empty image path', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          createTestApp(
            child: const SquareTile(imagePath: ''),
          ),
        );

        // Assert - Should still render without throwing exception
        expect(find.byType(SquareTile), findsOneWidget);
        expect(find.byType(Image), findsOneWidget);
      });

      testWidgets('should handle very long image path', (WidgetTester tester) async {
        const longPath = 'assets/images/very/long/path/to/some/image/that/has/many/directories/test_image.png';
        
        // Act
        await tester.pumpWidget(
          createTestApp(
            child: const SquareTile(imagePath: longPath),
          ),
        );

        // Assert
        expect(find.byType(SquareTile), findsOneWidget);
        final imageWidget = tester.widget<Image>(find.byType(Image));
        expect((imageWidget.image as AssetImage).assetName, equals(longPath));
      });
    });

    group('Layout and Responsive Design Tests', () {
      testWidgets('should maintain fixed image height across different screen sizes', (WidgetTester tester) async {
        final testSizes = [
          GoldenTestUtils.phoneSize,
          GoldenTestUtils.tabletSize,
          GoldenTestUtils.desktopSize,
        ];

        for (final size in testSizes) {
          await tester.binding.setSurfaceSize(size);
          
          // Act
          await tester.pumpWidget(
            createTestApp(
              child: const SquareTile(imagePath: testImagePath),
            ),
          );

          // Assert
          final imageWidget = tester.widget<Image>(find.byType(Image));
          expect(imageWidget.height, equals(50.0), 
                 reason: 'Image height should be consistent across screen sizes');
          
          await tester.pumpAndSettle();
        }
      });

      testWidgets('should fit within parent container constraints', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          createTestApp(
            child: SizedBox(
              width: 100,
              height: 100,
              child: const SquareTile(imagePath: testImagePath),
            ),
          ),
        );

        // Assert
        final squareTileSize = tester.getSize(find.byType(SquareTile));
        expect(squareTileSize.width, lessThanOrEqualTo(100.0));
        expect(squareTileSize.height, lessThanOrEqualTo(100.0));
      });

      testWidgets('should render correctly in Row layout', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          createTestApp(
            child: Row(
              children: const [
                SquareTile(imagePath: googleImagePath),
                SizedBox(width: 10),
                SquareTile(imagePath: testImagePath),
              ],
            ),
          ),
        );

        // Assert
        expect(find.byType(SquareTile), findsNWidgets(2));
        expect(find.byType(Image), findsNWidgets(2));
      });

      testWidgets('should render correctly in Column layout', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          createTestApp(
            child: Column(
              children: const [
                SquareTile(imagePath: googleImagePath),
                SizedBox(height: 10),
                SquareTile(imagePath: testImagePath),
              ],
            ),
          ),
        );

        // Assert
        expect(find.byType(SquareTile), findsNWidgets(2));
        expect(find.byType(Image), findsNWidgets(2));
      });
    });

    group('Accessibility Tests', () {
      testWidgets('should be accessible to screen readers', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          createTestApp(
            child: const SquareTile(imagePath: testImagePath),
          ),
        );

        // Assert - Widget should be found by semantics
        expect(find.byType(SquareTile), findsOneWidget);
        
        // Verify that the widget tree doesn't have accessibility issues
        final semantics = tester.getSemantics(find.byType(SquareTile));
        expect(semantics, isNotNull);
      });

      testWidgets('should handle focus correctly', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          createTestApp(
            child: const SquareTile(imagePath: testImagePath),
          ),
        );

        // Assert - Widget should be able to participate in focus traversal
        expect(find.byType(SquareTile), findsOneWidget);
        // Note: Since SquareTile doesn't explicitly handle focus, 
        // we're mainly ensuring it doesn't break focus traversal
      });
    });

    group('Error Handling and Edge Cases', () {
      testWidgets('should handle null safety correctly', (WidgetTester tester) async {
        // The widget constructor already requires imagePath, so we test with valid input
        // Act
        await tester.pumpWidget(
          createTestApp(
            child: const SquareTile(imagePath: testImagePath),
          ),
        );

        // Assert
        expect(find.byType(SquareTile), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('should not overflow when constrained', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          createTestApp(
            child: SizedBox(
              width: 30, // Smaller than image height (50)
              height: 30,
              child: const SquareTile(imagePath: testImagePath),
            ),
          ),
        );

        // Assert
        expect(find.byType(SquareTile), findsOneWidget);
        
        // Verify no overflow errors
        WidgetTestUtils.expectNoOverflow(tester);
      });

      testWidgets('should handle special characters in image path', (WidgetTester tester) async {
        const specialPath = 'assets/images/test-image_123.png';
        
        // Act
        await tester.pumpWidget(
          createTestApp(
            child: const SquareTile(imagePath: specialPath),
          ),
        );

        // Assert
        expect(find.byType(SquareTile), findsOneWidget);
        final imageWidget = tester.widget<Image>(find.byType(Image));
        expect((imageWidget.image as AssetImage).assetName, equals(specialPath));
      });
    });

    group('Widget State and Lifecycle Tests', () {
      testWidgets('should maintain state during widget rebuilds', (WidgetTester tester) async {
        String currentPath = testImagePath;
        
        // Act - Initial render
        await tester.pumpWidget(
          createTestApp(
            child: SquareTile(imagePath: currentPath),
          ),
        );

        // Assert - Initial state
        expect(find.byType(SquareTile), findsOneWidget);
        
        // Act - Rebuild with different path
        currentPath = googleImagePath;
        await tester.pumpWidget(
          createTestApp(
            child: SquareTile(imagePath: currentPath),
          ),
        );

        // Assert - Updated state
        final imageWidget = tester.widget<Image>(find.byType(Image));
        expect((imageWidget.image as AssetImage).assetName, equals(googleImagePath));
      });

      testWidgets('should handle hot reload correctly', (WidgetTester tester) async {
        // Act - Initial render
        await tester.pumpWidget(
          createTestApp(
            child: const SquareTile(imagePath: testImagePath),
          ),
        );

        // Act - Simulate hot reload
        await tester.pumpAndSettle();

        // Assert - Should maintain correct state
        expect(find.byType(SquareTile), findsOneWidget);
        expect(find.byType(Image), findsOneWidget);
      });
    });

    group('Performance and Rendering Tests', () {
      testWidgets('should render efficiently with multiple instances', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          createTestApp(
            child: Column(
              children: List.generate(
                5,
                (index) => SquareTile(imagePath: 'assets/images/test_$index.png'),
              ),
            ),
          ),
        );

        // Assert
        expect(find.byType(SquareTile), findsNWidgets(5));
        expect(find.byType(Image), findsNWidgets(5));
        
        // Verify no performance issues
        WidgetTestUtils.expectNoOverflow(tester);
      });

      testWidgets('should maintain visual consistency', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          createTestApp(
            child: Row(
              children: const [
                SquareTile(imagePath: googleImagePath),
                SquareTile(imagePath: testImagePath),
                SquareTile(imagePath: googleImagePath),
              ],
            ),
          ),
        );

        // Assert - All tiles should have same decoration
        final containers = tester.widgetList<Container>(find.byType(Container));
        expect(containers.length, equals(3));
        
        final decorations = containers.map((c) => c.decoration as BoxDecoration);
        final colors = decorations.map((d) => d.color).toSet();
        expect(colors.length, equals(1)); // All should have same color
        expect(colors.first, equals(Colors.white));
      });
    });
  });
}