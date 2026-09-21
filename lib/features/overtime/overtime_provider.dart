import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/injection_providers.dart';
import '../../models/overtime.dart';

final overtimeRequestsProvider = FutureProvider<List<OvertimeRequest>>((ref) async {
  final service = ref.watch(overtimeServiceProvider);
  return service.getOvertimeRequests();
});

final overtimeDetailProvider = FutureProvider.family<OvertimeRequest, String>((ref, id) async {
  final service = ref.watch(overtimeServiceProvider);
  return service.getOvertimeRequestDetail(id);
});
