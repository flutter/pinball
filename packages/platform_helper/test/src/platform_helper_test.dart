// ignore_for_file: prefer_const_constructors
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platform_helper/platform_helper.dart';

void main() {
  group('PlatformHelper', () {
    test('can be instantiated', () {
      expect(PlatformHelper(), isNotNull);
    });

    group('isMobile', () {
      tearDown(() async {
        debugDefaultTargetPlatformOverride = null;
      });

      test('returns true when defaultTargetPlatform is iOS', () async {
        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
        expect(PlatformHelper().isMobile, isTrue);
        debugDefaultTargetPlatformOverride = null;
      });

      test('returns true when defaultTargetPlatform is android', () async {
        debugDefaultTargetPlatformOverride = TargetPlatform.android;
        expect(PlatformHelper().isMobile, isTrue);
        debugDefaultTargetPlatformOverride = null;
      });

      test(
        'returns false when defaultTargetPlatform is neither iOS nor android',
        () async {
          debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
          expect(PlatformHelper().isMobile, isFalse);
          debugDefaultTargetPlatformOverride = null;
        },
      );
    });
  });
}
