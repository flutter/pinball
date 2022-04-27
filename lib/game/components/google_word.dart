// ignore_for_file: avoid_renaming_method_parameters

import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template google_word}
/// Loads all [GoogleLetter]s to compose a [GoogleWord].
/// {@endtemplate}
class GoogleWord extends Component
    with HasGameRef<PinballGame>, Controls<_GoogleWordController> {
  /// {@macro google_word}
  GoogleWord({
    required Vector2 position,
  }) : _position = position {
    controller = _GoogleWordController(this);
  }

  final Vector2 _position;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    gameRef.addContactCallback(_GoogleLetterBallContactCallback());

    final offsets = [
      Vector2(-12.92, 1.82),
      Vector2(-8.33, -0.65),
      Vector2(-2.88, -1.75),
      Vector2(2.88, -1.75),
      Vector2(8.33, -0.65),
      Vector2(12.92, 1.82),
    ];

    final letters = <GoogleLetter>[];
    for (var index = 0; index < offsets.length; index++) {
      letters.add(
        GoogleLetter(index)..initialPosition = _position + offsets[index],
      );
    }

    await addAll(letters);
  }
}

class _GoogleWordController extends ComponentController<GoogleWord>
    with HasGameRef<PinballGame> {
  _GoogleWordController(GoogleWord googleWord) : super(googleWord);

  final _activatedLetters = <GoogleLetter>{};

  Future<void> activate(GoogleLetter googleLetter) async {
    if (!_activatedLetters.add(googleLetter)) return;

    googleLetter.activate();

    final activatedBonus = _activatedLetters.length == 6;
    if (activatedBonus) {
      gameRef.audio.googleBonus();
      gameRef.read<GameBloc>().add(const BonusActivated(GameBonus.googleWord));
      await _bonusAnimation();
      _activatedLetters.clear();
    }
  }

  Future<void> _bonusAnimation() async {
    const blinkDuration = Duration(milliseconds: 300);
    const blinkCount = 4;
    final googleLetters = component.children.whereType<GoogleLetter>();
    var shouldActivate = false;

    await Future<void>.delayed(blinkDuration);
    for (var i = 1; i < blinkCount * 2; i++) {
      for (final letter in googleLetters) {
        if (shouldActivate) {
          letter.activate();
        } else {
          letter.deactivate();
        }
      }
      shouldActivate = !shouldActivate;
      await Future<void>.delayed(blinkDuration);
    }
  }
}

/// Activates a [GoogleLetter] when it contacts with a [Ball].
class _GoogleLetterBallContactCallback
    extends ContactCallback<GoogleLetter, Ball> {
  @override
  void begin(GoogleLetter googleLetter, _, __) {
    final parent = googleLetter.parent;
    if (parent is GoogleWord) {
      parent.controller.activate(googleLetter);
    }
  }
}
