import 'package:flutter/material.dart';
import '../UserInterface/ui.dart';
import '../UserInterface/text_styles.dart';

/// A unified card component that follows the app's design system
/// Provides consistent styling, colors, typography, and spacing
class AppCard extends StatelessWidget {
  final String title;
  final Widget? child;
  final double? width;
  final double? height;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final double? elevation;

  const AppCard({
    super.key,
    required this.title,
    this.child,
    this.width,
    this.height,
    this.margin,
    this.padding,
    this.backgroundColor,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      width: width,
      height: height,
      margin: margin ?? const EdgeInsets.all(8.0),
      child: Card(
        elevation: elevation ?? 4.0,
        color: backgroundColor ?? theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title.isNotEmpty) ...[
                Text(
                  title,
                  style: cardTitleStyle(context),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16.0),
              ],
              if (child != null) Expanded(child: child!),
            ],
          ),
        ),
      ),
    );
  }
}