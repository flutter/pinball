// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:pinball/l10n/l10n.dart';
import 'package:pinball/theme/theme.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () => Navigator.of(context).push<void>(
                CharacterSelectionPage.route(),
              ),
              child: Text(l10n.play),
            ),
            TextButton(
              onPressed: () => showDialog<void>(
                context: context,
                builder: (_) => const _HowToPlayDialog(),
              ),
              child: Text(l10n.howToPlay),
            ),
          ],
        ),
      ),
    );
  }
}

class _HowToPlayDialog extends StatelessWidget {
  const _HowToPlayDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    const spacing = SizedBox(height: 16);

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.howToPlay),
            spacing,
            const _LaunchControls(),
            spacing,
            const _FlipperControls(),
          ],
        ),
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
        Text(l10n.launchControls),
        const SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            KeyIndicator.fromIcon(keyIcon: Icons.keyboard_arrow_down),
            spacing,
            KeyIndicator.fromKeyName(keyName: 'SPACE'),
            spacing,
            KeyIndicator.fromKeyName(keyName: 'S'),
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
        Text(l10n.flipperControls),
        const SizedBox(height: 10),
        Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                KeyIndicator.fromIcon(keyIcon: Icons.keyboard_arrow_left),
                rowSpacing,
                KeyIndicator.fromIcon(keyIcon: Icons.keyboard_arrow_right),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                KeyIndicator.fromKeyName(keyName: 'A'),
                rowSpacing,
                KeyIndicator.fromKeyName(keyName: 'D'),
              ],
            )
          ],
        )
      ],
    );
  }
}

// TODO(allisonryan0002): remove visibility when adding final UI.
@visibleForTesting
class KeyIndicator extends StatelessWidget {
  const KeyIndicator._({
    Key? key,
    required String keyName,
    required IconData keyIcon,
    required bool fromIcon,
  })  : _keyName = keyName,
        _keyIcon = keyIcon,
        _fromIcon = fromIcon,
        super(key: key);

  const KeyIndicator.fromKeyName({Key? key, required String keyName})
      : this._(
          key: key,
          keyName: keyName,
          keyIcon: Icons.keyboard_arrow_down,
          fromIcon: false,
        );

  const KeyIndicator.fromIcon({Key? key, required IconData keyIcon})
      : this._(
          key: key,
          keyName: '',
          keyIcon: keyIcon,
          fromIcon: true,
        );

  final String _keyName;

  final IconData _keyIcon;

  final bool _fromIcon;

  @override
  Widget build(BuildContext context) {
    const iconPadding = EdgeInsets.all(15);
    const textPadding = EdgeInsets.symmetric(vertical: 20, horizontal: 22);
    final boarderColor = Colors.blue.withOpacity(0.5);
    final color = Colors.blue.withOpacity(0.7);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: boarderColor,
          width: 3,
        ),
      ),
      child: _fromIcon
          ? Padding(
              padding: iconPadding,
              child: Icon(_keyIcon, color: color),
            )
          : Padding(
              padding: textPadding,
              child: Text(_keyName, style: TextStyle(color: color)),
            ),
    );
  }
}
