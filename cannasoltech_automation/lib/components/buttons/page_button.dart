import 'package:flutter/material.dart';
import 'package:simple_animations/animation_mixin/animation_mixin.dart';
import 'package:simple_animations/simple_animations.dart';

class PageButton extends StatefulWidget {
  final Object hero;
  final Color color;
  final String buttonText;
  final Widget newPage;
  final bool pop;
  final Color shadowColor;

  const PageButton({
    super.key,
    required this.hero,
    required this.color,
    required this.buttonText,
    required this.newPage,
    required this.pop,
    this.shadowColor = Colors.grey,
  });

  @override
  _PageButtonState createState() => _PageButtonState();
}

class _PageButtonState extends State<PageButton> with AnimationMixin {
  late AnimationController scalarController;
  late Animation<double> scalar;

  @override
  void initState() {
    scalarController = createController()
      ..play(duration: const Duration(milliseconds: 100));
    scalar = Tween<double>(begin: 0.0, end: 1.0).animate(scalarController);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        shadowColor: widget.shadowColor.withAlpha((100 + 80 * scalar.value).toInt()),
        foregroundColor: Colors.black,
        backgroundColor: widget.color,
        elevation: 20 - 10 * scalar.value,
        animationDuration: const Duration(seconds: 1),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          widget.buttonText,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      onPressed: () {
        if (widget.pop) {
          Navigator.of(context).pop();
        }
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => widget.newPage),
        );
      },
    );
  }
}
