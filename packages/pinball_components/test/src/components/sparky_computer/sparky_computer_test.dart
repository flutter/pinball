// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/sparky_computer/behaviors/behaviors.dart';

import '../../../helpers/helpers.dart';

class _MockSparkyComputerCubit extends Mock implements SparkyComputerCubit {}

void main() {
  group('SparkyComputer', () {
    TestWidgetsFlutterBinding.ensureInitialized();
    final assets = [
      Assets.images.sparky.computer.base.keyName,
      Assets.images.sparky.computer.top.keyName,
      Assets.images.sparky.computer.glow.keyName,
    ];
    final flameTester = FlameTester(() => TestGame(assets));

    flameTester.testGameWidget(
      'loads correctly',
      setUp: (game, _) async {
        await game.onLoad();
        final component = SparkyComputer();
        await game.ensureAdd(component);
        await game.ready();
      },
      verify: (game, _) async {
        expect(game.descendants().whereType<SparkyComputer>().length, 1);
      },
    );

    flameTester.testGameWidget(
      'renders correctly',
      setUp: (game, tester) async {
        await game.images.loadAll(assets);
        await game.world.ensureAdd(SparkyComputer());
        await tester.pump();

        game.camera
          ..moveTo(Vector2(0, -20))
          ..viewfinder.zoom = 7;
      },
      verify: (game, tester) async {
        await expectLater(
          find.byGame<TestGame>(),
          matchesGoldenFile('../golden/sparky_computer.png'),
        );
      },
    );

    flameTester.testGameWidget(
      'closes bloc when removed',
      setUp: (game, _) async {
        await game.onLoad();
        final bloc = _MockSparkyComputerCubit();
        whenListen(
          bloc,
          const Stream<SparkyComputerState>.empty(),
          initialState: SparkyComputerState.withoutBall,
        );
        when(bloc.close).thenAnswer((_) async {});
        final sparkyComputer = SparkyComputer.test(bloc: bloc);

        await game.ensureAdd(sparkyComputer);
        await game.ready();
      },
      verify: (game, _) async {
        final sparkyComputer =
            game.descendants().whereType<SparkyComputer>().single;
        game.remove(sparkyComputer);
        game.update(0);

        verify(sparkyComputer.bloc.close).called(1);
      },
    );

    group('adds', () {
      flameTester.testGameWidget(
        'new children',
        setUp: (game, _) async {
          await game.onLoad();
          final component = Component();
          final sparkyComputer = SparkyComputer(
            children: [component],
          );
          await game.ensureAdd(sparkyComputer);
          await game.ready();
        },
        verify: (game, _) async {
          final sparkyComputer =
              game.descendants().whereType<SparkyComputer>().single;
          expect(sparkyComputer.children.whereType<Component>(), isNotEmpty);
        },
      );

      flameTester.testGameWidget(
        'a SparkyComputerSensorBallContactBehavior',
        setUp: (game, _) async {
          await game.onLoad();
          final sparkyComputer = SparkyComputer();
          await game.ensureAdd(sparkyComputer);
          await game.ready();
        },
        verify: (game, _) async {
          final sparkyComputer =
              game.descendants().whereType<SparkyComputer>().single;
          expect(
            sparkyComputer.children
                .whereType<SparkyComputerSensorBallContactBehavior>()
                .single,
            isNotNull,
          );
        },
      );
    });
  });
}
