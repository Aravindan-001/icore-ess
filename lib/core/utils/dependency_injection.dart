import 'package:flutter/material.dart';
import '../../repositories/auth_repository.dart';
import '../../repositories/attendance_repository.dart';
import '../../repositories/leave_repository.dart';
import '../../repositories/payroll_repository.dart';
import '../../repositories/profile_repository.dart';
import '../../repositories/expense_repository.dart';
import '../../repositories/order_repository.dart';
import '../../repositories/notification_repository.dart';
import '../../repositories/ess_repository.dart';
import '../../repositories/mock_ess_repository.dart';
import '../../repositories/soap_ess_repository.dart';
import '../../services/auth_service.dart';
import '../../services/attendance_service.dart';
import '../../services/location_service.dart';
import '../../services/expense_service.dart';
import '../../services/leave_service.dart';
import '../../services/order_service.dart';
import '../../services/profile_service.dart';
import '../../services/payroll_service.dart';
import '../../services/notification_service.dart';
import '../../services/soap/soap_client.dart';
import '../../services/soap/soap_config.dart';

class DependencyInjection {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  
  static EssRepository? _repository;
  static LocationService? _locationService;
  static AttendanceService? _attendanceService;
  static AuthService? _authService;
  static ExpenseService? _expenseService;
  static LeaveService? _leaveService;
  static OrderService? _orderService;
  static ProfileService? _profileService;
  static PayrollService? _payrollService;
  static NotificationService? _notificationService;

  static EssRepository get repository {
    _repository ??= MockEssRepository();
    return _repository!;
  }

  // Granular Accessors
  static AuthRepository get authRepository => repository;
  static AttendanceRepository get attendanceRepository => repository;
  static LeaveRepository get leaveRepository => repository;
  static PayrollRepository get payrollRepository => repository;
  static ProfileRepository get profileRepository => repository;
  static ExpenseRepository get expenseRepository => repository;
  static OrderRepository get orderRepository => repository;
  static NotificationRepository get notificationRepository => repository;

  static LocationService get locationService {
    _locationService ??= GeolocatorLocationService();
    return _locationService!;
  }

  static AttendanceService get attendanceService {
    _attendanceService ??= AttendanceService(
      attendanceRepository,
      profileRepository,
      locationService,
    );
    return _attendanceService!;
  }

  static AuthService get authService {
    _authService ??= AuthService(authRepository);
    return _authService!;
  }

  static ExpenseService get expenseService {
    _expenseService ??= ExpenseService(expenseRepository, profileRepository);
    return _expenseService!;
  }

  static LeaveService get leaveService {
    _leaveService ??= LeaveService(leaveRepository);
    return _leaveService!;
  }

  static OrderService get orderService {
    _orderService ??= OrderService(orderRepository);
    return _orderService!;
  }

  static ProfileService get profileService {
    _profileService ??= ProfileService(profileRepository);
    return _profileService!;
  }

  static PayrollService get payrollService {
    _payrollService ??= PayrollService(payrollRepository);
    return _payrollService!;
  }

  static NotificationService get notificationService {
    _notificationService ??= NotificationService(notificationRepository);
    return _notificationService!;
  }

  static void useSoapBackend(AppEnvironment env) {
    _repository = SoapEssRepository(SoapClient(
      env == AppEnvironment.uat ? SoapConfig.uat() : SoapConfig.prod(),
    ));
    resetServices();
  }


  static void setDependencies({
    EssRepository? repository,
    LocationService? locationService,
  }) {
    if (repository != null) {
      _repository = repository;
      resetServices();
    }
    if (locationService != null) {
      _locationService = locationService;
      _attendanceService = null;
    }
  }

  static void resetServices() {
    _attendanceService = null;
    _authService = null;
    _expenseService = null;
    _leaveService = null;
    _orderService = null;
    _profileService = null;
    _payrollService = null;
    _notificationService = null;
  }

  static void reset() {
    _repository = null;
    _locationService = null;
    resetServices();
  }
}
