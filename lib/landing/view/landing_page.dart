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
        child: TextButton(
          onPressed: () =>
              Navigator.of(context).push<void>(CharacterSelectionPage.route()),
          child: Text(l10n.play),
        ),
      ),
    );
  }
}
