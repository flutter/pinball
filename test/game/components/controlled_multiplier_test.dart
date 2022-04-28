// ignore_for_file: cascade_invocations

import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
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
        final multipliersGroup = Multipliers();
        await game.ensureAdd(multipliersGroup);

        expect(game.contains(multipliersGroup), isTrue);
      },
    );

    group('loads', () {
      flameTester.test(
        'five Multiplier',
        (game) async {
          final multipliersGroup = Multipliers();
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

            final multipliersGroup = Multipliers();
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

            final multipliersGroup = Multipliers();
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
            'toggle multipliers when state changes',
            (game) async {
              final multipliersGroup = MockMultipliersGroup();
              final x2multiplier = MockMultiplier();
              final x3multiplier = MockMultiplier();
              final x4multiplier = MockMultiplier();
              final x5multiplier = MockMultiplier();
              final x6multiplier = MockMultiplier();
              final controller = MultipliersController(multipliersGroup);
              when(() => multipliersGroup.x2multiplier)
                  .thenReturn(x2multiplier);
              when(() => multipliersGroup.x3multiplier)
                  .thenReturn(x3multiplier);
              when(() => multipliersGroup.x4multiplier)
                  .thenReturn(x4multiplier);
              when(() => multipliersGroup.x5multiplier)
                  .thenReturn(x5multiplier);
              when(() => multipliersGroup.x6multiplier)
                  .thenReturn(x6multiplier);

              controller.onNewState(
                const GameState.initial().copyWith(score: 6),
              );

              // TODO(ruimiguel): verify toggle with state.multiplier value.
              verify(() => x2multiplier.toggle(any())).called(1);
              verify(() => x3multiplier.toggle(any())).called(1);
              verify(() => x4multiplier.toggle(any())).called(1);
              verify(() => x5multiplier.toggle(any())).called(1);
              verify(() => x6multiplier.toggle(any())).called(1);
            },
          );
        },
      );
    });
  });
}
