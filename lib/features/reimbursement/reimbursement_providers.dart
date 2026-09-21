import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/injection_providers.dart';
import '../../models/reimbursement_models.dart';
import '../../services/expense_service.dart';

// Filters & Sorting state models
class ReimbursementListFilter {
  final String searchQuery;
  final ReimbursementStatus? statusFilter;
  final String? typeFilter;
  final DateTimeRange? dateRange;
  final String sortOption; // 'newest', 'oldest', 'highest', 'lowest'

  ReimbursementListFilter({
    this.searchQuery = '',
    this.statusFilter,
    this.typeFilter,
    this.dateRange,
    this.sortOption = 'newest',
  });

  ReimbursementListFilter copyWith({
    String? searchQuery,
    ReimbursementStatus? statusFilter,
    String? typeFilter,
    DateTimeRange? dateRange,
    String? sortOption,
    bool clearDateRange = false,
  }) {
    return ReimbursementListFilter(
      searchQuery: searchQuery ?? this.searchQuery,
      statusFilter: statusFilter == null ? this.statusFilter : (statusFilter == ReimbursementStatus.newStatus && this.statusFilter == ReimbursementStatus.newStatus ? null : statusFilter),
      typeFilter: typeFilter == null ? this.typeFilter : (typeFilter == this.typeFilter ? null : typeFilter),
      dateRange: clearDateRange ? null : (dateRange ?? this.dateRange),
      sortOption: sortOption ?? this.sortOption,
    );
  }
}

// Global Filter Provider
class ReimbursementFilterNotifier extends StateNotifier<ReimbursementListFilter> {
  ReimbursementFilterNotifier() : super(ReimbursementListFilter());

  void setSearchQuery(String query) => state = state.copyWith(searchQuery: query);
  void setStatusFilter(ReimbursementStatus? status) => state = state.copyWith(statusFilter: status);
  void setTypeFilter(String? type) => state = state.copyWith(typeFilter: type);
  void setDateRange(DateTimeRange? range) => state = state.copyWith(dateRange: range);
  void clearDateRange() => state = state.copyWith(clearDateRange: true);
  void setSortOption(String option) => state = state.copyWith(sortOption: option);
  void reset() => state = ReimbursementListFilter();
}

final reimbursementFilterProvider = StateNotifierProvider<ReimbursementFilterNotifier, ReimbursementListFilter>((ref) {
  return ReimbursementFilterNotifier();
});

// Async List Data Provider
final reimbursementListProvider = FutureProvider<List<ReimbursementRequest>>((ref) async {
  final service = ref.watch(expenseServiceProvider);
  return service.getReimbursementRequests();
});

// Filtered and Sorted list selector
final filteredReimbursementsProvider = Provider<List<ReimbursementRequest>>((ref) {
  final listAsync = ref.watch(reimbursementListProvider);
  final filter = ref.watch(reimbursementFilterProvider);

  return listAsync.maybeWhen(
    data: (list) {
      var filtered = list.where((item) {
        // Search matching
        final matchesSearch = item.documentNumber.toLowerCase().contains(filter.searchQuery.toLowerCase()) ||
            item.notes.toLowerCase().contains(filter.searchQuery.toLowerCase()) ||
            item.lineItems.any((li) => li.description.toLowerCase().contains(filter.searchQuery.toLowerCase()) || li.type.toLowerCase().contains(filter.searchQuery.toLowerCase()));

        if (!matchesSearch) return false;

        // Status matching
        if (filter.statusFilter != null && item.status != filter.statusFilter) return false;

        // Type matching
        if (filter.typeFilter != null) {
          final hasType = item.lineItems.any((li) => li.type.toUpperCase() == filter.typeFilter!.toUpperCase());
          if (!hasType) return false;
        }

        // Date range matching
        if (filter.dateRange != null) {
          if (item.date.isBefore(filter.dateRange!.start) || item.date.isAfter(filter.dateRange!.end.add(const Duration(days: 1)))) {
            return false;
          }
        }

        return true;
      }).toList();

      // Sorting operations
      if (filter.sortOption == 'newest') {
        filtered.sort((a, b) => b.date.compareTo(a.date));
      } else if (filter.sortOption == 'oldest') {
        filtered.sort((a, b) => a.date.compareTo(b.date));
      } else if (filter.sortOption == 'highest') {
        filtered.sort((a, b) => b.totalClaimAmount.compareTo(a.totalClaimAmount));
      } else if (filter.sortOption == 'lowest') {
        filtered.sort((a, b) => a.totalClaimAmount.compareTo(b.totalClaimAmount));
      }

      return filtered;
    },
    orElse: () => [],
  );
});

// Summary aggregates dashboard selector
class ReimbursementSummary {
  final int totalRequests;
  final double totalBillAmount;
  final double totalClaimAmount;
  final double totalReimbursedAmount;

  ReimbursementSummary({
    required this.totalRequests,
    required this.totalBillAmount,
    required this.totalClaimAmount,
    required this.totalReimbursedAmount,
  });
}

final reimbursementSummaryProvider = Provider<ReimbursementSummary>((ref) {
  final listAsync = ref.watch(reimbursementListProvider);
  return listAsync.maybeWhen(
    data: (list) {
      double bills = 0;
      double claims = 0;
      double reimbursed = 0;
      for (var item in list) {
        bills += item.totalBillAmount;
        claims += item.totalClaimAmount;
        reimbursed += item.totalReimbursedAmount;
      }
      return ReimbursementSummary(
        totalRequests: list.length,
        totalBillAmount: bills,
        totalClaimAmount: claims,
        totalReimbursedAmount: reimbursed,
      );
    },
    orElse: () => ReimbursementSummary(totalRequests: 0, totalBillAmount: 0, totalClaimAmount: 0, totalReimbursedAmount: 0),
  );
});

// Form view state management implementation
class ReimbursementFormState {
  final String documentNumber;
  final DateTime date;
  final DocumentType documentType;
  final ReimbursementStatus status;
  final List<ReimbursementLineItem> lineItems;
  final String notes;
  final bool isSaving;
  final String? errorMessage;

  ReimbursementFormState({
    required this.documentNumber,
    required this.date,
    required this.documentType,
    required this.status,
    required this.lineItems,
    required this.notes,
    this.isSaving = false,
    this.errorMessage,
  });

  double get totalBillAmount => lineItems.fold(0.0, (sum, item) => sum + item.billAmount);
  double get totalClaimAmount => lineItems.fold(0.0, (sum, item) => sum + item.claimAmount);

  ReimbursementFormState copyWith({
    DateTime? date,
    DocumentType? documentType,
    ReimbursementStatus? status,
    List<ReimbursementLineItem>? lineItems,
    String? notes,
    bool? isSaving,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ReimbursementFormState(
      documentNumber: documentNumber,
      date: date ?? this.date,
      documentType: documentType ?? this.documentType,
      status: status ?? this.status,
      lineItems: lineItems ?? this.lineItems,
      notes: notes ?? this.notes,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class ReimbursementFormNotifier extends StateNotifier<ReimbursementFormState> {
  final ExpenseService _service;
  
  ReimbursementFormNotifier(this._service, ReimbursementRequest? initialRequest)
      : super(
          initialRequest != null
              ? ReimbursementFormState(
                  documentNumber: initialRequest.documentNumber,
                  date: initialRequest.date,
                  documentType: initialRequest.documentType,
                  status: initialRequest.status,
                  lineItems: initialRequest.lineItems,
                  notes: initialRequest.notes,
                )
              : ReimbursementFormState(
                  documentNumber: 'CR-${DateTime.now().year}${DateTime.now().month.toString().padLeft(2, '0')}${DateTime.now().millisecondsSinceEpoch.toString().substring(DateTime.now().millisecondsSinceEpoch.toString().length - 4)}',
                  date: DateTime.now(),
                  documentType: DocumentType.general,
                  status: ReimbursementStatus.newStatus,
                  lineItems: [],
                  notes: '',
                ),
        );

  void setDocumentType(DocumentType type) => state = state.copyWith(documentType: type);
  void setDate(DateTime date) => state = state.copyWith(date: date);
  void setNotes(String notes) => state = state.copyWith(notes: notes);

  void addLineItem(ReimbursementLineItem item) {
    state = state.copyWith(lineItems: [...state.lineItems, item]);
  }

  void removeLineItem(String id) {
    state = state.copyWith(lineItems: state.lineItems.where((i) => i.id != id).toList());
  }

  Future<bool> saveDraft() async {
    state = state.copyWith(isSaving: true, clearError: true);
    try {
      final req = ReimbursementRequest(
        documentNumber: state.documentNumber,
        date: state.date,
        documentType: state.documentType,
        status: state.status,
        lineItems: state.lineItems,
        notes: state.notes,
        totalBillAmount: state.totalBillAmount,
        totalClaimAmount: state.totalClaimAmount,
        totalReimbursedAmount: 0.0,
      );
      final res = await _service.saveReimbursementDraft(req);
      return res;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    } finally {
      state = state.copyWith(isSaving: false);
    }
  }

  Future<bool> submitRequest() async {
    state = state.copyWith(isSaving: true, clearError: true);
    try {
      final req = ReimbursementRequest(
        documentNumber: state.documentNumber,
        date: state.date,
        documentType: state.documentType,
        status: state.status,
        lineItems: state.lineItems,
        notes: state.notes,
        totalBillAmount: state.totalBillAmount,
        totalClaimAmount: state.totalClaimAmount,
        totalReimbursedAmount: 0.0,
      );
      final res = await _service.submitReimbursementRequest(req);
      return res;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    } finally {
      state = state.copyWith(isSaving: false);
    }
  }
}

final reimbursementFormStateProvider = StateNotifierProvider.family<ReimbursementFormNotifier, ReimbursementFormState, ReimbursementRequest?>((ref, initialRequest) {
  final service = ref.watch(expenseServiceProvider);
  return ReimbursementFormNotifier(service, initialRequest);
});

class DateTimeRange {
  final DateTime start;
  final DateTime end;
  const DateTimeRange({required this.start, required this.end});
}
