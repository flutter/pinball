import 'package:dashbook/dashbook.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/error_component/error_component_game.dart';

void addErrorComponentStories(Dashbook dashbook) {
  dashbook.storiesOf('ErrorComponent').addGame(
        title: 'Basic',
        description: ErrorComponentGame.description,
        gameBuilder: (context) => ErrorComponentGame(
          text: context.textProperty(
            'label',
            'Oh no, something went wrong!',
          ),
        ),
      );
}
