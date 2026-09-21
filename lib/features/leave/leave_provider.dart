import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/injection_providers.dart';
import '../../models/leave.dart';

final leaveBalancesProvider = FutureProvider<List<LeaveBalance>>((ref) async {
  final service = ref.watch(leaveServiceProvider);
  return service.getLeaveBalances();
});

final leaveRequestsProvider = FutureProvider<List<LeaveRequest>>((ref) async {
  final service = ref.watch(leaveServiceProvider);
  return service.getLeaveRequests();
});

class ApplyLeaveState {
  final bool isLoading;
  final String? errorMessage;
  final String? successRequestId;

  ApplyLeaveState({
    required this.isLoading,
    this.errorMessage,
    this.successRequestId,
  });

  factory ApplyLeaveState.initial() => ApplyLeaveState(isLoading: false);
  factory ApplyLeaveState.loading() => ApplyLeaveState(isLoading: true);
  factory ApplyLeaveState.success(String requestId) => ApplyLeaveState(isLoading: false, successRequestId: requestId);
  factory ApplyLeaveState.error(String message) => ApplyLeaveState(isLoading: false, errorMessage: message);
}

class ApplyLeaveNotifier extends StateNotifier<ApplyLeaveState> {
  final Ref _ref;

  ApplyLeaveNotifier(this._ref) : super(ApplyLeaveState.initial());

  Future<bool> submitLeave({
    required String type,
    required DateTime startDate,
    required DateTime endDate,
    required String reason,
  }) async {
    state = ApplyLeaveState.loading();
    try {
      final reqId = 'LR${DateTime.now().millisecondsSinceEpoch}';
      
      // We directly construct the model and call the service
      final request = LeaveRequest(
        id: reqId,
        type: type,
        startDate: startDate,
        endDate: endDate,
        reason: reason,
        status: LeaveStatus.pending,
        appliedDate: DateTime.now(),
      );

      final repo = _ref.read(leaveRepositoryProvider);
      final success = await repo.applyLeave(request);
      if (success) {
        state = ApplyLeaveState.success(reqId);
        // Refresh leave providers
        _ref.invalidate(leaveBalancesProvider);
        _ref.invalidate(leaveRequestsProvider);
        return true;
      } else {
        state = ApplyLeaveState.error('Failed to submit leave request.');
        return false;
      }
    } catch (e) {
      state = ApplyLeaveState.error(e.toString());
      return false;
    }
  }

  void reset() {
    state = ApplyLeaveState.initial();
  }
}

final applyLeaveNotifierProvider = StateNotifierProvider<ApplyLeaveNotifier, ApplyLeaveState>((ref) {
  return ApplyLeaveNotifier(ref);
});
