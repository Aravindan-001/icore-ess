import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/injection_providers.dart';
import '../../models/unified_request.dart';

final allRequestsProvider = FutureProvider<List<UnifiedRequest>>((ref) async {
  final service = ref.watch(requestsServiceProvider);
  return service.getAllRequests();
});

enum RequestFilter { all, pending, approved, rejected }

final requestFilterProvider = StateProvider<RequestFilter>((ref) => RequestFilter.all);
final requestCategoryFilterProvider = StateProvider<RequestModule?>((ref) => null);

final filteredRequestsProvider = Provider<AsyncValue<List<UnifiedRequest>>>((ref) {
  final requestsAsync = ref.watch(allRequestsProvider);
  final filter = ref.watch(requestFilterProvider);
  final categoryFilter = ref.watch(requestCategoryFilterProvider);

  return requestsAsync.when(
    data: (requests) {
      var list = requests;
      if (categoryFilter != null) {
        list = list.where((r) => r.module == categoryFilter).toList();
      }
      if (filter == RequestFilter.all) return AsyncValue.data(list);
      final filtered = list.where((r) {
        final status = r.status.toLowerCase();
        switch (filter) {
          case RequestFilter.pending:
            return status == 'pending' || status == 'submitted';
          case RequestFilter.approved:
            return status == 'approved';
          case RequestFilter.rejected:
            return status == 'rejected';
          default:
            return true;
        }
      }).toList();
      return AsyncValue.data(filtered);
    },
    loading: () => const AsyncValue.loading(),
    error: (err, stack) => AsyncValue.error(err, stack),
  );
});

class RequestSummary {
  final int total;
  final int pending;
  final int approved;
  final int rejected;

  RequestSummary({
    required this.total,
    required this.pending,
    required this.approved,
    required this.rejected,
  });
}

final requestSummaryProvider = Provider<RequestSummary>((ref) {
  final requestsAsync = ref.watch(allRequestsProvider);
  return requestsAsync.maybeWhen(
    data: (list) {
      int pending = 0;
      int approved = 0;
      int rejected = 0;
      for (final r in list) {
        final status = r.status.toLowerCase();
        if (status == 'pending' || status == 'submitted') {
          pending++;
        } else if (status == 'approved') {
          approved++;
        } else if (status == 'rejected') {
          rejected++;
        }
      }
      return RequestSummary(
        total: list.length,
        pending: pending,
        approved: approved,
        rejected: rejected,
      );
    },
    orElse: () => RequestSummary(total: 0, pending: 0, approved: 0, rejected: 0),
  );
});
