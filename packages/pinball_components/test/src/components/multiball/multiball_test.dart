// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final assets = [
    Assets.images.multiball.a.lit.keyName,
    Assets.images.multiball.a.dimmed.keyName,
    Assets.images.multiball.b.lit.keyName,
    Assets.images.multiball.b.dimmed.keyName,
    Assets.images.multiball.c.lit.keyName,
    Assets.images.multiball.c.dimmed.keyName,
    Assets.images.multiball.d.lit.keyName,
    Assets.images.multiball.d.dimmed.keyName,
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
        final bloc = MockMultiballCubit();
        whenListen(
          bloc,
          const Stream<MultiballState>.empty(),
          initialState: MultiballState.dimmed,
        );
        when(bloc.close).thenAnswer((_) async {});
        final multiball = Multiball.test(bloc: bloc);

        await game.ensureAdd(multiball);
        game.remove(multiball);
        await game.ready();

        verify(bloc.close).called(1);
      },
    );
  });
}
