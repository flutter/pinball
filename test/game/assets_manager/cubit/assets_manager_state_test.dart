// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';

void main() {
  group('AssetsManagerState', () {
    test('can be instantiated', () {
      expect(
        AssetsManagerState(loadables: const [], loaded: const []),
        isNotNull,
      );
    });

    test('has the correct initial state', () {
      final future = Future<void>.value();
      expect(
        AssetsManagerState.initial(loadables: [future]),
        equals(
          AssetsManagerState(
            loadables: [future],
            loaded: const [],
          ),
        ),
      );
    });

    group('progress', () {
      final future1 = Future<void>.value();
      final future2 = Future<void>.value();

      test('returns 0 when no future is loaded', () {
        expect(
          AssetsManagerState(
            loadables: [future1, future2],
            loaded: const [],
          ).progress,
          equals(0),
        );
      });

      test('returns the correct value when some of the futures are loaded', () {
        expect(
          AssetsManagerState(
            loadables: [future1, future2],
            loaded: [future1],
          ).progress,
          equals(0.5),
        );
      });

      test('returns the 1 when all futures are loaded', () {
        expect(
          AssetsManagerState(
            loadables: [future1, future2],
            loaded: [future1, future2],
          ).progress,
          equals(1),
        );
      });
    });

    group('copyWith', () {
      final future = Future<void>.value();

      test('returns a copy with the updated loadables', () {
        expect(
          AssetsManagerState(
            loadables: const [],
            loaded: const [],
          ).copyWith(loadables: [future]),
          equals(
            AssetsManagerState(
              loadables: [future],
              loaded: const [],
            ),
          ),
        );
      });

      test('returns a copy with the updated loaded', () {
        expect(
          AssetsManagerState(
            loadables: const [],
            loaded: const [],
          ).copyWith(loaded: [future]),
          equals(
            AssetsManagerState(
              loadables: const [],
              loaded: [future],
            ),
          ),
        );
      });
    });

    test('supports value comparison', () {
      final future1 = Future<void>.value();
      final future2 = Future<void>.value();

      expect(
        AssetsManagerState(
          loadables: const [],
          loaded: const [],
        ),
        equals(
          AssetsManagerState(
            loadables: const [],
            loaded: const [],
          ),
        ),
      );

      expect(
        AssetsManagerState(
          loadables: [future1],
          loaded: const [],
        ),
        isNot(
          equals(
            AssetsManagerState(
              loadables: [future2],
              loaded: const [],
            ),
          ),
        ),
      );

      expect(
        AssetsManagerState(
          loadables: const [],
          loaded: [future1],
        ),
        isNot(
          equals(
            AssetsManagerState(
              loadables: const [],
              loaded: [future2],
            ),
          ),
        ),
      );
    });
  });
}
