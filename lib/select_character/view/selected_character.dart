import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:pinball_flame/pinball_flame.dart';
import 'package:pinball_theme/pinball_theme.dart';

/// {@template selected_character}
/// Shows an animated version of the character currently selected.
/// {@endtemplate}
class SelectedCharacter extends StatefulWidget {
  /// {@macro selected_character}
  const SelectedCharacter({
    Key? key,
    required this.currentCharacter,
  }) : super(key: key);

  /// The character that is selected at the moment.
  final CharacterTheme currentCharacter;

  @override
  State<SelectedCharacter> createState() => _SelectedCharacterState();

  /// Returns a list of assets to be loaded.
  static List<Future> loadAssets() {
    return [
      Flame.images.load(const DashTheme().animation.keyName),
      Flame.images.load(const AndroidTheme().animation.keyName),
      Flame.images.load(const DinoTheme().animation.keyName),
      Flame.images.load(const SparkyTheme().animation.keyName),
    ];
  }
}

class _SelectedCharacterState extends State<SelectedCharacter>
    with TickerProviderStateMixin {
  SpriteAnimationController? _controller;

  @override
  void initState() {
    super.initState();
    _setupCharacterAnimation();
  }

  @override
  void didUpdateWidget(covariant SelectedCharacter oldWidget) {
    super.didUpdateWidget(oldWidget);
    _setupCharacterAnimation();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.currentCharacter.name,
          style: Theme.of(context).textTheme.headline2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: SpriteAnimationWidget(
                  controller: _controller!,
                  anchor: Anchor.center,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _setupCharacterAnimation() {
    final spriteSheet = SpriteSheet.fromColumnsAndRows(
      image: Flame.images.fromCache(widget.currentCharacter.animation.keyName),
      columns: 12,
      rows: 6,
    );
    final animation = spriteSheet.createAnimation(
      row: 0,
      stepTime: 1 / 24,
      to: spriteSheet.rows * spriteSheet.columns,
    );
    if (_controller != null) _controller?.dispose();
    _controller = SpriteAnimationController(vsync: this, animation: animation)
      ..forward()
      ..repeat();
  }
}
