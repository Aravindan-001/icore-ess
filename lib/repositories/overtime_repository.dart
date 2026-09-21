import '../models/overtime.dart';

abstract class OvertimeRepository {
  Future<List<OvertimeRequest>> getOvertimeRequests();
  Future<OvertimeRequest> getOvertimeRequestDetail(String id);
}
