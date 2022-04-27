// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:pinball/gen/gen.dart';
import 'package:pinball/l10n/l10n.dart';
import 'package:pinball/theme/theme.dart';
import 'package:pinball_ui/pinball_ui.dart';

enum Control {
  left,
  right,
  down,
  a,
  d,
  s,
  space,
}

class HowToPlayDialog extends StatelessWidget {
  const HowToPlayDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    const spacing = SizedBox(height: 16);
    final headerTextStyle = AppTextStyle.headline3.copyWith(
      color: AppColors.darkBlue,
    );

    return PinballDialogLayout(
      header: FittedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.howToPlay,
              style: headerTextStyle.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              l10n.tipsForFlips,
              style: headerTextStyle,
            ),
          ],
        ),
      ),
      body: ListView(
        children: const [
          spacing,
          _LaunchControls(),
          spacing,
          _FlipperControls(),
        ],
      ),
    );
  }
}

class _LaunchControls extends StatelessWidget {
  const _LaunchControls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    const spacing = SizedBox(width: 10);

    return Column(
      children: [
        Text(
          l10n.launchControls,
          style: AppTextStyle.headline3.copyWith(
            color: AppColors.white,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          children: const [
            KeyButton(control: Control.down),
            spacing,
            KeyButton(control: Control.space),
            spacing,
            KeyButton(control: Control.s),
          ],
        )
      ],
    );
  }
}

class _FlipperControls extends StatelessWidget {
  const _FlipperControls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    const rowSpacing = SizedBox(width: 20);

    return Column(
      children: [
        Text(
          l10n.flipperControls,
          style: AppTextStyle.headline3.copyWith(
            color: AppColors.white,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 10),
        Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                KeyButton(control: Control.left),
                rowSpacing,
                KeyButton(control: Control.right),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              children: const [
                KeyButton(control: Control.a),
                rowSpacing,
                KeyButton(control: Control.d),
              ],
            )
          ],
        )
      ],
    );
  }
}

@visibleForTesting
class KeyButton extends StatelessWidget {
  const KeyButton({
    Key? key,
    required this.control,
  }) : super(key: key);

  final Control control;

  @override
  Widget build(BuildContext context) {
    final textStyle =
        control.isArrow ? AppTextStyle.headline1 : AppTextStyle.headline3;
    const height = 60.0;
    final width = control.isSpace ? height * 2.83 : height;
    return DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage(
            Assets.images.components.key.keyName,
          ),
        ),
      ),
      child: SizedBox(
        width: width,
        height: height,
        child: Center(
          child: RotatedBox(
            quarterTurns: control.isDown ? 1 : 0,
            child: Text(
              control.getCharacter(context),
              style: textStyle.copyWith(color: AppColors.white),
            ),
          ),
        ),
      ),
    );
  }
}

extension on Control {
  bool get isArrow => isDown || isRight || isLeft;
  bool get isDown => this == Control.down;
  bool get isRight => this == Control.right;
  bool get isLeft => this == Control.left;
  bool get isSpace => this == Control.space;
  String getCharacter(BuildContext context) {
    switch (this) {
      case Control.a:
        return 'A';
      case Control.d:
        return 'D';
      case Control.down:
        return '>'; // Will be rotated
      case Control.left:
        return '<';
      case Control.right:
        return '>';
      case Control.s:
        return 'S';
      case Control.space:
        return context.l10n.space;
    }
  }
}
