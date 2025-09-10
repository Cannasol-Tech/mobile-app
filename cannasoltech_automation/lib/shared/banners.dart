/**
 * @file banners.dart
 * @author Stephen Boyett
 * @date 2025-09-06
 * @brief Material banner notifications and display utilities.
 * @details Provides banner notification system for displaying status messages,
 *          download progress, errors, and other user feedback with animations.
 * @version 1.0
 * @since 1.0
 */

import '../main.dart';
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

/// Standard dismiss action for banner notifications
final SnackBarAction dismissAction = SnackBarAction(
  label: "DISMISS",
  onPressed: () => scaffoldMessengerKey
  .currentState?.hideCurrentMaterialBanner()
);

/**
 * @brief Shows a material banner notification.
 * @details Displays a banner using the global scaffold messenger key.
 * @param banner MaterialBanner to display
 * @since 1.0
 */
void showBanner(banner) => scaffoldMessengerKey.currentState?.showMaterialBanner(banner as MaterialBanner);

/**
 * @brief Hides the currently displayed banner notification.
 * @details Removes the current banner using the global scaffold messenger key.
 * @since 1.0
 */
void hideCurrentBanner() => scaffoldMessengerKey.currentState?.hideCurrentMaterialBanner();

/**
 * @brief Custom material banner notification widget.
 * @details Extends MaterialBanner to provide customizable banner notifications
 *          with background color and content styling.
 * @since 1.0
 */
class BannerNotification extends MaterialBanner{
  /// Background color and display content for the banner
  final dynamic bgColor, displayContent;

  /**
   * @brief Creates a BannerNotification with custom styling.
   * @param key Optional widget key for identification
   * @param actions List of actions for the banner
   * @param bgColor Background color for the banner
   * @param displayContent Widget content to display in the banner
   */
  const BannerNotification({
    super.key,
    required super.actions,
    required Color this.bgColor,
    required Widget this.displayContent,
  }) : super(
    content: displayContent,
    backgroundColor: bgColor,
  );

  @override
  State<BannerNotification> createState() => _BannerNotificationState();
}

class _BannerNotificationState extends State<BannerNotification> with AnimationMixin{
  late AnimationController scalarController;
  late Animation<double> scalar;
  @override
  void initState() {
    super.initState();
    scalarController = createController()
    ..play(duration: const Duration(milliseconds: 1000));
    scalar = Tween(begin: 0.0, end: 1000.0).animate(scalarController);
  }
  @override
  Widget build(BuildContext context) {
    return MaterialBanner(
      leading: const Icon(
        Icons.warning_outlined, 
        size: 35.0
      ),
      content: widget.displayContent,
      elevation: scalar.value*20,
      backgroundColor: widget.bgColor.withAlpha(scalar.value*170),
      shadowColor: widget.bgColor.withAlpha(scalar.value*200),
      actions: widget.actions,
      animation: CurvedAnimation(parent: scalarController, curve: Curves.elasticOut),
    );
  }
}

Text bannerContent(displayText) => Text(displayText, 
                                    style: const TextStyle(
                                      color: Colors.white60, 
                                      fontWeight: FontWeight.bold
                                    )
                                  );

BannerNotification greenBanner({
  required String displayText, 
  List<SnackBarAction>? actions}) => BannerNotification(
  displayContent: bannerContent(displayText),
  bgColor: const Color.fromARGB(189, 15, 158, 79),
  actions: actions ?? [dismissAction]
);

BannerNotification redBanner({
  required String displayText, 
  List<SnackBarAction>? actions}) => BannerNotification(
  displayContent: bannerContent(displayText),
  bgColor: const Color.fromARGB(190, 155, 25, 11),
  actions: actions ?? [dismissAction]
);
   

BannerNotification unableToDownloadBanner(String reason) => redBanner(
  displayText: "Unable to download! $reason",
);

BannerNotification downloadFailedBanner(dynamic reason) => redBanner(
  displayText: "Download failed! $reason"
);

BannerNotification downloadingDeviceHistoryBanner() => greenBanner(
  displayText: "Downloading device history..."
);

BannerNotification downloadCompleteBanner() => greenBanner(
  displayText: "Download complete!", 
);
