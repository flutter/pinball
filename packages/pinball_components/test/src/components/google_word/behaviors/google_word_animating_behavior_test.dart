// ignore_for_file: cascade_invocations

import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';

class _TestGame extends Forge2DGame {
  Future<void> pump(
    GoogleWordAnimatingBehavior child, {
    required GoogleWordCubit bloc,
  }) async {
    await ensureAdd(
      FlameBlocProvider<GoogleWordCubit, GoogleWordState>.value(
        value: bloc,
        children: [child],
      ),
    );
  }
}

class _MockGoogleWordCubit extends Mock implements GoogleWordCubit {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(_TestGame.new);

  group('GoogleWordAnimatingBehavior', () {
    flameTester.testGameWidget(
      'calls switched after timer period reached',
      setUp: (game, tester) async {
        final behavior = GoogleWordAnimatingBehavior();
        final bloc = _MockGoogleWordCubit();
        await game.pump(behavior, bloc: bloc);
        game.update(behavior.timer.limit);

        verify(bloc.switched).called(1);
      },
    );

    flameTester.testGameWidget(
      'calls onAnimationFinished and removes itself '
      'after all blinks complete',
      setUp: (game, tester) async {
        final behavior = GoogleWordAnimatingBehavior();
        final bloc = _MockGoogleWordCubit();

        await game.pump(behavior, bloc: bloc);
        for (var i = 0; i <= 14; i++) {
          game.update(behavior.timer.limit);
        }
        await game.ready();

        verify(bloc.onAnimationFinished).called(1);
        expect(
          game.descendants().whereType<GoogleWordAnimatingBehavior>().isEmpty,
          isTrue,
        );
      },
    );
  });
}
