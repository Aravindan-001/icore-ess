import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../repositories/ess_repository.dart';
import '../../repositories/auth_repository.dart';
import '../../repositories/attendance_repository.dart';
import '../../repositories/leave_repository.dart';
import '../../repositories/payroll_repository.dart';
import '../../repositories/overtime_repository.dart';
import '../../repositories/profile_repository.dart';
import '../../repositories/expense_repository.dart';
import '../../repositories/order_repository.dart';
import '../../repositories/notification_repository.dart';
import '../../repositories/airfare_repository.dart';
import '../../repositories/education_repository.dart';
import '../../repositories/mock_ess_repository.dart';
import '../../services/auth_service.dart';
import '../../services/attendance_service.dart';
import '../../services/location_service.dart';
import '../../services/expense_service.dart';
import '../../services/leave_service.dart';
import '../../services/order_service.dart';
import '../../services/profile_service.dart';
import '../../services/payroll_service.dart';
import '../../services/overtime_service.dart';
import '../../services/notification_service.dart';
import '../../services/airfare_service.dart';
import '../../services/education_service.dart';
import '../../services/requests_service.dart';
import '../../services/soap/soap_config.dart';
import '../../services/soap/soap_client.dart';
import '../../repositories/soap_ess_repository.dart';
import 'package:flutter/material.dart';
import '../services/analytics_service.dart';

/// Provider for global analytics service abstraction
final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  return AnalyticsService();
});

/// Provider for the navigator key used for global navigation
final navigatorKeyProvider = Provider<GlobalKey<NavigatorState>>((ref) {
  return GlobalKey<NavigatorState>();
});

/// Provider for SOAP Configuration
final soapConfigProvider = Provider<SoapConfig>((ref) {
  // Use .prod() or other factories based on environment
  return SoapConfig.prod();
});

/// Provider for SOAP Client
final soapClientProvider = Provider<SoapClient>((ref) {
  return SoapClient(ref.watch(soapConfigProvider));
});

/// Core repository provider - toggles between Mock and SOAP
/// Default is 'mock' as SOAP contract is pending.
final essRepositoryProvider = Provider<EssRepository>((ref) {
  const backend = String.fromEnvironment('ESS_BACKEND', defaultValue: 'mock');
  
  if (backend == 'soap') {
    return SoapEssRepository(ref.watch(soapClientProvider));
  }

  return MockEssRepository();
});

// Granular Repository Providers (mapped from EssRepository)
final authRepositoryProvider = Provider<AuthRepository>((ref) => ref.watch(essRepositoryProvider));
final attendanceRepositoryProvider = Provider<AttendanceRepository>((ref) => ref.watch(essRepositoryProvider));
final leaveRepositoryProvider = Provider<LeaveRepository>((ref) => ref.watch(essRepositoryProvider));
final payrollRepositoryProvider = Provider<PayrollRepository>((ref) => ref.watch(essRepositoryProvider));
final overtimeRepositoryProvider = Provider<OvertimeRepository>((ref) => ref.watch(essRepositoryProvider));
final profileRepositoryProvider = Provider<ProfileRepository>((ref) => ref.watch(essRepositoryProvider));
final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) => ref.watch(essRepositoryProvider));
final orderRepositoryProvider = Provider<OrderRepository>((ref) => ref.watch(essRepositoryProvider));
final notificationRepositoryProvider = Provider<NotificationRepository>((ref) => ref.watch(essRepositoryProvider));
final airfareRepositoryProvider = Provider<AirfareRepository>((ref) => ref.watch(essRepositoryProvider));
final educationRepositoryProvider = Provider<EducationRepository>((ref) => ref.watch(essRepositoryProvider));

/// Provider for location service
final locationServiceProvider = Provider<LocationService>((ref) {
  return GeolocatorLocationService();
});

/// Service Providers
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref.watch(authRepositoryProvider));
});

final attendanceServiceProvider = Provider<AttendanceService>((ref) {
  return AttendanceService(
    ref.watch(attendanceRepositoryProvider),
    ref.watch(profileRepositoryProvider),
    ref.watch(locationServiceProvider),
  );
});

final expenseServiceProvider = Provider<ExpenseService>((ref) {
  return ExpenseService(
    ref.watch(expenseRepositoryProvider),
    ref.watch(profileRepositoryProvider),
  );
});

final leaveServiceProvider = Provider<LeaveService>((ref) {
  return LeaveService(ref.watch(leaveRepositoryProvider));
});

final orderServiceProvider = Provider<OrderService>((ref) {
  return OrderService(ref.watch(orderRepositoryProvider));
});

final profileServiceProvider = Provider<ProfileService>((ref) {
  return ProfileService(ref.watch(profileRepositoryProvider));
});

final payrollServiceProvider = Provider<PayrollService>((ref) {
  return PayrollService(ref.watch(payrollRepositoryProvider));
});

final overtimeServiceProvider = Provider<OvertimeService>((ref) {
  return OvertimeService(ref.watch(overtimeRepositoryProvider));
});

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService(ref.watch(notificationRepositoryProvider));
});

final airfareServiceProvider = Provider<AirfareService>((ref) {
  return AirfareService(ref.watch(airfareRepositoryProvider));
});

final educationServiceProvider = Provider<EducationService>((ref) {
  return EducationService(ref.watch(educationRepositoryProvider));
});

final requestsServiceProvider = Provider<RequestsService>((ref) {
  return RequestsService(
    ref.watch(leaveServiceProvider),
    ref.watch(overtimeServiceProvider),
    ref.watch(airfareServiceProvider),
    ref.watch(educationServiceProvider),
    ref.watch(profileServiceProvider),
    ref.watch(expenseServiceProvider),
  );
});
