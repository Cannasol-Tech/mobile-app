/**
 * @file display_data_provider.dart
 * @author Stephen Boyett
 * @date 2025-09-06
 * @brief Display data provider for UI state management.
 * @details Manages UI display state including navigation selection and
 *          other display-related data with reactive state management.
 * @version 1.0
 * @since 1.0
 */

import 'package:flutter/material.dart';

/**
 * @brief Provider for managing display and UI state data.
 * @details Extends ChangeNotifier to provide reactive state management
 *          for UI elements like bottom navigation selection.
 * @since 1.0
 */
class DisplayDataModel extends ChangeNotifier {
  /// Private field for bottom navigation selected item index
  int _bottomNavSelectedItem = 0;

  /// Getter for bottom navigation selected item index
  int get bottomNavSelectedItem => _bottomNavSelectedItem;

  /**
   * @brief Sets the selected item index for bottom navigation.
   * @details Updates the selected navigation item and notifies listeners
   *          to trigger UI updates.
   * @param idx The index of the selected navigation item
   * @since 1.0
   */
  void setBottomNavSelectedItem(int idx){
    _bottomNavSelectedItem = idx;
    notifyListeners();
  }
}