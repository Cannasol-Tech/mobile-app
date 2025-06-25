import '../../UserInterface/ui.dart';
import '../icons/arrows.dart';
import 'package:flutter/material.dart';
import '../system_elements/system_element.dart';


abstract class SystemDisplay extends StatelessWidget {
  const SystemDisplay({super.key, });

  abstract final ArrowButton leftArrow;
  abstract final ArrowButton rightArrow;
  abstract final SystemElement systemElement;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: [
          ShowSysElement(
            systemElement: systemElement,
            leftArrow: leftArrow,
            rightArrow: rightArrow
          ),
        ]
      ),
    );
  }
}

class ArrowButtonsRow extends StatelessWidget {
  const ArrowButtonsRow({super.key, 
      required this.left,
      required this.right,
  });
  final ArrowButton left, right;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        left,
        Expanded(child: Container()),
        right,
      ],
    );
  }
}

class ShowSysElement extends StatelessWidget {
  const ShowSysElement({
    super.key,
    required this.systemElement,
    required this.leftArrow,
    required this.rightArrow,
  });

  final SystemElement systemElement;
  final ArrowButton leftArrow, rightArrow;
  @override
  Widget build(BuildContext context) {
    UI ui = userInterface(context);
      return ui.size.orientation == Orientation.portrait ? 
        Stack(
          children: [
            Stack(
              children: [
                Container(
                  alignment: Alignment.center,
                  constraints: BoxConstraints(
                    maxWidth: ui.size.displayWidth,
                    maxHeight: ui.size.displayHeight-200
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      systemElement.image,
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  constraints: BoxConstraints(
                    maxWidth: ui.size.displayWidth,
                    maxHeight: ui.size.displayHeight-200
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: systemElement.alarmMessages
                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.center,
              constraints: BoxConstraints(
                maxWidth: ui.size.displayWidth,
                maxHeight: ui.size.displayHeight*0.77
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Container()),
                  systemElement.sensorDisplay
                ],
              ),
            ),
            Container(
              constraints: BoxConstraints(
                maxWidth: ui.size.displayWidth,
                maxHeight: ui.size.displayHeight
              ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ArrowButtonsRow(left: leftArrow, right: rightArrow),
              ],
            ),
          ),
        ]
      ) :
      Column(children: [
        systemElement.image,
        systemElement.sensorDisplay,
      ],
    );
  }
}
