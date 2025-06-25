part of 'ui.dart';



class ArrowIcon extends DecoratedIcon {

  final IconData iconData; 
  final double shadowOffset; 
  final Color arrowShade;

  double get shadowOffsetHalf => shadowOffset*0.5;

  const ArrowIcon(this.iconData, {super.key, this.shadowOffset=10.0, this.arrowShade=Colors.transparent}) : super(iconData);
    @override get shadows => [
      // BoxShadow(
      //   // blurStyle: BlurStyle.solid,
      //   blurRadius: 35.0,
      //   color: arrowShade
      // ),
      BoxShadow(
        // blurStyle: BlurStyle.solid,
        blurRadius: 25.0,
        color: arrowShade
      ),
      BoxShadow(
        // blurStyle: BlurStyle.solid,
        blurRadius: 20.0,
        color: arrowShade
      ),
      BoxShadow(
        // blurStyle: BlurStyle.solid,
        blurRadius: 20.0,
        color: arrowShade
      ),
      BoxShadow(
        blurRadius: 20.0,
        color: arrowShade
      ),
      const BoxShadow(
        blurRadius: 10.0,
        color:  Color.fromARGB(255, 24, 255, 255)
      ),
      BoxShadow(
        blurRadius: 6.0,
        color: const Color.fromARGB(60, 0, 0, 200),
        offset: Offset(-shadowOffsetHalf, shadowOffsetHalf)
      ),
      BoxShadow(
        blurRadius: 6.0,
        color: const Color.fromARGB(60, 0, 0, 200),
        offset: Offset(-shadowOffsetHalf, -shadowOffsetHalf)
      ),
      BoxShadow(
        blurRadius: 6.0,
        color: const Color.fromARGB(20, 0, 0, 200),
        offset: Offset(shadowOffsetHalf, -shadowOffsetHalf)
      ),
      BoxShadow(
        blurRadius: 6.0,
        color: const Color.fromARGB(20, 0, 0, 200),
        offset: Offset(shadowOffsetHalf, shadowOffsetHalf),
      ),

    ];
    @override get size => 35.0;
}

class ArrowIcons {
  DecoratedIcon iosRight(shadowOffset) => ArrowIcon(
    Icons.arrow_forward_ios, 
    shadowOffset: shadowOffset
  );
  DecoratedIcon iosLeft(shadowOffset) => ArrowIcon(
    Icons.arrow_forward_ios,
    shadowOffset: shadowOffset
  );
  DecoratedIcon droidLeft(shadowOffset) => ArrowIcon(
    Icons.arrow_back_ios,
    shadowOffset: shadowOffset
  );
  DecoratedIcon droidRight(shadowOffset) => ArrowIcon(
    Icons.arrow_forward_ios,
    shadowOffset: shadowOffset
  );
}


class ArrowShapeBorder extends OutlinedBorder {

  final bool pointingLeft;

  const ArrowShapeBorder({
    this.pointingLeft = false,
    super.side = BorderSide.none,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final width = rect.width;
    final height = rect.height;
    final path = Path();

    if (pointingLeft) {
      // "<" style
      path.moveTo(width, 0);
      path.lineTo(0, height / 2);
      path.lineTo(width, height);
      // do NOT close the path!
    } else {
      // ">" style
      path.moveTo(0, 0);
      path.lineTo(width, height / 2);
      path.lineTo(0, height);
      // do NOT close the path!
    }

    return path;
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    // Typically return the same path if you just want an outline.
    return getOuterPath(rect, textDirection: textDirection);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    // Paint only the arrow "outline" using a stroke.
    if (side.style != BorderStyle.none) {
      final paint = side.toPaint()
        ..style = PaintingStyle.stroke;

      final path = getOuterPath(rect, textDirection: textDirection);
      canvas.drawPath(path, paint);
    }
  }

  @override
  ShapeBorder scale(double t) {
    // Scales the border’s thickness as well.
    return ArrowShapeBorder(
      pointingLeft: pointingLeft,
      side: side.scale(t),
    );
  }

  @override
  OutlinedBorder copyWith({BorderSide? side}) {
    return ArrowShapeBorder(
      pointingLeft: pointingLeft,
      side: side ?? this.side,
    );
  }
}