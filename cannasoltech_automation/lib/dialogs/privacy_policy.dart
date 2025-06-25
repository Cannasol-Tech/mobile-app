// ignore_for_file: library_private_types_in_public_api
import 'package:simple_animations/simple_animations.dart';

import '../UserInterface/ui.dart';
import '../pages/home/home_page.dart';
import '../shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_markdown/flutter_markdown.dart';

import 'style.dart';

class PrivacyPolicyDialog extends StatefulWidget {
  const PrivacyPolicyDialog({super.key});

  @override
  State<PrivacyPolicyDialog> createState() => _PrivacyPolicyDialogState();
}
  


class _PrivacyPolicyDialogState extends State<PrivacyPolicyDialog> 
with AnimationMixin {
  late AnimationController scalarController;
  late Animation<double> scalar;
  String _privacyText = "Loading Privacy Policy...";

  @override
  void initState() {
    super.initState();
    _loadPrivacyPolicy();
    scalarController = createController()
    ..play(duration: const Duration(milliseconds: 1000));
    scalar = Tween(begin: 0.0, end: 1000.0).animate(scalarController);
  }

  /// Loads the Terms & Conditions from a Markdown asset file.
  Future<void> _loadPrivacyPolicy() async {
    try {
      String tempText = await rootBundle.loadString(PP_PATH);
      setState(() => _privacyText = tempText);
    } catch (e) {
      debugPrint('Error loading Privacy Policy file: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    UI ui = userInterface(context);
    double colorScalar = (scalar.value/1000);
    return AlertDialog(
      backgroundColor: ui.colors.alphaColor(colorScalar, Colors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Privacy Policy',
        style: TextStyle(
          fontSize: 20, 
          fontWeight: FontWeight.bold
        ),
      ),
      content: SizedBox(
        width: colorScalar * ui.size.displayWidth * 0.9,
        height: colorScalar * ui.size.displayHeight * 0.6,
        child: Column(
          children: [
            Expanded(
              child: Scrollbar(
                thumbVisibility: true,
                thickness: 4.0,
                radius: const Radius.circular(10.0),
                child: Markdown(
                  data: _privacyText,
                  styleSheet: MarkdownStyleSheet(
                    textAlign: WrapAlignment.spaceEvenly,
                    pPadding: const EdgeInsets.fromLTRB(2, 0, 8, 0),
                    listBulletPadding: const EdgeInsets.all(0),
                    listBullet: const TextStyle(
                      color: Colors.black,
                      fontSize: 10.0,
                      fontWeight: FontWeight.w400
                    ),
                    h1Padding: const EdgeInsets.all(0),
                    h1: const TextStyle(
                      color: Colors.black,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold
                    ),
                    h2: const TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold
                    ),
                    p: const TextStyle(
                      color: Colors.black,
                      fontSize: 10.0
                    ),
                    // Customize heading styles, list bullet style, etc. as needed
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          style: dialogButtonStyle(colorScalar),
          onPressed: () {
            scalarController.playReverse(duration: const Duration(milliseconds: 250)).then( (_) {
              Navigator.of(context).popUntil(ModalRoute.withName('/'));
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomePage()));
            });
          },
          child: DialogButtonText(dispText: "close", scalar: colorScalar),
        ),
      ],
    );
  }
}
