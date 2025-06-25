import 'package:flutter/material.dart';
import '../UserInterface/ui.dart';

ButtonStyle dialogButtonStyle (double colorScalar) {
  return ElevatedButton.styleFrom(
    elevation: (colorScalar) * 14.0,
    backgroundColor: ui.colors.dialogBtnColor(colorScalar),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  );
}

class DialogButtonText extends StatelessWidget {
  const DialogButtonText({super.key,
    this.color = Colors.lightBlue, 
    required this.dispText, 
    required this.scalar
  });

  final String dispText;
  final double scalar;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(dispText,
      style: TextStyle(
        fontSize: 19,
        color: ui.colors.alphaColor(
          scalar,
          color
        ),
        fontWeight: FontWeight.w500,
      ),
    );
    }
}