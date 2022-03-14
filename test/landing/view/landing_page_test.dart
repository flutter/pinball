import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:pinball/landing/landing.dart';

import '../../helpers/helpers.dart';

void main() {
  group('LandingPage', () {
    testWidgets('renders TextButton', (tester) async {
      await tester.pumpApp(const LandingPage());
      expect(find.byType(TextButton), findsOneWidget);
    });

    testWidgets('tapping on TextButton navigates to CharacterSelectionPage',
        (tester) async {
      final navigator = MockNavigator();
      when(() => navigator.push<void>(any())).thenAnswer((_) async {});

      await tester.pumpApp(
        const LandingPage(),
        navigator: navigator,
      );
      await tester.tap(
        find.byType(
          TextButton,
        ),
      );

      verify(() => navigator.push<void>(any())).called(1);
    });
  });
}
