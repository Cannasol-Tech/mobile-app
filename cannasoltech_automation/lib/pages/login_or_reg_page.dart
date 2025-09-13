/**
 * @file login_or_reg_page.dart
 * @author Stephen Boyett
 * @date 2025-09-06
 * @brief Login or registration page toggle widget.
 * @details Provides a toggle interface between sign-in and registration pages
 *          allowing users to switch between authentication modes seamlessly.
 * @version 1.0
 * @since 1.0
 */

import 'package:flutter/material.dart';
import 'sign_in.dart';
import 'register_page.dart';

/**
 * @brief Toggle widget for login and registration pages.
 * @details Stateful widget that manages switching between sign-in and
 *          registration interfaces with smooth transitions.
 * @since 1.0
 */
class LoginOrRegisterPage extends StatefulWidget {
  /**
   * @brief Creates a LoginOrRegisterPage widget.
   * @param key Optional widget key for identification
   */
  const LoginOrRegisterPage({super.key});

  /**
   * @brief Creates the state for LoginOrRegisterPage widget.
   * @return _LoginOregisterPageState instance
   */
  @override
  State<LoginOrRegisterPage> createState() => _LoginOregisterPageState();
}

/**
 * @brief State class for LoginOrRegisterPage widget.
 * @details Manages the toggle state between login and registration pages
 *          and handles page transitions.
 * @since 1.0
 */
class _LoginOregisterPageState extends State<LoginOrRegisterPage> {
  /// Flag to determine which page to show (true = login, false = register)
  bool showLoginPage = true;

  /**
   * @brief Toggles between login and register pages.
   * @details Switches the current page state and triggers a rebuild
   *          to show the appropriate authentication interface.
   * @since 1.0
   */
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return SignInPage1(toggleFn: togglePages);
    }
    else {return RegisterPage(toggleFn: togglePages);}
   }
}
