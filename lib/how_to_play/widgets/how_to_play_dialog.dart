import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinball/gen/gen.dart';
import 'package:pinball/l10n/l10n.dart';
import 'package:pinball_audio/pinball_audio.dart';
import 'package:pinball_ui/pinball_ui.dart';
import 'package:platform_helper/platform_helper.dart';

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

class HowToPlayDialog extends StatefulWidget {
  HowToPlayDialog({
    Key? key,
    required this.onDismissCallback,
    @visibleForTesting PlatformHelper? platformHelper,
  })  : platformHelper = platformHelper ?? PlatformHelper(),
        super(key: key);

  final PlatformHelper platformHelper;
  final VoidCallback onDismissCallback;

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
        widget.onDismissCallback.call();
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
    final l10n = context.l10n;

    return WillPopScope(
      onWillPop: () {
        widget.onDismissCallback.call();
        context.read<PinballPlayer>().play(PinballAudio.ioPinballVoiceOver);
        return Future.value(true);
      },
      child: PinballDialog(
        title: l10n.howToPlay,
        subtitle: l10n.tipsForFlips,
        child: FittedBox(
          child: isMobile ? const _MobileBody() : const _DesktopBody(),
        ),
      ),
    );
  }
}

class _MobileBody extends StatelessWidget {
  const _MobileBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final paddingWidth = MediaQuery.of(context).size.width * 0.15;
    final paddingHeight = MediaQuery.of(context).size.height * 0.075;
    return Padding(
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
    );
  }
}

class _MobileLaunchControls extends StatelessWidget {
  const _MobileLaunchControls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final headline3 = Theme.of(context)
        .textTheme
        .headline3!
        .copyWith(color: PinballColors.white);
    return Column(
      children: [
        Text(l10n.tapAndHoldRocket, style: headline3),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: '${l10n.to} ', style: headline3),
              TextSpan(
                text: l10n.launch,
                style: headline3.copyWith(color: PinballColors.blue),
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
    final headline3 = Theme.of(context)
        .textTheme
        .headline3!
        .copyWith(color: PinballColors.white);
    return Column(
      children: [
        Text(l10n.tapLeftRightScreen, style: headline3),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: '${l10n.to} ', style: headline3),
              TextSpan(
                text: l10n.flip,
                style: headline3.copyWith(color: PinballColors.orange),
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
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: const [
          _DesktopLaunchControls(),
          SizedBox(height: 16),
          _DesktopFlipperControls(),
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
    return Column(
      children: [
        Text(
          l10n.launchControls,
          style: Theme.of(context).textTheme.headline4,
        ),
        const SizedBox(height: 10),
        Wrap(
          children: const [
            _KeyButton(control: Control.down),
            SizedBox(width: 10),
            _KeyButton(control: Control.space),
            SizedBox(width: 10),
            _KeyButton(control: Control.s),
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
    return Column(
      children: [
        Text(
          l10n.flipperControls,
          style: Theme.of(context).textTheme.headline4,
        ),
        const SizedBox(height: 10),
        Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                _KeyButton(control: Control.left),
                SizedBox(width: 20),
                _KeyButton(control: Control.right),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              children: const [
                _KeyButton(control: Control.a),
                SizedBox(width: 20),
                _KeyButton(control: Control.d),
              ],
            )
          ],
        )
      ],
    );
  }
}

class _KeyButton extends StatelessWidget {
  const _KeyButton({Key? key, required this.control}) : super(key: key);

  final Control control;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final textStyle =
        control.isArrow ? textTheme.headline1 : textTheme.headline3;
    const height = 60.0;
    final width = control.isSpace ? height * 2.83 : height;
    return DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage(
            control.isSpace
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
            quarterTurns: control.isDown ? 1 : 0,
            child: Text(
              control.getCharacter(context),
              style: textStyle?.copyWith(color: PinballColors.white),
            ),
          ),
        ),
      ),
    );
  }
}
