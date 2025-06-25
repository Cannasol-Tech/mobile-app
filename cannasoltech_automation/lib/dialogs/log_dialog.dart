import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:cannasoltech_automation/UserInterface/ui.dart';
import 'package:cannasoltech_automation/handlers/history_logs.dart';

import 'style.dart';

class HistoryLogDialog extends StatefulWidget {
  const HistoryLogDialog({super.key, required this.historyLog});

  final HistoryLog historyLog;

  @override
  State<HistoryLogDialog> createState() => _HistoryLogDialogState();

  void show(BuildContext context) {
      showDialog(
        context: context,
        builder: (context) {
          return HistoryLogDialog(historyLog: historyLog);
        }
      );
    } 

}

class _HistoryLogDialogState extends State<HistoryLogDialog> with AnimationMixin{
  late AnimationController scalarController;
  late Animation<double> scalar;

  final double _maxElevation = 40.0;

  get _logText => widget.historyLog.toMarkdown(); 

  @override
  void initState() {
    scalarController = createController()
    ..play(duration: const Duration(milliseconds: 1000));
    scalar = Tween(begin: 0.0, end: 1.0).animate(scalarController);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
      UI ui = userInterface(context);
      return AlertDialog(
        backgroundColor: Colors.white.withAlpha((scalar.value*225).toInt()),
        elevation: scalar.value * _maxElevation,
        icon: const Icon(Icons.info_outline, color: Colors.blueGrey),
        title: Text("System Log #${widget.historyLog.index+1}"),
        titleTextStyle: TextStyle(
          color: Colors.black.withAlpha(220),
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
          decoration: TextDecoration.underline
        ),
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: SizedBox(
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
                    data: _logText,
                    styleSheet: MarkdownStyleSheet(
                      listBulletPadding: const EdgeInsets.all(0),
                      listBullet: const TextStyle(
                        color: Colors.black,
                        fontSize: 0.0,
                        fontWeight: FontWeight.w100
                      ),
                      h1Padding: const EdgeInsets.all(20),
                      p: const TextStyle(
                        color: Colors.black,
                        fontSize: 12.0),
                      // Customize heading styles, list bullet style, etc. as needed
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          (ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ui.colors.scaleBlend(scalar.value.toInt()),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: DialogButtonText(
              dispText: 'Close', 
              scalar: scalar.value, 
              color: Colors.black45 
            ),
          )
        ) 
      ],  
    );
    
  }
  
}