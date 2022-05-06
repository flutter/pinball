import 'package:flutter/foundation.dart';

/// {@template platform_helper}
/// Returns whether the current platform is running on a mobile device.
/// {@endtemplate}
class PlatformHelper {
  /// {@macro platform_helper}
  bool get isMobile {
    return defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android;
  }
}
