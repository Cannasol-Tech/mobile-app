/**
 * @file formatters.dart
 * @author Stephen Boyett
 * @date 2025-09-06
 * @brief Text input formatters for decimal number validation.
 * @details Provides custom TextInputFormatter implementations for controlling
 *          decimal input precision and validation in form fields.
 * @version 1.0
 * @since 1.0
 */

import 'package:flutter/services.dart';
import 'dart:math' as math;

/**
 * @brief Text input formatter for decimal numbers with precision control.
 * @details Extends TextInputFormatter to limit decimal places in text input fields
 *          and handle edge cases like leading decimal points.
 * @since 1.0
 */
class DecimalTextInputFormatter extends TextInputFormatter {
  /**
   * @brief Creates a DecimalTextInputFormatter with specified decimal range.
   * @param decimalRange Maximum number of decimal places allowed (must be > 0)
   * @throws AssertionError if decimalRange is not greater than 0
   */
  DecimalTextInputFormatter({required this.decimalRange})
      : assert(decimalRange > 0);

  /// Maximum number of decimal places allowed
  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    String value = newValue.text;
    if (value.contains(".") &&
        value.substring(value.indexOf(".") + 1).length > decimalRange) {
      truncated = oldValue.text;
      newSelection = oldValue.selection;
    } else if (value == ".") {
      truncated = "0.";
      newSelection = newValue.selection.copyWith(
        baseOffset: math.min(truncated.length, truncated.length + 1),
        extentOffset: math.min(truncated.length, truncated.length + 1),
      );
    }
    return TextEditingValue(
      text: truncated,
      selection: newSelection,
      composing: TextRange.empty,
    );
  }
}