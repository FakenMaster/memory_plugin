
import 'dart:async';

import 'package:flutter/services.dart';

class MemoryPlugin {
  static const MethodChannel _channel =
      const MethodChannel('memory_plugin');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String?> get memoryInfo async {
    final String? memoryInfo = await _channel.invokeMethod('getMemoryInfo');
    return memoryInfo;
  }
}
