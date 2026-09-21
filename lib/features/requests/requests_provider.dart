import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/injection_providers.dart';
import '../../models/unified_request.dart';

final allRequestsProvider = FutureProvider<List<UnifiedRequest>>((ref) async {
  final service = ref.watch(requestsServiceProvider);
  return service.getAllRequests();
});

enum RequestFilter { all, pending, approved, rejected }

final requestFilterProvider = StateProvider<RequestFilter>((ref) => RequestFilter.all);

final filteredRequestsProvider = Provider<AsyncValue<List<UnifiedRequest>>>((ref) {
  final requestsAsync = ref.watch(allRequestsProvider);
  final filter = ref.watch(requestFilterProvider);

  return requestsAsync.when(
    data: (requests) {
      if (filter == RequestFilter.all) return AsyncValue.data(requests);
      final filtered = requests.where((r) {
        final status = r.status.toLowerCase();
        switch (filter) {
          case RequestFilter.pending:
            return status == 'pending';
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
