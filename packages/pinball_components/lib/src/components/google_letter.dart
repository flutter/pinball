import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

enum GoogleLetterSpriteState {
  lit,
  dimmed,
}

/// {@template google_letter}
/// Circular decal that represents a letter in "GOOGLE" for a given index.
/// {@endtemplate}
class GoogleLetter extends PositionComponent {
  /// {@macro google_letter}
  GoogleLetter(int index)
      : super(
          children: [
            GoogleLetterSpriteGroupComponent(
              litAssetPath: _spritePaths[index][GoogleLetterSpriteState.lit]!,
              dimmedAssetPath: _spritePaths[index]
                  [GoogleLetterSpriteState.dimmed]!,
              index: index,
            ),
          ],
        );
}

@visibleForTesting
class GoogleLetterSpriteGroupComponent
    extends SpriteGroupComponent<GoogleLetterSpriteState>
    with HasGameRef, FlameBlocListenable<GoogleWordCubit, GoogleWordState> {
  GoogleLetterSpriteGroupComponent({
    required String litAssetPath,
    required String dimmedAssetPath,
    required int index,
  })  : _litAssetPath = litAssetPath,
        _dimmedAssetPath = dimmedAssetPath,
        _index = index,
        super(anchor: Anchor.center);

  final String _litAssetPath;
  final String _dimmedAssetPath;
  final int _index;

  @override
  bool listenWhen(GoogleWordState previousState, GoogleWordState newState) {
    return previousState.letterSpriteStates[_index] !=
        newState.letterSpriteStates[_index];
  }

  @override
  void onNewState(GoogleWordState state) =>
      current = state.letterSpriteStates[_index];

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final sprites = {
      GoogleLetterSpriteState.lit: Sprite(
        gameRef.images.fromCache(_litAssetPath),
      ),
      GoogleLetterSpriteState.dimmed: Sprite(
        gameRef.images.fromCache(_dimmedAssetPath),
      ),
    };
    this.sprites = sprites;
    current = readBloc<GoogleWordCubit, GoogleWordState>()
        .state
        .letterSpriteStates[_index];
    size = sprites[current]!.originalSize / 10;
  }
}

final _spritePaths = <Map<GoogleLetterSpriteState, String>>[
  {
    GoogleLetterSpriteState.lit: Assets.images.googleWord.letter1.lit.keyName,
    GoogleLetterSpriteState.dimmed:
        Assets.images.googleWord.letter1.dimmed.keyName,
  },
  {
    GoogleLetterSpriteState.lit: Assets.images.googleWord.letter2.lit.keyName,
    GoogleLetterSpriteState.dimmed:
        Assets.images.googleWord.letter2.dimmed.keyName,
  },
  {
    GoogleLetterSpriteState.lit: Assets.images.googleWord.letter3.lit.keyName,
    GoogleLetterSpriteState.dimmed:
        Assets.images.googleWord.letter3.dimmed.keyName,
  },
  {
    GoogleLetterSpriteState.lit: Assets.images.googleWord.letter4.lit.keyName,
    GoogleLetterSpriteState.dimmed:
        Assets.images.googleWord.letter4.dimmed.keyName,
  },
  {
    GoogleLetterSpriteState.lit: Assets.images.googleWord.letter5.lit.keyName,
    GoogleLetterSpriteState.dimmed:
        Assets.images.googleWord.letter5.dimmed.keyName,
  },
  {
    GoogleLetterSpriteState.lit: Assets.images.googleWord.letter6.lit.keyName,
    GoogleLetterSpriteState.dimmed:
        Assets.images.googleWord.letter6.dimmed.keyName,
  },
];
