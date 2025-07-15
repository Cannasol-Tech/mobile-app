import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:cannasoltech_automation/components/slot_card.dart';
import 'package:cannasoltech_automation/components/buttons/confirm_button.dart';
import 'package:cannasoltech_automation/providers/system_data_provider.dart';
import 'package:cannasoltech_automation/data_models/device.dart';
import 'package:cannasoltech_automation/objects/save_slot.dart';

void main() {
  group('SlotCard Design System Tests', () {
    late SystemDataModel mockSystemData;
    late Device mockDevice;

    setUp(() {
      mockSystemData = SystemDataModel();
      mockDevice = Device(
        status: 'active',
        id: '1',
        name: 'Test Device',
        type: 'test',
        native: {},
      );
      
      // Create mock save slots
      List<SaveSlot> mockSlots = [];
      for (int i = 0; i < 5; i++) {
        mockSlots.add(SaveSlot(device: mockDevice, idx: i + 1));
      }
      mockDevice.saveSlots = mockSlots;
      mockSystemData.activeDevice = mockDevice;
    });

    testWidgets('SlotCard uses Material Design Card', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
            useMaterial3: true,
          ),
          home: ChangeNotifierProvider<SystemDataModel>(
            create: (_) => mockSystemData,
            child: Scaffold(
              body: slotCard(tester.binding.defaultBinaryMessenger, 1, "save"),
            ),
          ),
        ),
      );

      // Wait for the widget to be built
      await tester.pump();

      // Verify that a Card widget is used instead of FancyContainer
      expect(find.byType(Card), findsOneWidget);
      
      // Verify the card has proper styling
      final card = tester.widget<Card>(find.byType(Card));
      expect(card.elevation, 4.0);
      expect(card.shape, isA<RoundedRectangleBorder>());
    });

    testWidgets('SlotCard uses consistent typography', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
            useMaterial3: true,
          ),
          home: ChangeNotifierProvider<SystemDataModel>(
            create: (_) => mockSystemData,
            child: Scaffold(
              body: slotCard(tester.binding.defaultBinaryMessenger, 1, "save"),
            ),
          ),
        ),
      );

      await tester.pump();

      // Verify that the title uses the config header style
      expect(find.text('Save Slot 1'), findsOneWidget);
    });

    testWidgets('SlotCard uses theme colors', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
            useMaterial3: true,
          ),
          home: ChangeNotifierProvider<SystemDataModel>(
            create: (_) => mockSystemData,
            child: Scaffold(
              body: slotCard(tester.binding.defaultBinaryMessenger, 1, "save"),
            ),
          ),
        ),
      );

      await tester.pump();

      // Verify that the card uses theme colors instead of hardcoded colors
      final card = tester.widget<Card>(find.byType(Card));
      expect(card.color, isNotNull);
      
      // Verify no hardcoded Colors.blue or Colors.green are used
      expect(card.color, isNot(Colors.blue));
      expect(card.color, isNot(Colors.green));
    });

    testWidgets('SlotCard uses consistent spacing', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
            useMaterial3: true,
          ),
          home: ChangeNotifierProvider<SystemDataModel>(
            create: (_) => mockSystemData,
            child: Scaffold(
              body: slotCard(tester.binding.defaultBinaryMessenger, 1, "save"),
            ),
          ),
        ),
      );

      await tester.pump();

      // Verify consistent spacing between elements
      final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
      final spacingBoxes = sizedBoxes.where((box) => box.height == 24.0);
      expect(spacingBoxes.length, greaterThan(0));
    });

    testWidgets('SaveSlotCard shows Save Config button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
            useMaterial3: true,
          ),
          home: ChangeNotifierProvider<SystemDataModel>(
            create: (_) => mockSystemData,
            child: Scaffold(
              body: slotCard(tester.binding.defaultBinaryMessenger, 1, "save"),
            ),
          ),
        ),
      );

      await tester.pump();

      // Verify save button is present
      expect(find.byType(ConfirmButton), findsOneWidget);
      expect(find.text('Save Config'), findsOneWidget);
    });

    testWidgets('LoadSlotCard shows Load Config button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
            useMaterial3: true,
          ),
          home: ChangeNotifierProvider<SystemDataModel>(
            create: (_) => mockSystemData,
            child: Scaffold(
              body: slotCard(tester.binding.defaultBinaryMessenger, 1, "load"),
            ),
          ),
        ),
      );

      await tester.pump();

      // Verify load button is present
      expect(find.byType(ConfirmButton), findsOneWidget);
      expect(find.text('Load Config'), findsOneWidget);
    });

    testWidgets('SlotCard button uses theme colors', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
            useMaterial3: true,
          ),
          home: ChangeNotifierProvider<SystemDataModel>(
            create: (_) => mockSystemData,
            child: Scaffold(
              body: slotCard(tester.binding.defaultBinaryMessenger, 1, "save"),
            ),
          ),
        ),
      );

      await tester.pump();

      // Verify button uses theme colors instead of hardcoded colors
      final confirmButton = tester.widget<ConfirmButton>(find.byType(ConfirmButton));
      expect(confirmButton.color, isNotNull);
      expect(confirmButton.color, isNot(const Color.fromARGB(179, 255, 255, 255)));
    });
  });
}