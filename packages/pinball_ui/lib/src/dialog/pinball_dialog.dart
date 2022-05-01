import 'package:flutter/material.dart';
import 'package:pinball_ui/pinball_ui.dart';

/// {@template pinball_dialog}
/// Pinball-themed dialog.
/// {@endtemplate}
class PinballDialog extends StatelessWidget {
  /// {@macro pinball_dialog}
  const PinballDialog({
    Key? key,
    required this.title,
    required this.child,
    this.subtitle,
  }) : super(key: key);

  /// Title shown in the dialog.
  final String title;

  /// Optional subtitle shown below the [title].
  final String? subtitle;

  /// Body of the dialog.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.5;
    return Center(
      child: SizedBox(
        height: height,
        width: height * 1.4,
        child: PixelatedDecoration(
          header: subtitle != null
              ? _TitleAndSubtitle(title: title, subtitle: subtitle!)
              : _Title(title: title),
          body: child,
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) => Text(
        title,
        style: Theme.of(context).textTheme.headline3!.copyWith(
              fontWeight: FontWeight.bold,
              color: PinballColors.darkBlue,
            ),
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
      );
}

class _TitleAndSubtitle extends StatelessWidget {
  const _TitleAndSubtitle({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _Title(title: title),
        Text(
          subtitle,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: textTheme.headline3!.copyWith(fontWeight: FontWeight.normal),
        ),
      ],
    );
  }
}
