// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/google_rollover/behaviors/behaviors.dart';

class _TestGame extends Forge2DGame {
  @override
  Future<void> onLoad() async {
    images.prefix = '';
    await images.loadAll([
      Assets.images.googleRollover.left.decal.keyName,
      Assets.images.googleRollover.left.pin.keyName,
    ]);
  }

  Future<void> pump(
    GoogleRollover child, {
    GoogleWordCubit? bloc,
  }) async {
    // Not needed once https://github.com/flame-engine/flame/issues/1607
    // is fixed
    await onLoad();
    await ensureAdd(
      FlameBlocProvider<GoogleWordCubit, GoogleWordState>.value(
        value: bloc ?? GoogleWordCubit(),
        children: [child],
      ),
    );
  }
}

class _MockBall extends Mock implements Ball {}

class _MockContact extends Mock implements Contact {}

class _MockGoogleWordCubit extends Mock implements GoogleWordCubit {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final flameTester = FlameTester(_TestGame.new);

  group(
    'GoogleRolloverBallContactBehavior',
    () {
      test('can be instantiated', () {
        expect(
          GoogleRolloverBallContactBehavior(),
          isA<GoogleRolloverBallContactBehavior>(),
        );
      });

      flameTester.testGameWidget(
        'beginContact animates pin and calls onRolloverContacted '
        'when contacts with a ball',
        setUp: (game, tester) async {
          final behavior = GoogleRolloverBallContactBehavior();
          final bloc = _MockGoogleWordCubit();
          final googleRollover = GoogleRollover(side: BoardSide.left);
          await googleRollover.add(behavior);
          await game.pump(googleRollover, bloc: bloc);

          behavior.beginContact(_MockBall(), _MockContact());
          await tester.pump();

          expect(
            googleRollover.firstChild<SpriteAnimationComponent>()!.playing,
            isTrue,
          );
          verify(bloc.onRolloverContacted).called(1);
        },
      );
    },
  );
}
