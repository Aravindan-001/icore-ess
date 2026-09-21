import '../models/overtime.dart';
import '../repositories/overtime_repository.dart';

class OvertimeService {
  final OvertimeRepository _overtimeRepo;

  OvertimeService(this._overtimeRepo);

  Future<List<OvertimeRequest>> getOvertimeRequests() => _overtimeRepo.getOvertimeRequests();
  
  Future<OvertimeRequest> getOvertimeRequestDetail(String id) => 
      _overtimeRepo.getOvertimeRequestDetail(id);
}
