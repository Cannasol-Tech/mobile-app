/**
 * @file types.dart
 * @author Stephen Boyett
 * @date 2025-09-06
 * @brief Type definitions and extensions for the application.
 * @details Provides common type aliases, enums, and string extensions
 *          used throughout the application for consistency and convenience.
 * @version 1.0
 * @since 1.0
 */

// ignore_for_file: unused_element, camel_case_types

import 'package:flutter/material.dart';

/// Type alias for void (placeholder type)
typedef x_x    = void;

/// Type alias for BuildContext
typedef t_Ctx = BuildContext;

/// Type alias for database map structure
typedef DbMap = Map<String, dynamic>;

/// Type alias for context callback function
typedef CtxCb = bool Function(BuildContext)?;

/// Type alias for generic function
typedef _ = Function(dynamic);

/// Enum for directional operations
enum Direction { left, right }

/**
 * @brief String extensions for additional functionality.
 * @details Provides utility methods for string manipulation and formatting.
 * @since 1.0
 */
extension StringExtensions on String {
  /**
   * @brief Converts string to title case.
   * @details Capitalizes the first letter of each word in the string.
   * @return String in title case format
   * @since 1.0
   */
  String toTitleCase() {
    if (isEmpty) return this;
    return split(' ')
        .map((word) =>
            word.isEmpty ? word : word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}