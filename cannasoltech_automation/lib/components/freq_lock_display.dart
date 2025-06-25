import 'package:flutter/material.dart';

Widget freqLockDisplay(context, freqLock, sonicAlarm) {
    String openLock = 'assets/images/padlock_open.png';
    String closedLock = 'assets/images/padlock_closed.webp';

    dynamic opacity;
    dynamic textOpacity;

    freqLock = !freqLock;

    sonicAlarm? opacity = const AlwaysStoppedAnimation(.5): opacity = const AlwaysStoppedAnimation(1.0);
    sonicAlarm? textOpacity = 100.0 : textOpacity = 255.0;  

    return Stack(
      children: <Widget>[
        Container(
          // padding: const EdgeInsets.all(2),
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: 50,
            height: 50,
            child: FittedBox(
              child: freqLock? Image.asset(closedLock, opacity: opacity) : Image.asset(openLock, opacity: opacity),
            ),
          )
        ),
        Container(
          // padding: const EdgeInsets.all(2),
          alignment: Alignment.centerLeft,
          child:  SizedBox(
            width: 50,
            height: 50,
              child: Column(
                children: <Widget> [
                  const SizedBox(height: 22.5),
                  Text('Hz',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: sonicAlarm? Color.fromRGBO(255, 255, 255, textOpacity) : Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ]
    );
  }

