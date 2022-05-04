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
      flameTester.test('"a"', (game) async {
        final multiball = Multiball.a();
        await game.ensureAdd(multiball);

        expect(game.contains(multiball), isTrue);
      });

      flameTester.test('"b"', (game) async {
        final multiball = Multiball.b();
        await game.ensureAdd(multiball);
        expect(game.contains(multiball), isTrue);
      });

      flameTester.test('"c"', (game) async {
        final multiball = Multiball.c();
        await game.ensureAdd(multiball);

        expect(game.contains(multiball), isTrue);
      });

      flameTester.test('"d"', (game) async {
        final multiball = Multiball.d();
        await game.ensureAdd(multiball);
        expect(game.contains(multiball), isTrue);
      });
    });

    flameTester.test(
      'closes bloc when removed',
      (game) async {
        final bloc = _MockMultiballCubit();
        whenListen(
          bloc,
          const Stream<MultiballLightState>.empty(),
          initialState: MultiballLightState.dimmed,
        );
        when(bloc.close).thenAnswer((_) async {});
        final multiball = Multiball.test(bloc: bloc);

        await game.ensureAdd(multiball);
        game.remove(multiball);
        await game.ready();

        verify(bloc.close).called(1);
      },
    );

    group('adds', () {
      flameTester.test('new children', (game) async {
        final component = Component();
        final multiball = Multiball.a(
          children: [component],
        );
        await game.ensureAdd(multiball);
        expect(multiball.children, contains(component));
      });

      flameTester.test('a MultiballBlinkingBehavior', (game) async {
        final multiball = Multiball.a();
        await game.ensureAdd(multiball);
        expect(
          multiball.children.whereType<MultiballBlinkingBehavior>().single,
          isNotNull,
        );
      });
    });
  });
}
