// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pinball/gen/gen.dart';
import 'package:pinball/l10n/l10n.dart';
import 'package:pinball_ui/pinball_ui.dart';
import 'package:platform_helper/platform_helper.dart';

@visibleForTesting
enum Control {
  left,
  right,
  down,
  a,
  d,
  s,
  space,
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

Future<void> showHowToPlayDialog(BuildContext context) {
  final height = MediaQuery.of(context).size.height * 0.5;
  return showDialog<void>(
    context: context,
    builder: (context) {
      return Center(
        child: SizedBox(
          height: height,
          width: height * 1.4,
          child: HowToPlayDialog(),
        ),
      );
    },
  );
}

class HowToPlayDialog extends StatefulWidget {
  HowToPlayDialog({
    Key? key,
    @visibleForTesting PlatformHelper? platformHelper,
  })  : platformHelper = platformHelper ?? PlatformHelper(),
        super(key: key);

  final PlatformHelper platformHelper;

  @override
  State<HowToPlayDialog> createState() => _HowToPlayDialogState();
}

class _HowToPlayDialogState extends State<HowToPlayDialog> {
  late Timer closeTimer;
  @override
  void initState() {
    super.initState();
    closeTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    closeTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = widget.platformHelper.isMobile;
    return PixelatedDecoration(
      header: const _HowToPlayHeader(),
      body: isMobile ? const _MobileBody() : const _DesktopBody(),
    );
  }
}

class _MobileBody extends StatelessWidget {
  const _MobileBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final paddingWidth = MediaQuery.of(context).size.width * 0.15;
    final paddingHeight = MediaQuery.of(context).size.height * 0.075;
    return FittedBox(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: paddingWidth,
        ),
        child: Column(
          children: [
            const _MobileLaunchControls(),
            SizedBox(height: paddingHeight),
            const _MobileFlipperControls(),
          ],
        ),
      ),
    );
  }
}

class _MobileLaunchControls extends StatelessWidget {
  const _MobileLaunchControls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textStyle = Theme.of(context)
        .textTheme
        .headline3!
        .copyWith(color: PinballColors.white);
    return Column(
      children: [
        Text(
          l10n.tapAndHoldRocket,
          style: textStyle,
        ),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '${l10n.to} ',
                style: textStyle,
              ),
              TextSpan(
                text: l10n.launch,
                style: textStyle.copyWith(color: PinballColors.blue),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MobileFlipperControls extends StatelessWidget {
  const _MobileFlipperControls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textStyle = Theme.of(context)
        .textTheme
        .headline3!
        .copyWith(color: PinballColors.white);
    return Column(
      children: [
        Text(
          l10n.tapLeftRightScreen,
          style: textStyle,
        ),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '${l10n.to} ',
                style: textStyle,
              ),
              TextSpan(
                text: l10n.flip,
                style: textStyle.copyWith(color: PinballColors.orange),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DesktopBody extends StatelessWidget {
  const _DesktopBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const spacing = SizedBox(height: 16);
    return ListView(
      children: const [
        spacing,
        _DesktopLaunchControls(),
        spacing,
        _DesktopFlipperControls(),
      ],
    );
  }
}

class _HowToPlayHeader extends StatelessWidget {
  const _HowToPlayHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textStyle = Theme.of(context).textTheme.headline3?.copyWith(
          color: PinballColors.darkBlue,
        );
    return FittedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            l10n.howToPlay,
            style: textStyle?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            l10n.tipsForFlips,
            style: textStyle,
          ),
        ],
      ),
    );
  }
}

class _DesktopLaunchControls extends StatelessWidget {
  const _DesktopLaunchControls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    const spacing = SizedBox(width: 10);

    return Column(
      children: [
        Text(
          l10n.launchControls,
          style: Theme.of(context).textTheme.headline4,
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

class _DesktopFlipperControls extends StatelessWidget {
  const _DesktopFlipperControls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    const rowSpacing = SizedBox(width: 20);

    return Column(
      children: [
        Text(
          l10n.flipperControls,
          style: Theme.of(context).textTheme.subtitle2,
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
    required Control control,
  })  : _control = control,
        super(key: key);

  final Control _control;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final textStyle =
        _control.isArrow ? textTheme.headline1 : textTheme.headline3;
    const height = 60.0;
    final width = _control.isSpace ? height * 2.83 : height;
    return DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage(
            _control.isSpace
                ? Assets.images.components.space.keyName
                : Assets.images.components.key.keyName,
          ),
        ),
      ),
      child: SizedBox(
        width: width,
        height: height,
        child: Center(
          child: RotatedBox(
            quarterTurns: _control.isDown ? 1 : 0,
            child: Text(
              _control.getCharacter(context),
              style: textStyle?.copyWith(color: PinballColors.white),
            ),
          ),
        ),
      ),
    );
  }
}
