import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/assets_manager/cubit/assets_manager_cubit.dart';
import 'package:pinball/assets_manager/views/assets_loading_page.dart';
import 'package:pinball_ui/pinball_ui.dart';
import '../../helpers/helpers.dart';

void main() {
  late AssetsManagerCubit assetsManagerCubit;

  setUp(() {
    final initialAssetsState = AssetsManagerState(
      loadables: [Future<void>.value()],
      loaded: const [],
    );
    assetsManagerCubit = MockAssetsManagerCubit();
    whenListen(
      assetsManagerCubit,
      Stream.value(initialAssetsState),
      initialState: initialAssetsState,
    );
  });

  group('AssetsLoadingPage', () {
    testWidgets('renders an animated text and a pinball loading indicator',
        (tester) async {
      await tester.pumpApp(
        const AssetsLoadingPage(),
        assetsManagerCubit: assetsManagerCubit,
      );
      expect(find.byType(AnimatedEllipsisText), findsOneWidget);
      expect(find.byType(PinballLoadingIndicator), findsOneWidget);
    });
  });
}
