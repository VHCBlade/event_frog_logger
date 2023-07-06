import 'package:event_db/event_db.dart';
import 'package:tuple/tuple.dart';

/// The Model that is used to represent all kinds of logs.
class LogModel extends GenericModel {
  /// Empty Constructor
  LogModel();

  /// Convenience function that creates a newly create [LogModel] for right now.
  LogModel.fromLog({
    required this.log,
    required this.logType,
    required this.isError,
  }) : dateTime = DateTime.now();

  /// The time that log was made.
  DateTime? dateTime;

  /// The message for the log
  String? log;

  /// The special type of this log to categorize this log.
  String? logType;

  /// Whether the log represents an error or not.
  bool isError = false;

  @override
  // ignore: strict_raw_type
  Map<String, Tuple2<Getter, Setter>> getGetterSetterMap() => {
        'dateTime':
            GenericModel.dateTime(() => dateTime, (value) => dateTime = value),
        'log': GenericModel.primitive(() => log, (value) => log = value),
        'logType': GenericModel.primitive(() => log, (value) => log = value),
        'isError': GenericModel.primitive(
          () => isError,
          (value) => isError = value ?? false,
        ),
      };

  @override
  String get type => 'LogModel';
}
