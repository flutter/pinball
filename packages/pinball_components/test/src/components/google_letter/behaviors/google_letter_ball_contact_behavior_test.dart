// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/google_letter/behaviors/behaviors.dart';

import '../../../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(TestGame.new);

  group(
    'GoogleLetterBallContactBehavior',
    () {
      test('can be instantiated', () {
        expect(
          GoogleLetterBallContactBehavior(),
          isA<GoogleLetterBallContactBehavior>(),
        );
      });

      flameTester.test(
        'beginContact emits onBallContacted when contacts with a ball',
        (game) async {
          final behavior = GoogleLetterBallContactBehavior();
          final bloc = MockGoogleLetterCubit();
          whenListen(
            bloc,
            const Stream<GoogleLetterState>.empty(),
            initialState: GoogleLetterState.active,
          );

          final googleLetter = GoogleLetter.test(bloc: bloc);
          await googleLetter.add(behavior);
          await game.ensureAdd(googleLetter);

          behavior.beginContact(MockBall(), MockContact());

          verify(googleLetter.bloc.onBallContacted).called(1);
        },
      );
    },
  );
}
