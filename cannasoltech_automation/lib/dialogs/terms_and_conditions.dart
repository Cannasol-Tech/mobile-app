/**
 * @file terms_and_conditions.dart
 * @author Stephen Boyett
 * @date 2025-09-06
 * @brief Terms and Conditions dialog with acceptance functionality.
 * @details Provides Terms and Conditions display dialog with markdown content,
 *          user acceptance tracking, and animated UI elements.
 * @version 1.0
 * @since 1.0
 */

// ignore_for_file: library_private_types_in_public_api
import 'package:simple_animations/simple_animations.dart';

import '../UserInterface/ui.dart';
import '../pages/home/home_page.dart';
import '../shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/system_data_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_markdown/flutter_markdown.dart';

import 'style.dart';

/**
 * @brief Terms and Conditions dialog widget.
 * @details Stateful widget that displays Terms and Conditions with markdown
 *          content and handles user acceptance with state management.
 * @since 1.0
 */
class TaCDialog extends StatefulWidget {
  /**
   * @brief Creates a TaCDialog widget.
   * @param key Optional widget key for identification
   * @param needsAccept Whether user acceptance is required (default: true)
   */
  const TaCDialog({super.key, this.needsAccept=true});

  /**
   * @brief Creates the state for TaCDialog widget.
   * @return _TaCDialogState instance
   */
  @override
  State<TaCDialog> createState() => _TaCDialogState();

  /// Flag indicating whether user acceptance is required
  final bool needsAccept;

}

class _TaCDialogState extends State<TaCDialog> with AnimationMixin{
  String _TaCText = 'Loading Terms & Conditions';
  late AnimationController scalarController;

  late Animation<double> scalar;
  late Animation<Color?> color;

  final double _maxElevation = 40.0;

  bool _chkAccepted = false;

  @override
  void initState() {
    scalarController = createController()
    ..play(duration: const Duration(milliseconds: 1000));
    scalar = Tween(begin: 0.0, end: 1.0).animate(scalarController);
    _loadTermsAndConditions();
    super.initState();
  }

  Future<String> _loadTermsAndConditions() async {
    try {
      const CircularProgressIndicator();
      String tempText = await rootBundle.loadString(TAC_PATH);
      setState(() => _TaCText = tempText);
    } catch (e) {
      debugPrint('Error loading T&C file: $e');
      // Optionally set a fallback text
    }
    return 'Unable to load Terms & Conditions.';
  }

  @override
  Widget build(BuildContext context) {
      UI ui = userInterface(context);
      return AlertDialog(
        backgroundColor: ui.colors.alphaWhite((scalar.value*255).toInt()),
        elevation: scalar.value * _maxElevation,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Terms & Conditions',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content: SizedBox(
        // width: MediaQuery.of(context).size.width * 0.9,
        // height: MediaQuery.of(context).size.height * 0.6,
          width: (scalar.value) * ui.size.displayWidth * 0.9,
          height:  (scalar.value) * ui.size.displayHeight * 0.6,
          child: Column(
            children: [
              Expanded(
                child: Scrollbar(
                  thumbVisibility: true,
                  thickness: 4.0,
                  radius: const Radius.circular(10.0),
                  child: Markdown(
                    data: _TaCText,
                    styleSheet: MarkdownStyleSheet(
                      listBulletPadding: const EdgeInsets.all(0),
                      listBullet: const TextStyle(
                        color: Colors.black,
                        fontSize: 10.0,
                        fontWeight: FontWeight.w400
                      ),
                      h1Padding: const EdgeInsets.all(20),
                      p: const TextStyle(
                        color: Colors.black,
                        fontSize: 10.0),
                      // Customize heading styles, list bullet style, etc. as needed
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              widget.needsAccept ? Row(
                children: [
                  Checkbox(
                    value: _chkAccepted,
                    onChanged: (value) {
                        setState(() => _chkAccepted = value ?? false);
                      }
                  ),
                  const Expanded(
                    child: Text(
                      'I accept the Terms and Conditions.',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ) : const SizedBox.shrink(),
            ],
          ),
        ),
        actions: [
          widget.needsAccept ? (ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ui.colors.scaleBlend(scalar.value.toInt()),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              if (_chkAccepted) {
                context.read<SystemDataModel>().userHandler.acceptTaC();
                scalarController.playReverse(duration: const Duration(milliseconds:  300))
                .then((_) {
                  Navigator.of(context).popUntil(ModalRoute.withName('/'));
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const HomePage()
                  ));
                });
              }
              else {null;}
            } ,
            child: DialogButtonText(
              dispText: 'Continue', 
              scalar: scalar.value, 
              color: _chkAccepted ? Colors.lightBlue : Colors.grey 
            ),
          )
        ) : 
        ElevatedButton(
          style: dialogButtonStyle(scalar.value),
          onPressed: () {
            context.read<SystemDataModel>().userHandler.acceptTaC();
            scalarController.playReverse(duration: const Duration(milliseconds:  300))
            .then((_) {
              Navigator.of(context).popUntil(ModalRoute.withName('/'));
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const HomePage()
              ) );
            });
          },
          child: DialogButtonText(dispText: 'Close', scalar: scalar.value),
        )
      ],  
          );
  }



  void showTaCDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // user must accept or close
      builder: (context) => CustomAnimationBuilder<double>(
        control: Control.mirror,
        tween: Tween(begin: 100.0, end: 200.0),
        duration: const Duration(seconds: 2),
        delay: const Duration(seconds: 1),
        curve: Curves.easeInOut,
        startPosition: 0.5,
        animationStatusListener: (status) {
          debugPrint('status updated: $status');
        },
        builder: (context, value, child) {
          return Container(
            width: value,
            height: value,
            color: Colors.blue,
            child: child,
          );
        },
        child: const Center(
            child: Text('Hello!',
                style: TextStyle(color: Colors.white, fontSize: 24))),
      ),
    );
  }

  void dismissTaC(context, ctrl1, ctrl2) {  
    null;
  }
}
