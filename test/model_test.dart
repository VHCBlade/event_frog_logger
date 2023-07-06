import 'package:event_db_tester/event_db_tester.dart';
import 'package:event_frog_logger/event_frog_logger.dart';
import 'package:test/test.dart';
import 'package:tuple/tuple.dart';

void main() {
  group('Models', () {
    genericModelTest(models: models);
  });
}

final models = {
  'LogModel': () => Tuple2(
        LogModel()
          ..dateTime = DateTime(2020)
          ..isError = true
          ..log = 'Amazing'
          ..logType = 'Incredible',
        LogModel.new,
      ),
};
