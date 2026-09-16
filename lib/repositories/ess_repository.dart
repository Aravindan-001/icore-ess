import 'auth_repository.dart';
import 'attendance_repository.dart';
import 'leave_repository.dart';
import 'payroll_repository.dart';
import 'profile_repository.dart';
import 'expense_repository.dart';
import 'order_repository.dart';
import 'notification_repository.dart';

/// Legacy combined repository for backward compatibility during transition.
/// New features should depend on granular repository contracts.
abstract class EssRepository 
    implements 
        AuthRepository, 
        AttendanceRepository, 
        LeaveRepository, 
        PayrollRepository, 
        ProfileRepository, 
        ExpenseRepository, 
        OrderRepository, 
        NotificationRepository {}
