import 'package:flutter/material.dart';


class RunScreenEdgeBox extends StatelessWidget {
  final Orientation orientation;
  final double screenWidth;
  final double imageWidth;

  const RunScreenEdgeBox({
    super.key,
    required this.orientation,
    required this.screenWidth,
    required this.imageWidth,
  });

  @override
  Widget build(BuildContext context) {
    if (orientation == Orientation.portrait) {
      return SizedBox(width: ((screenWidth - 150) / 2) / 2);
    } else {
      return Container(child: null);
    }
  }
}

class RunScreenBox extends StatelessWidget {
  final Orientation orientation;
  final double screenWidth;
  final double imageWidth;

  const RunScreenBox({
    super.key,
    required this.orientation,
    required this.screenWidth,
    required this.imageWidth,
  });

  @override
  Widget build(BuildContext context) {
    if (orientation == Orientation.portrait) {
      return SizedBox(width: (screenWidth - 150) / 2);
    } else {
      return Container(child: null);
    }
  }
}

class DisplaySysVal extends StatelessWidget {
  final String text;
  final String val;

  const DisplaySysVal({super.key, required this.text, required this.val});

  @override
  Widget build(BuildContext context) {
    return Text(
      '$text: $val',
      textAlign: TextAlign.left,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        fontFeatures: [FontFeature.tabularFigures()],
      )
    );
  }
}


class DisplaySysValNoColon extends StatelessWidget {
  final String displayText;
  final String displayValue;

  const DisplaySysValNoColon({super.key, required this.displayText, required this.displayValue});

  @override
  Widget build(BuildContext context) {
    return Text(
      '$displayText $displayValue',
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }
}

Widget get blankSpace => const SizedBox.shrink();

class DisplayText extends StatelessWidget {
  final String displayText;

  const DisplayText({super.key, required this.displayText});

  @override
  Widget build(BuildContext context) {
    return Text(
      displayText,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        fontFeatures: [FontFeature.tabularFigures()],
      )
    );
  }
}

