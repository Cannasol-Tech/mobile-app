// ignore_for_file: unused_element, camel_case_types

import 'package:flutter/material.dart';
typedef x_x    = void;
typedef t_Ctx = BuildContext;
typedef DbMap = Map<String, dynamic>;
typedef CtxCb = bool Function(BuildContext)?;
typedef _ = Function(dynamic);
enum Direction { left, right }

// Extension on String for Title Case
extension StringExtensions on String {
  String toTitleCase() {
    if (isEmpty) return this;
    return split(' ')
        .map((word) =>
            word.isEmpty ? word : word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}