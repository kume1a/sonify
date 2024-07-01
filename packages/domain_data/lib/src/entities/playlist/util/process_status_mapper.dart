import 'package:common_utilities/common_utilities.dart';

import '../model/process_status.dart';

final class ProcessStatusMapper extends EnumMapper<ProcessStatus, String> {
  @override
  Map<String, ProcessStatus> values = {
    'PROCESSING': ProcessStatus.processing,
    'COMPLETED': ProcessStatus.completed,
    'FAILED': ProcessStatus.failed,
    'PENDING': ProcessStatus.pending,
  };
}
