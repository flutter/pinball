// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';
import '../../helpers/helpers.dart';

void main() {
  group('GameHud', () {
    testWidgets(
      'renders the current score and balls',
      (tester) async {
        final state = GameState(score: 10, balls: 2);
        final gameBloc = MockGameBloc();
        whenListen(
          gameBloc,
          Stream.value(state),
          initialState: state,
        );

        await tester.pumpApp(
          GameHud(),
          gameBloc: gameBloc,
        );

        expect(find.text('10'), findsOneWidget);
        expect(find.byType(CircleAvatar), findsNWidgets(2));
      },
    );
  });
}
