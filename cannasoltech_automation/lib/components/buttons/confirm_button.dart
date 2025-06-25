import 'package:simple_animations/simple_animations.dart';

import '../notice_dialog.dart';
import 'package:flutter/material.dart';
import 'package:cannasoltech_automation/components/confirm_dialog.dart';
import 'package:simple_animations/animation_mixin/animation_mixin.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:flutter/material.dart';
import 'package:cannasoltech_automation/components/confirm_dialog.dart';
import '../notice_dialog.dart';
import 'package:simple_animations/animation_mixin/animation_mixin.dart';

class ConfirmButton extends StatefulWidget {
  final Color color;
  final Function confirmMethod;
  final String confirmText;
  final String buttonText;
  final Object hero;
  final Color shadowColor;

  const ConfirmButton({
    super.key,
    required this.color,
    required this.confirmMethod,
    required this.confirmText,
    required this.buttonText,
    required this.hero,
    this.shadowColor = Colors.grey,
  });

  @override
  _ConfirmButtonState createState() => _ConfirmButtonState();
}

class _ConfirmButtonState extends State<ConfirmButton> with AnimationMixin {
  late AnimationController scalarController;
  late Animation<double> scalar;

  @override
  void initState() {
    scalarController = createController()
      ..play(duration: const Duration(milliseconds: 100));
    scalar = Tween(begin: 0.0, end: 1.0).animate(scalarController);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        shadowColor:
            widget.shadowColor.withAlpha((100 + 80 * scalar.value).toInt()),
        foregroundColor: Colors.black,
        backgroundColor: widget.color,
        elevation: 20 - 10 * scalar.value,
        animationDuration: const Duration(seconds: 1),
      ),
      // Wrap the text in a FittedBox to ensure it scales down when needed.
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          widget.buttonText,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      onPressed: () {
        if (widget.confirmText.contains('null')) {
          noticeDialog(
            context,
            "No device selected!",
            "Please select a device from the drop down menu to remove.",
          );
        } else {
          confirmDialog(context, widget.confirmMethod, widget.confirmText);
        }
      },
    );
  }
}
