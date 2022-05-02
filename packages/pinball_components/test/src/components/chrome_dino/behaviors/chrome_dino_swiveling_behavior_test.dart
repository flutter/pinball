// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/chrome_dino/behaviors/behaviors.dart';

import '../../../../helpers/helpers.dart';

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

      flameTester.test(
        'creates a RevoluteJoint',
        (game) async {
          final behavior = ChromeDinoSwivelingBehavior();
          final bloc = MockChromeDinoCubit();
          whenListen(
            bloc,
            const Stream<ChromeDinoState>.empty(),
            initialState: const ChromeDinoState.inital(),
          );

          final chromeDino = ChromeDino.test(bloc: bloc);
          await chromeDino.add(behavior);
          await game.ensureAdd(chromeDino);

          expect(
            game.world.joints.whereType<RevoluteJoint>().single,
            isNotNull,
          );
        },
      );

      flameTester.test(
        'reverses swivel direction on each timer tick',
        (game) async {
          final behavior = ChromeDinoSwivelingBehavior();
          final bloc = MockChromeDinoCubit();
          whenListen(
            bloc,
            const Stream<ChromeDinoState>.empty(),
            initialState: const ChromeDinoState.inital(),
          );

          final chromeDino = ChromeDino.test(bloc: bloc);
          await chromeDino.add(behavior);
          await game.ensureAdd(chromeDino);

          final timer = behavior.timer;
          final joint = game.world.joints.whereType<RevoluteJoint>().single;

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
            final bloc = MockChromeDinoCubit();
            whenListen(
              bloc,
              const Stream<ChromeDinoState>.empty(),
              initialState:
                  const ChromeDinoState.inital().copyWith(isMouthOpen: true),
            );

            final chromeDino = ChromeDino.test(bloc: bloc);
            await chromeDino.add(behavior);
            await game.ensureAdd(chromeDino);

            final joint = game.world.joints.whereType<RevoluteJoint>().single;
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
            final bloc = MockChromeDinoCubit();
            whenListen(
              bloc,
              const Stream<ChromeDinoState>.empty(),
              initialState:
                  const ChromeDinoState.inital().copyWith(isMouthOpen: false),
            );

            final chromeDino = ChromeDino.test(bloc: bloc);
            await chromeDino.add(behavior);
            await game.ensureAdd(chromeDino);

            final joint = game.world.joints.whereType<RevoluteJoint>().single;

            game.update(swivelPeriod / 2);
            await tester.pump();
            final angle = joint.jointAngle();
            expect(angle >= joint.upperLimit, isTrue);

            verify(bloc.onOpenMouth).called(1);
          },
        );

        flameTester.testGameWidget(
          'onOpenMouth when joint angle is less than the lowerLimit '
          'and mouth is closed',
          setUp: (game, tester) async {
            final behavior = ChromeDinoSwivelingBehavior();
            final bloc = MockChromeDinoCubit();
            whenListen(
              bloc,
              const Stream<ChromeDinoState>.empty(),
              initialState:
                  const ChromeDinoState.inital().copyWith(isMouthOpen: false),
            );

            final chromeDino = ChromeDino.test(bloc: bloc);
            await chromeDino.add(behavior);
            await game.ensureAdd(chromeDino);

            final joint = game.world.joints.whereType<RevoluteJoint>().single;

            game.update(swivelPeriod * 1.5);
            await tester.pump();
            final angle = joint.jointAngle();
            expect(angle <= joint.lowerLimit, isTrue);

            verify(bloc.onOpenMouth).called(1);
          },
        );
      });
    },
  );
}
