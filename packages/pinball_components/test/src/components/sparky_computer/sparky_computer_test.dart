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

    flameTester.test('loads correctly', (game) async {
      final component = SparkyComputer();
      await game.ensureAdd(component);
      expect(game.contains(component), isTrue);
    });

    flameTester.testGameWidget(
      'renders correctly',
      setUp: (game, tester) async {
        await game.images.loadAll(assets);
        await game.ensureAdd(SparkyComputer());
        await tester.pump();

        game.camera
          ..followVector2(Vector2(0, -20))
          ..zoom = 7;
      },
      verify: (game, tester) async {
        await expectLater(
          find.byGame<TestGame>(),
          matchesGoldenFile('../golden/sparky-computer.png'),
        );
      },
    );

    // ignore: public_member_api_docs
    flameTester.test('closes bloc when removed', (game) async {
      final bloc = _MockSparkyComputerCubit();
      whenListen(
        bloc,
        const Stream<SparkyComputerState>.empty(),
        initialState: SparkyComputerState.withoutBall,
      );
      when(bloc.close).thenAnswer((_) async {});
      final sparkyComputer = SparkyComputer.test(bloc: bloc);

      await game.ensureAdd(sparkyComputer);
      game.remove(sparkyComputer);
      await game.ready();

      verify(bloc.close).called(1);
    });

    group('adds', () {
      flameTester.test('new children', (game) async {
        final component = Component();
        final sparkyComputer = SparkyComputer(
          children: [component],
        );
        await game.ensureAdd(sparkyComputer);
        expect(sparkyComputer.children, contains(component));
      });

      flameTester.test('a SparkyComputerSensorBallContactBehavior',
          (game) async {
        final sparkyComputer = SparkyComputer();
        await game.ensureAdd(sparkyComputer);
        expect(
          sparkyComputer.children
              .whereType<SparkyComputerSensorBallContactBehavior>()
              .single,
          isNotNull,
        );
      });
    });
  });
}
