import 'package:talker/talker.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

final talker = Talker();

TalkerDioLogger get dioLogger => TalkerDioLogger(
      talker: talker,
      settings: const TalkerDioLoggerSettings(
        printRequestHeaders: false,
        printResponseHeaders: false,
        printResponseMessage: true,
      ),
    );
