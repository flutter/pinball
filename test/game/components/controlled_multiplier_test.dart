// ignore_for_file: cascade_invocations

import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final assets = [
    Assets.images.multiplier.x2.active.keyName,
    Assets.images.multiplier.x2.inactive.keyName,
    Assets.images.multiplier.x3.active.keyName,
    Assets.images.multiplier.x3.inactive.keyName,
    Assets.images.multiplier.x4.active.keyName,
    Assets.images.multiplier.x4.inactive.keyName,
    Assets.images.multiplier.x5.active.keyName,
    Assets.images.multiplier.x5.inactive.keyName,
    Assets.images.multiplier.x6.active.keyName,
    Assets.images.multiplier.x6.inactive.keyName,
  ];
  final flameTester = FlameTester(() => EmptyPinballTestGame(assets));

  group('MultipliersGroup', () {
    flameTester.test(
      'loads correctly',
      (game) async {
        final multipliersGroup = MultipliersGroup();
        await game.ensureAdd(multipliersGroup);

        expect(game.contains(multipliersGroup), isTrue);
      },
    );

    group('loads', () {
      flameTester.test(
        'five Multiplier',
        (game) async {
          final multipliersGroup = MultipliersGroup();
          await game.ensureAdd(multipliersGroup);

          expect(
            multipliersGroup.descendants().whereType<Multiplier>().length,
            equals(5),
          );
        },
      );
    });
  });
  group('MultipliersController', () {
    group('controller', () {
      // TODO(ruimiguel): change these tests to check multiplier change.
      group('listenWhen', () {
        flameTester.test(
          'listens when score has changed',
          (game) async {
            const previous = GameState.initial();
            final state = previous.copyWith(score: 100);

            final multipliersGroup = MultipliersGroup();
            await game.ensureAdd(multipliersGroup);

            expect(
              multipliersGroup.controller.listenWhen(previous, state),
              isTrue,
            );
          },
        );

        flameTester.test(
          "doesn't listen when score is the same",
          (game) async {
            const previous = GameState.initial();

            final multipliersGroup = MultipliersGroup();
            await game.ensureAdd(multipliersGroup);

            expect(
              multipliersGroup.controller.listenWhen(previous, previous),
              isFalse,
            );
          },
        );
      });

      group(
        'onNewState',
        () {
          flameTester.test(
            'spawns a ball',
            (game) async {
              final state = GameState.initial().copyWith(score: 100);

              final multipliersGroup = MultipliersGroup();
              await game.ensureAdd(multipliersGroup);

              multipliersGroup.controller.onNewState(state);
            },
          );
        },
      );
    });
  });
}
