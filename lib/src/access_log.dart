import 'package:dart_frog/dart_frog.dart' as dart_frog;
import 'package:event_db/event_db.dart';
import 'package:event_frog_logger/event_frog_logger.dart';
import 'package:intl/intl.dart';

/// Determines how to load the database from the loader
typedef DatabaseLoader = DatabaseRepository Function(dart_frog.RequestContext);

final _monthFormatter = DateFormat('yyyy-MM');

DatabaseRepository _defaultLoadDatabase(dart_frog.RequestContext context) =>
    context.read<DatabaseRepository>();

/// Provides a [dart_frog.requestLogger] [dart_frog.Middleware] that
/// automatically logs the access logs to the appropriate database based on the
/// result of [logDBNow]
class AccessLogger {
  /// [accessLogDBBase] is used to determine the base name of the database for
  /// the access logs.
  ///
  /// [accessLogType] determines the [LogModel.logType] used for the access logs
  const AccessLogger({
    this.accessLogDBBase = _defaultAccessLogDBBase,
    this.accessLogType = _defaultAccessLogType,
    this.loader = _defaultLoadDatabase,
  });

  static const _defaultAccessLogDBBase = 'Logs';
  static const _defaultAccessLogType = 'AccessLog';

  /// Used to determine the base name of the database for the access logs.
  final String accessLogDBBase;

  /// Determines the [LogModel.logType] used for the access logs
  final String accessLogType;

  final DatabaseLoader loader;

  /// Creates the database name for new access logs made right now
  String get logDBNow => logDBForDateTime(DateTime.now());

  /// Creates the database name for logs made during the given [dateTime]
  String logDBForDateTime(DateTime dateTime) {
    return '$accessLogDBBase-${_monthFormatter.format(dateTime)}';
  }

  /// Creates a [dart_frog.requestLogger] [dart_frog.Middleware] that
  /// automatically logs the access logs to the appropriate database based on
  /// the result of [logDBNow] with a [LogModel.type] of [accessLogType]
  dart_frog.Middleware get requestLogger => (dart_frog.Handler handler) =>
      (dart_frog.RequestContext context) => dart_frog.requestLogger(
            logger: (log, isError) async => await loader(context).saveModel(
              logDBNow,
              LogModel.fromLog(
                log: log,
                isError: isError,
                logType: accessLogType,
              ),
            ),
          )(handler)(context);
}
