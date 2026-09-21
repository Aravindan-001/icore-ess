import '../models/unified_request.dart';
import 'leave_service.dart';
import 'overtime_service.dart';
import 'airfare_service.dart';
import 'education_service.dart';
import 'profile_service.dart';
import 'expense_service.dart';

class RequestsService {
  final LeaveService _leaveService;
  final OvertimeService _overtimeService;
  final AirfareService _airfareService;
  final EducationService _educationService;
  final ProfileService _profileService;
  final ExpenseService _expenseService;

  RequestsService(
    this._leaveService,
    this._overtimeService,
    this._airfareService,
    this._educationService,
    this._profileService,
    this._expenseService,
  );

  Future<List<UnifiedRequest>> getAllRequests() async {
    final List<UnifiedRequest> unifiedRequests = [];

    await Future.wait([
      _fetchLeaveRequests(unifiedRequests),
      _fetchOvertimeRequests(unifiedRequests),
      _fetchAirfareDeclarations(unifiedRequests),
      _fetchEducationDeclarations(unifiedRequests),
      _fetchProfileUpdateRequests(unifiedRequests),
      _fetchMedicalClaims(unifiedRequests),
      _fetchReimbursements(unifiedRequests),
    ]);

    // Sort by submitted date descending
    unifiedRequests.sort((a, b) => b.submittedDate.compareTo(a.submittedDate));

    return unifiedRequests;
  }

  Future<void> _fetchLeaveRequests(List<UnifiedRequest> list) async {
    try {
      final requests = await _leaveService.getLeaveRequests();
      list.addAll(requests.map((r) => UnifiedRequest(
        id: r.id,
        type: 'Leave Request',
        submittedDate: r.appliedDate,
        status: _capitalize(r.status.name),
        description: r.type,
        module: RequestModule.leave,
      )));
    } catch (_) {
      // Log error in production, but allow other services to succeed
    }
  }

  Future<void> _fetchOvertimeRequests(List<UnifiedRequest> list) async {
    try {
      final requests = await _overtimeService.getOvertimeRequests();
      list.addAll(requests.map((r) => UnifiedRequest(
        id: r.id,
        type: 'Overtime Request',
        submittedDate: r.submittedDate,
        status: _capitalize(r.status.name),
        description: '${r.hours} hours',
        module: RequestModule.overtime,
      )));
    } catch (_) {}
  }

  Future<void> _fetchAirfareDeclarations(List<UnifiedRequest> list) async {
    try {
      final requests = await _airfareService.getAirfareDeclarations();
      list.addAll(requests.map((r) => UnifiedRequest(
        id: r.id,
        type: 'Airfare Declaration',
        submittedDate: r.submittedDate,
        status: _capitalize(r.status.name),
        description: '${r.fromLocation} → ${r.toLocation}',
        module: RequestModule.airfare,
      )));
    } catch (_) {}
  }

  Future<void> _fetchEducationDeclarations(List<UnifiedRequest> list) async {
    try {
      final requests = await _educationService.getEducationDeclarations();
      list.addAll(requests.map((r) => UnifiedRequest(
        id: r.id,
        type: 'Education Declaration',
        submittedDate: r.submittedDate,
        status: _capitalize(r.status.name),
        description: r.courseProgram,
        module: RequestModule.education,
      )));
    } catch (_) {}
  }

  Future<void> _fetchProfileUpdateRequests(List<UnifiedRequest> list) async {
    try {
      final requests = await _profileService.getProfileUpdateRequests();
      list.addAll(requests.map((r) => UnifiedRequest(
        id: r.id,
        type: 'Profile Update',
        submittedDate: r.submittedDate,
        status: r.status,
        lastUpdated: r.lastUpdated,
        description: r.type,
        module: RequestModule.profile,
      )));
    } catch (_) {}
  }

  Future<void> _fetchMedicalClaims(List<UnifiedRequest> list) async {
    try {
      final requests = await _expenseService.getMedicalClaims();
      list.addAll(requests.map((r) => UnifiedRequest(
        id: r.id,
        type: 'Medical Claim',
        submittedDate: r.date,
        status: r.status,
        description: r.description,
        module: RequestModule.medicalClaim,
      )));
    } catch (_) {}
  }

  Future<void> _fetchReimbursements(List<UnifiedRequest> list) async {
    try {
      final requests = await _expenseService.getReimbursements();
      list.addAll(requests.map((r) => UnifiedRequest(
        id: r.id,
        type: 'Reimbursement',
        submittedDate: r.date,
        status: r.status,
        description: r.description,
        module: RequestModule.reimbursement,
      )));
    } catch (_) {}
  }

  String _capitalize(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}
