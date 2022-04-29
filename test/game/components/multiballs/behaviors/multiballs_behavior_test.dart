import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/components/multiballs/behaviors/behaviors.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final assets = [
    Assets.images.multiball.lit.keyName,
    Assets.images.multiball.dimmed.keyName,
  ];

  group('MultiballsBehavior', () {
    late GameBloc gameBloc;

    setUp(() {
      gameBloc = MockGameBloc();
      whenListen(
        gameBloc,
        const Stream<GameState>.empty(),
        initialState: const GameState.initial(),
      );
    });

    final flameBlocTester = FlameBlocTester<PinballGame, GameBloc>(
      gameBuilder: EmptyPinballTestGame.new,
      blocBuilder: () => gameBloc,
      assets: assets,
    );
  });
}
