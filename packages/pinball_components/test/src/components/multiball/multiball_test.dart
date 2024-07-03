// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/multiball/behaviors/behaviors.dart';

import '../../../helpers/helpers.dart';

class _MockMultiballCubit extends Mock implements MultiballCubit {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final assets = [
    Assets.images.multiball.lit.keyName,
    Assets.images.multiball.dimmed.keyName,
  ];
  final flameTester = FlameTester(() => TestGame(assets));

  group('Multiball', () {
    group('loads correctly', () {
      flameTester.testGameWidget(
        '"a"',
        setUp: (game, _) async {
          final multiball = Multiball.a();
          await game.ensureAdd(multiball);
        },
        verify: (game, _) async {
          expect(game.descendants().whereType<Multiball>(), isNotEmpty);
        },
      );

      flameTester.testGameWidget(
        '"b"',
        setUp: (game, _) async {
          final multiball = Multiball.b();
          await game.ensureAdd(multiball);
        },
        verify: (game, _) async {
          expect(game.descendants().whereType<Multiball>(), isNotEmpty);
        },
      );

      flameTester.testGameWidget(
        '"c"',
        setUp: (game, _) async {
          final multiball = Multiball.c();
          await game.ensureAdd(multiball);
        },
        verify: (game, _) async {
          expect(game.descendants().whereType<Multiball>(), isNotEmpty);
        },
      );

      flameTester.testGameWidget(
        '"d"',
        setUp: (game, _) async {
          final multiball = Multiball.d();
          await game.ensureAdd(multiball);
        },
        verify: (game, _) async {
          expect(game.descendants().whereType<Multiball>(), isNotEmpty);
        },
      );
    });

    flameTester.testGameWidget(
      'closes bloc when removed',
      setUp: (game, _) async {
        await game.onLoad();
        final bloc = _MockMultiballCubit();
        whenListen(
          bloc,
          const Stream<MultiballLightState>.empty(),
          initialState: MultiballLightState.dimmed,
        );
        when(bloc.close).thenAnswer((_) async {});
        final multiball = Multiball.test(bloc: bloc);

        await game.ensureAdd(multiball);
        await game.ready();
      },
      verify: (game, _) async {
        final multiball = game.descendants().whereType<Multiball>().single;
        game.remove(multiball);
        game.update(0);

        verify(multiball.bloc.close).called(1);
      },
    );

    group('adds', () {
      flameTester.testGameWidget(
        'new children',
        setUp: (game, _) async {
          final component = Component();
          final multiball = Multiball.a(
            children: [component],
          );
          await game.ensureAdd(multiball);
        },
        verify: (game, _) async {
          final multiball = game.descendants().whereType<Multiball>().single;
          expect(multiball.children.whereType<Component>(), isNotEmpty);
        },
      );

      flameTester.testGameWidget(
        'a MultiballBlinkingBehavior',
        setUp: (game, _) async {
          final multiball = Multiball.a();
          await game.ensureAdd(multiball);
        },
        verify: (game, _) async {
          final multiball = game.descendants().whereType<Multiball>().single;
          expect(
            multiball.children.whereType<MultiballBlinkingBehavior>(),
            isNotEmpty,
          );
        },
      );
    });
  });
}
