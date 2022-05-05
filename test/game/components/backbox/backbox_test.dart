// ignore_for_file: cascade_invocations, prefer_const_constructors

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/components/backbox/bloc/backbox_bloc.dart';
import 'package:pinball/game/components/backbox/displays/displays.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/l10n/l10n.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_theme/pinball_theme.dart' as theme;

import '../../../helpers/helpers.dart';

class _MockRawKeyUpEvent extends Mock implements RawKeyUpEvent {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return super.toString();
  }
}

RawKeyUpEvent _mockKeyUp(LogicalKeyboardKey key) {
  final event = _MockRawKeyUpEvent();
  when(() => event.logicalKey).thenReturn(key);
  return event;
}

class _MockBackboxBloc extends Mock implements BackboxBloc {}

class _MockLeaderboardRepository extends Mock implements LeaderboardRepository {
}

class _MockAppLocalizations extends Mock implements AppLocalizations {
  @override
  String get score => '';

  @override
  String get name => '';

  @override
  String get enterInitials => '';

  @override
  String get arrows => '';

  @override
  String get andPress => '';

  @override
  String get enterReturn => '';

  @override
  String get toSubmit => '';

  @override
  String get loading => '';
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const character = theme.AndroidTheme();
  final assets = [
    character.leaderboardIcon.keyName,
    Assets.images.backbox.marquee.keyName,
    Assets.images.backbox.displayDivider.keyName,
  ];
  final flameTester = FlameTester(
    () => EmptyPinballTestGame(
      assets: assets,
      l10n: _MockAppLocalizations(),
    ),
  );

  late BackboxBloc bloc;

  setUp(() {
    bloc = _MockBackboxBloc();
    whenListen(
      bloc,
      Stream.value(LoadingState()),
      initialState: LoadingState(),
    );
  });

  group('Backbox', () {
    flameTester.test(
      'loads correctly',
      (game) async {
        final backbox = Backbox.test(bloc: bloc);
        await game.ensureAdd(backbox);

        expect(game.children, contains(backbox));
      },
    );

    flameTester.testGameWidget(
      'renders correctly',
      setUp: (game, tester) async {
        await game.images.loadAll(assets);
        game.camera
          ..followVector2(Vector2(0, -130))
          ..zoom = 6;
        await game.ensureAdd(
          Backbox.test(bloc: bloc),
        );
        await tester.pump();
      },
      verify: (game, tester) async {
        await expectLater(
          find.byGame<EmptyPinballTestGame>(),
          matchesGoldenFile('../golden/backbox.png'),
        );
      },
    );

    flameTester.test(
      'requestInitials adds InitialsInputDisplay',
      (game) async {
        final backbox = Backbox.test(
          bloc: BackboxBloc(
            leaderboardRepository: _MockLeaderboardRepository(),
          ),
        );
        await game.ensureAdd(backbox);
        backbox.requestInitials(
          score: 0,
          character: character,
        );
        await game.ready();

        expect(
          backbox.descendants().whereType<InitialsInputDisplay>().length,
          equals(1),
        );
      },
    );

    flameTester.test(
      'adds PlayerInitialsSubmitted when initials are submitted',
      (game) async {
        final bloc = _MockBackboxBloc();
        final state = InitialsFormState(
          score: 10,
          character: theme.AndroidTheme(),
        );
        whenListen(
          bloc,
          Stream.value(state),
          initialState: state,
        );
        final backbox = Backbox.test(bloc: bloc);
        await game.ensureAdd(backbox);

        game.onKeyEvent(_mockKeyUp(LogicalKeyboardKey.enter), {});
        verify(
          () => bloc.add(
            PlayerInitialsSubmitted(
              score: 10,
              initials: 'AAA',
              character: theme.AndroidTheme(),
            ),
          ),
        ).called(1);
      },
    );

    flameTester.test(
      'adds InitialsSubmissionSuccessDisplay on InitialsSuccessState',
      (game) async {
        whenListen(
          bloc,
          Stream.value(InitialsSuccessState()),
          initialState: InitialsSuccessState(),
        );
        final backbox = Backbox.test(bloc: bloc);
        await game.ensureAdd(backbox);

        expect(
          game
              .descendants()
              .whereType<InitialsSubmissionSuccessDisplay>()
              .length,
          equals(1),
        );
      },
    );

    flameTester.test(
      'adds InitialsSubmissionFailureDisplay on InitialsFailureState',
      (game) async {
        whenListen(
          bloc,
          Stream.value(InitialsFailureState()),
          initialState: InitialsFailureState(),
        );
        final backbox = Backbox.test(bloc: bloc);
        await game.ensureAdd(backbox);

        expect(
          game
              .descendants()
              .whereType<InitialsSubmissionFailureDisplay>()
              .length,
          equals(1),
        );
      },
    );

    flameTester.test(
      'closes the subscription when it is removed',
      (game) async {
        final streamController = StreamController<BackboxState>();
        whenListen(
          bloc,
          streamController.stream,
          initialState: LoadingState(),
        );

        final backbox = Backbox.test(bloc: bloc);
        await game.ensureAdd(backbox);

        backbox.removeFromParent();
        await game.ready();

        streamController.add(InitialsFailureState());
        await game.ready();

        expect(
          backbox
              .descendants()
              .whereType<InitialsSubmissionFailureDisplay>()
              .isEmpty,
          isTrue,
        );
      },
    );
  });
}
