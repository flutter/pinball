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
    Assets.images.multiball.a.active.keyName,
    Assets.images.multiball.a.inactive.keyName,
    Assets.images.multiball.b.active.keyName,
    Assets.images.multiball.b.inactive.keyName,
    Assets.images.multiball.c.active.keyName,
    Assets.images.multiball.c.inactive.keyName,
    Assets.images.multiball.d.active.keyName,
    Assets.images.multiball.d.inactive.keyName,
  ];
  final flameTester = FlameTester(() => EmptyPinballTestGame(assets));

  group('MultiballGroup', () {
    flameTester.test(
      'loads correctly',
      (game) async {
        final multiballGroup = MultiballGroup();
        await game.ensureAdd(multiballGroup);

        expect(game.contains(multiballGroup), isTrue);
      },
    );

    group('loads', () {
      flameTester.test(
        'four Multiball',
        (game) async {
          final multiballGroup = MultiballGroup();
          await game.ensureAdd(multiballGroup);

          expect(
            multiballGroup.descendants().whereType<Multiball>().length,
            equals(4),
          );
        },
      );
    });
  });
  group('MultiballController', () {
    group('controller', () {
      group('listenWhen', () {
        flameTester.test(
          'listens when obtain a multiball bonus',
          (game) async {
            const previous = GameState.initial();
            final state = previous.copyWith(bonusHistory: [GameBonus.dashNest]);

            final multiballGroup = MultiballGroup();
            await game.ensureAdd(multiballGroup);

            expect(
              multiballGroup.controller.listenWhen(previous, state),
              isTrue,
            );
          },
        );

        flameTester.test(
          "doesn't listen when bonus is the same",
          (game) async {
            const previous = GameState.initial();

            final multiballGroup = MultiballGroup();
            await game.ensureAdd(multiballGroup);

            expect(
              multiballGroup.controller.listenWhen(previous, previous),
              isFalse,
            );
          },
        );
      });

      group(
        'onNewState',
        () {
          flameTester.test(
            'blink multiballs when state changes',
            (game) async {
              final multiballGroup = MockMultiballGroup();
              final multiball = MockMultiball();
              final controller = MultiballController(multiballGroup);
              when(() => multiballGroup.multiballA).thenReturn(multiball);
              when(() => multiballGroup.multiballB).thenReturn(multiball);
              when(() => multiballGroup.multiballC).thenReturn(multiball);
              when(() => multiballGroup.multiballD).thenReturn(multiball);
              when(multiball.animate).thenAnswer((_) async => () {});

              controller.onNewState(
                const GameState.initial()
                    .copyWith(bonusHistory: [GameBonus.dashNest]),
              );

              verify(() => multiball.animate).called(4);
            },
          );
        },
      );
    });
  });
}
