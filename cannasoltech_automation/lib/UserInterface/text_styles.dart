import 'package:flutter/material.dart';
import '../services/style_service.dart';

// Re-export styles for backward compatibility
// TODO: Update all files to use StyleService directly
TextStyle configHeaderStyle = StyleService.configHeaderStyle;
const TextStyle noDeviceStyle = StyleService.noDeviceStyle;