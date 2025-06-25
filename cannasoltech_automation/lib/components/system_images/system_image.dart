// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:simple_animations/simple_animations.dart';
import '../../providers/system_data_provider.dart';
import '../../handlers/alarm_handler.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../../providers/inline.dart';
import '../../shared/constants.dart';
import '../../UserInterface/ui.dart';


abstract class SystemImage extends StatelessWidget {
  const SystemImage({super.key});
  
  // Abstract members that each subclass must provide
  abstract final String path;
  abstract final double aspectRatio;
  abstract final bool Function(AlarmsModel) alarmActive;
  

  @override 
  Widget build(BuildContext context) {
    // Trigger alarm flash, if needed.
    UI ui = userInterface(context);
    double imageHeight;
    double imageWidth;

    if (ui.isPortrait == true) {
      imageHeight = ui.size.displayHeight/2.5;
      imageWidth = ui.size.displayWidth/2;
    }
    else {
      imageHeight = ui.size.displayHeight/2.5;
      imageWidth = ui.size.displayWidth/4;
    }

    sMdB.alarmFlash(context);

    return Selector<SystemDataModel, ({bool active, int state})>(
      selector: (_, model) => (
        active: alarmActive(model.activeDevice?.alarms ?? AlarmsModel()),
        state: model.activeDevice?.state.state ?? INIT
      ),
      builder: (_, data, __) {
        Color colorStart, colorEnd;
        final int state = data.state;
        final bool active = data.active;

        switch (state) {
          case WARM_UP:
            colorStart = const Color.fromARGB(255, 255, 124, 124).withOpacity(0.01);
            colorEnd = const Color.fromARGB(255, 255, 50, 50).withOpacity(0.1);
            break;
          case ALARM:
            if (active) {
              colorStart = const Color.fromARGB(0, 255, 0, 0).withOpacity(0.0);
              colorEnd = const Color.fromARGB(255, 255, 0, 0).withOpacity(0.6);
            } else {
              colorStart = Colors.white.withOpacity(0.01);
              colorEnd = Colors.white.withOpacity(0.12);
            }
            break;
          case COOL_DOWN:
            colorStart = const Color.fromARGB(255, 80, 184, 232).withOpacity(0.2);
            colorEnd = const Color.fromARGB(255, 75, 190, 243).withOpacity(0.55);
            break;
          default:
            colorStart = Colors.white.withOpacity(0.01);
            colorEnd = Colors.white.withOpacity(0.12);
        }

        return SizedBox(
          width: imageWidth,
          height: imageHeight,
          child: FittedBox(
            fit: BoxFit.contain, // Ensures the entire image fits in the box
            child: imageWithAnimation(aspectRatio, colorStart, colorEnd),
          ),
        );
      },
    );
  }

  MirrorAnimationBuilder<Color?> imageWithAnimation(aspectRatio, colorStart, colorEnd) {
    return MirrorAnimationBuilder(
      tween: ColorTween(begin: colorStart, end: colorEnd),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInSine,
      builder: (BuildContext context, Color? color, Widget? child) {
        return fadeFilteredImage(aspectRatio, color);
      }
    );
  }

  Widget imageWithoutAnimation(aspectRatio) {
    return systemImage(aspectRatio);
  }

  Widget systemImage(aspectRatio) {
    return Image.asset(
        path,
        fit: BoxFit.cover,
      );
  }

  ColorFilter fadeColorFilter(Color? color) {
    return ColorFilter.mode(
      color ?? Colors.transparent,
      BlendMode.srcATop
    );
  }


  ColorFiltered fadeFilteredImage(double aspectRatio, Color? color) {
    return ColorFiltered(
      colorFilter: fadeColorFilter(color),
      child: systemImage(aspectRatio),
    );
  }
}



// abstract class SystemImage extends StatelessWidget{
//   const SystemImage({super.key});
//   abstract final String path;
//   abstract final bool Function(AlarmsModel) alarmActive;
//   abstract final double aspectRatio;
  
//   @override 
//   Widget build(BuildContext context) {
//     sMdB.alarmFlash(context);
//     return Selector<SystemDataModel, ({bool active, int state})>(
//       selector: (_, m) => (
//         active: alarmActive(m.activeDevice?.alarms ?? AlarmsModel()),
//         state: m.activeDevice?.state.state ?? INIT
//       ),
//       builder: (_xX, data, Xx_) {
//       Color colorStart, colorEnd;
//       int state = data.state;
//       bool active = data.active;

//       switch (state) {
//         case WARM_UP:
//           colorStart = const Color.fromARGB(255, 255, 124, 124).withOpacity(0.01);
//           colorEnd = const Color.fromARGB(255, 255, 50, 50).withOpacity(0.1);
//         case ALARM:
//           if (active) {
//             colorStart = const Color.fromARGB(0, 255, 0, 0).withOpacity(0.0);
//             colorEnd = const Color.fromARGB(255, 255, 0, 0).withOpacity(0.6);
//           } 
//           else {
//             colorStart = Colors.white.withOpacity(0.01);
//             colorEnd = Colors.white.withOpacity(0.12);
//           }
//         case COOL_DOWN:
//           colorStart = const Color.fromARGB(255, 80, 184, 232).withOpacity(0.2);
//           colorEnd = const Color.fromARGB(255, 75, 190, 243).withOpacity(0.55);        
//         default:
//           colorStart = Colors.white.withOpacity(0.01);
//           colorEnd = Colors.white.withOpacity(0.12);
//       }
//       UI ui = userInterface(context);
//       return Container(
//         constraints: BoxConstraints.loose(Size(
//           ui.size.sysImageWidth, ui.size.sysImageHeight
//         )),
//         child: imageWithAnimation(aspectRatio, colorStart, colorEnd) 
//       );
//       }
//     );
//   }
  
  // MirrorAnimationBuilder<Color?> imageWithAnimation(aspectRatio, colorStart, colorEnd) {
  //   return MirrorAnimationBuilder(
  //     tween: ColorTween(begin: colorStart, end: colorEnd),
  //     duration: const Duration(milliseconds: 1000),
  //     curve: Curves.easeInSine,
  //     builder: (BuildContext context, Color? color, Widget? child) {
  //       return fadeFilteredImage(aspectRatio, color);
  //     }
  //   );
  // }

  // Widget imageWithoutAnimation(aspectRatio) {
  //   return systemImage(aspectRatio);
  // }

  // Widget systemImage(aspectRatio) {
  //   return Image.asset(
  //       path,
  //       fit: BoxFit.cover,
  //     );
  // }

  // ColorFilter fadeColorFilter(Color? color) {
  //   return ColorFilter.mode(
  //     color ?? Colors.transparent,
  //     BlendMode.srcATop
  //   );
  // }


  // ColorFiltered fadeFilteredImage(double aspectRatio, Color? color) {
  //   return ColorFiltered(
  //     colorFilter: fadeColorFilter(color),
  //     child: systemImage(aspectRatio),
  //   );
  // }
// }

// class SysImageDisplay extends StatefulWidget {
//   const SysImageDisplay({
//     super.key,
//     required this.systemImage,
//     required this.colorStart,
//     required this.colorEnd,
//     required this.active,
//     required this.flash,
//   });

//   final SystemImage? systemImage;
//   final Color colorStart;
//   final Color colorEnd;
//   final bool active;
//   final bool flash;

//   @override
//   State<SysImageDisplay> createState() => _SysImageDisplayState();
// }

// class _SysImageDisplayState extends State<SysImageDisplay> {
  
//   bool get animate => (widget.active && widget.flash);

//   ColorTween get fadeTween => ColorTween(
//     begin: widget.colorStart,
//     end: widget.colorEnd 
//   );

//   @override
//   Widget build(BuildContext context) {
//     userInterface(context);
//     return Container(
//       // constraints: BoxConstraints.loose(Size(ui.size.displayWidth*0.7, ui.size.displayHeight*0.3)),
//       child:  animate ? imageWithAnimation() 
//                       : imageWithoutAnimation()
//     );
//   }


//   MirrorAnimationBuilder<Color?> imageWithAnimation() {
//     return MirrorAnimationBuilder(
//       tween: fadeTween,
//       duration: const Duration(milliseconds: 1000),
//       curve: Curves.easeInSine,
//       builder: (BuildContext context, Color? color, Widget? child) {
//         return fadeFilteredImage(color);
//       }
//     );
//   }

//   Widget imageWithoutAnimation() {
//     return systemImage();
//   }


//   Image systemImage() {
//     return Image.asset(
//       widget.systemImage?.path ?? '',
//       fit: BoxFit.cover,
//    );
//   }

//   ColorFilter fadeColorFilter(Color? color) {
//     return ColorFilter.mode(
//       color ?? Colors.transparent,
//       BlendMode.dstATop
//     );
//   }


//   ColorFiltered fadeFilteredImage(Color? color) {
//     return ColorFiltered(
//       colorFilter: fadeColorFilter(color),
//       child: systemImage(),
//     );
//   }
// }
