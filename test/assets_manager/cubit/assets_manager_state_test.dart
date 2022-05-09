// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/assets_manager/assets_manager.dart';

void main() {
  group('AssetsManagerState', () {
    test('can be instantiated', () {
      expect(
        AssetsManagerState(assetsCount: 0, loaded: 0),
        isNotNull,
      );
    });

    test('has the correct initial state', () {
      expect(
        AssetsManagerState.initial(),
        equals(
          AssetsManagerState(
            assetsCount: 0,
            loaded: 0,
          ),
        ),
      );
    });

    group('progress', () {
      test('returns 0 when no future is loaded', () {
        expect(
          AssetsManagerState(
            assetsCount: 2,
            loaded: 0,
          ).progress,
          equals(0),
        );
      });

      test('returns the correct value when some of the futures are loaded', () {
        expect(
          AssetsManagerState(
            assetsCount: 2,
            loaded: 1,
          ).progress,
          equals(0.5),
        );
      });

      test('returns the 1 when all futures are loaded', () {
        expect(
          AssetsManagerState(
            assetsCount: 2,
            loaded: 2,
          ).progress,
          equals(1),
        );
      });
    });

    group('copyWith', () {
      test('returns a copy with the updated assetsCount', () {
        expect(
          AssetsManagerState(
            assetsCount: 0,
            loaded: 0,
          ).copyWith(assetsCount: 1),
          equals(
            AssetsManagerState(
              assetsCount: 1,
              loaded: 0,
            ),
          ),
        );
      });

      test('returns a copy with the updated loaded', () {
        expect(
          AssetsManagerState(
            assetsCount: 0,
            loaded: 0,
          ).copyWith(loaded: 1),
          equals(
            AssetsManagerState(
              assetsCount: 0,
              loaded: 1,
            ),
          ),
        );
      });
    });

    test('supports value comparison', () {
      expect(
        AssetsManagerState(
          assetsCount: 0,
          loaded: 0,
        ),
        equals(
          AssetsManagerState(
            assetsCount: 0,
            loaded: 0,
          ),
        ),
      );

      expect(
        AssetsManagerState(
          assetsCount: 1,
          loaded: 0,
        ),
        isNot(
          equals(
            AssetsManagerState(
              assetsCount: 1,
              loaded: 1,
            ),
          ),
        ),
      );
    });
  });
}
