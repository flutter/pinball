import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinball/select_character/select_character.dart';
import 'package:pinball/theme/theme.dart';
import 'package:pinball_flame/pinball_flame.dart';
import 'package:pinball_theme/pinball_theme.dart';

/// {@template selected_character}
/// Widget to display the selected character based on the [CharacterThemeCubit]
/// state.
///
/// Displays the looped [SpriteAnimationWidget] and the character name on the
/// list.
/// {@endtemplate}
class SelectedCharacter extends StatefulWidget {
  /// {@macro selected_character}
  const SelectedCharacter({
    Key? key,
  }) : super(key: key);

  @override
  State<SelectedCharacter> createState() => _SelectedCharacterState();

  /// Returns a list of assets to be loaded.
  static List<Future> loadAssets(BuildContext context) {
    Flame.images.prefix = '';

    const dashTheme = DashTheme();
    const androidTheme = AndroidTheme();
    const dinoTheme = DinoTheme();
    const sparkyTheme = SparkyTheme();

    return [
      Flame.images.load(dashTheme.animation.keyName),
      Flame.images.load(androidTheme.animation.keyName),
      Flame.images.load(dinoTheme.animation.keyName),
      Flame.images.load(sparkyTheme.animation.keyName),
      Flame.images.load(dashTheme.background.keyName),
      Flame.images.load(androidTheme.background.keyName),
      Flame.images.load(dinoTheme.background.keyName),
      Flame.images.load(sparkyTheme.background.keyName),
      precacheImage(AssetImage(dashTheme.background.keyName), context),
      precacheImage(AssetImage(androidTheme.background.keyName), context),
      precacheImage(AssetImage(dinoTheme.background.keyName), context),
      precacheImage(AssetImage(sparkyTheme.background.keyName), context),
    ];
  }
}

class _SelectedCharacterState extends State<SelectedCharacter>
    with TickerProviderStateMixin {
  late SpriteAnimationController _controller;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentCharacter =
        context.select<CharacterThemeCubit, CharacterTheme>(
      (cubit) => cubit.state.characterTheme,
    );
    final spriteSheet = SpriteSheet.fromColumnsAndRows(
      image: Flame.images.fromCache(currentCharacter.animation.keyName),
      columns: 12,
      rows: 6,
    );
    final animation = spriteSheet.createAnimation(
      row: 0,
      stepTime: 1 / 24,
      to: spriteSheet.rows * spriteSheet.columns,
    );

    _controller = SpriteAnimationController(
      vsync: this,
      animation: animation,
    );

    _controller
      ..forward()
      ..repeat();

    return LayoutBuilder(
      builder: (context, constraints) {
        return ListView(
          children: [
            Text(
              currentCharacter.name,
              style: AppTextStyle.headline2.copyWith(
                color: AppColors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: constraints.maxWidth,
              height: constraints.maxWidth,
              child: SpriteAnimationWidget(
                controller: _controller,
              ),
            ),
          ],
        );
      },
    );
  }
}
