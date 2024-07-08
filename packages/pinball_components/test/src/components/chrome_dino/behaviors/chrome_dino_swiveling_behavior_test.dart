// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/chrome_dino/behaviors/behaviors.dart';

import '../../../../helpers/helpers.dart';

class _MockChromeDinoCubit extends Mock implements ChromeDinoCubit {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(TestGame.new);

  group(
    'ChromeDinoSwivelingBehavior',
    () {
      const swivelPeriod = 98 / 48;

      test('can be instantiated', () {
        expect(
          ChromeDinoSwivelingBehavior(),
          isA<ChromeDinoSwivelingBehavior>(),
        );
      });

      flameTester.testGameWidget(
        'creates a RevoluteJoint',
        setUp: (game, _) async {
          final behavior = ChromeDinoSwivelingBehavior();
          final bloc = _MockChromeDinoCubit();
          whenListen(
            bloc,
            const Stream<ChromeDinoState>.empty(),
            initialState: const ChromeDinoState.initial(),
          );

          final chromeDino = ChromeDino.test(bloc: bloc);
          await chromeDino.add(behavior);
          await game.ensureAdd(chromeDino);
        },
        verify: (game, _) async {
          expect(
            game.world.physicsWorld.joints.whereType<RevoluteJoint>().single,
            isNotNull,
          );
        },
      );

      flameTester.testGameWidget(
        'reverses swivel direction on each timer tick',
        setUp: (game, _) async {
          final behavior = ChromeDinoSwivelingBehavior();
          final bloc = _MockChromeDinoCubit();
          whenListen(
            bloc,
            const Stream<ChromeDinoState>.empty(),
            initialState: const ChromeDinoState.initial(),
          );

          final chromeDino = ChromeDino.test(bloc: bloc);
          await chromeDino.add(behavior);
          await game.ensureAdd(chromeDino);
        },
        verify: (game, _) async {
          final behavior = game
              .descendants()
              .whereType<ChromeDinoSwivelingBehavior>()
              .single;
          final timer = behavior.timer;
          final joint =
              game.world.physicsWorld.joints.whereType<RevoluteJoint>().single;

          expect(joint.motorSpeed, isPositive);

          timer.onTick!();
          game.update(0);
          expect(joint.motorSpeed, isNegative);

          timer.onTick!();
          game.update(0);
          expect(joint.motorSpeed, isPositive);
        },
      );

      group('calls', () {
        flameTester.testGameWidget(
          'onCloseMouth when joint angle is between limits '
          'and mouth is open',
          setUp: (game, tester) async {
            final behavior = ChromeDinoSwivelingBehavior();
            final bloc = _MockChromeDinoCubit();
            whenListen(
              bloc,
              const Stream<ChromeDinoState>.empty(),
              initialState:
                  const ChromeDinoState.initial().copyWith(isMouthOpen: true),
            );

            final chromeDino = ChromeDino.test(bloc: bloc);
            await chromeDino.add(behavior);
            await game.ensureAdd(chromeDino);

            final joint = game.world.physicsWorld.joints
                .whereType<RevoluteJoint>()
                .single;
            final angle = joint.jointAngle();
            expect(
              angle < joint.upperLimit && angle > joint.lowerLimit,
              isTrue,
            );
            game.update(0);

            verify(bloc.onCloseMouth).called(1);
          },
        );

        flameTester.testGameWidget(
          'onOpenMouth when joint angle is greater than the upperLimit '
          'and mouth is closed',
          setUp: (game, tester) async {
            final behavior = ChromeDinoSwivelingBehavior();
            final bloc = _MockChromeDinoCubit();
            whenListen(
              bloc,
              const Stream<ChromeDinoState>.empty(),
              initialState:
                  const ChromeDinoState.initial().copyWith(isMouthOpen: false),
            );
            final chromeDino = ChromeDino.test(bloc: bloc);
            await chromeDino.add(behavior);
            await game.world.ensureAdd(chromeDino);
            await game.ready();
          },
          verify: (game, _) async {
            final bloc =
                game.world.descendants().whereType<ChromeDino>().single.bloc;
            game.update(swivelPeriod / 2);
            final joint = game.world.physicsWorld.joints
                .whereType<RevoluteJoint>()
                .single;
            final angle = joint.jointAngle();
            expect(angle, greaterThanOrEqualTo(joint.upperLimit));

            verify(bloc.onOpenMouth).called(1);
          },
        );

        flameTester.testGameWidget(
          'onOpenMouth when joint angle is less than the lowerLimit '
          'and mouth is closed',
          setUp: (game, tester) async {
            final behavior = ChromeDinoSwivelingBehavior();
            final bloc = _MockChromeDinoCubit();
            whenListen(
              bloc,
              const Stream<ChromeDinoState>.empty(),
              initialState:
                  const ChromeDinoState.initial().copyWith(isMouthOpen: false),
            );

            final chromeDino = ChromeDino.test(bloc: bloc);
            await chromeDino.add(behavior);
            await game.world.ensureAdd(chromeDino);
            await game.ready();
          },
          verify: (game, _) async {
            final bloc =
                game.world.descendants().whereType<ChromeDino>().single.bloc;
            final behavior = game
                .descendants()
                .whereType<ChromeDinoSwivelingBehavior>()
                .single;
            behavior.timer.onTick!();
            game.update(swivelPeriod * 1.5);
            final joint = game.world.physicsWorld.joints
                .whereType<RevoluteJoint>()
                .single;
            final angle = joint.jointAngle();

            expect(angle, lessThanOrEqualTo(joint.lowerLimit));
            verify(bloc.onOpenMouth).called(1);
          },
        );
      });
    },
  );
}
