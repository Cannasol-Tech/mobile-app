/**
 * @file home_page.dart
 * @author Stephen Boyett
 * @date 2025-09-06
 * @brief Main home page widget for the Cannasol Technologies application.
 * @details Handles authentication state, Terms and Conditions acceptance,
 *          and navigation between login and main application interfaces.
 * @version 1.0
 * @since 1.0
 */

import '../../main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../dialogs/terms_and_conditions.dart';
import '../../providers/system_data_provider.dart';
import 'package:cannasoltech_automation/pages/login_or_reg_page.dart';

/**
 * @brief Main home page widget for the application.
 * @details Stateful widget that manages authentication state and Terms and Conditions
 *          acceptance, routing users to appropriate interfaces based on login status.
 * @since 1.0
 */
class HomePage extends StatefulWidget {
  /**
   * @brief Creates a HomePage widget.
   * @param key Optional widget key for identification
   */
  const HomePage({super.key});

  /**
   * @brief Creates the state for HomePage widget.
   * @return _HomePageState instance
   */
  @override
  State<HomePage> createState() => _HomePageState();
}

/**
 * @brief State class for HomePage widget.
 * @details Manages Terms and Conditions display state and builds the appropriate
 *          UI based on authentication and acceptance status.
 * @since 1.0
 */
class _HomePageState extends State<HomePage> {
  /// Flag to track if Terms and Conditions have been displayed
  bool _displayedTaC = false;

  /**
   * @brief Builds the home page widget based on authentication state.
   * @details Uses Selector to monitor Terms and Conditions acceptance and
   *          routes users to login or main application interface accordingly.
   * @param context Build context for the widget
   * @return Widget representing the home page
   * @since 1.0
   */
  @override
  Widget build(BuildContext context) {
    return Selector<SystemDataModel, bool>(
      selector: (_, p) => (p.needsAcceptTaC),
      builder: (xX_x, needsAcceptTac, x_Xx) {
        // For development, always show login page first
        // This bypasses Firebase authentication issues
        try {
          final CurrentUser user = context.watch<CurrentUser>();
          final bool loggedIn = user != null;

          if (loggedIn) {
            if (needsAcceptTac && _displayedTaC == false) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() => _displayedTaC = true);
                Navigator.of(context).popUntil(ModalRoute.withName('/'));
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const TaCDialog();
                  },
                );
              });
            }
            if (needsAcceptTac == false && _displayedTaC == true) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() => _displayedTaC = false);
              });
            }
            return context.read<SystemDataModel>().currentRunPage;
          }
          else {
            return const LoginOrRegisterPage();
          }
        } catch (e) {
          // If there's any error with authentication, show login page
          print('Authentication error: $e');
          return const LoginOrRegisterPage();
        }
    });
  }
}

