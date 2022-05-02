import 'package:flame/components.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

class SignPostProgressingBehavior extends Component with ParentIsA<Signpost> {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
  }
}
