import 'employee.dart';

enum AuthStatus {
  success,
  invalidCredentials,
  accountLocked,
  networkFailure,
  serverError,
  mfaRequired,
  unknown
}

class AuthResult {
  final AuthStatus status;
  final String? message;
  final String? token;
  final Employee? employee;

  AuthResult({
    required this.status,
    this.message,
    this.token,
    this.employee,
  });

  factory AuthResult.fromJson(Map<String, dynamic> json) {
    return AuthResult(
      status: AuthStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => AuthStatus.unknown,
      ),
      message: json['message'],
      token: json['token'],
      employee: json['employee'] != null ? Employee.fromJson(json['employee']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status.toString().split('.').last,
      'message': message,
      'token': token,
      'employee': employee?.toJson(),
    };
  }

  factory AuthResult.success({String? token, Employee? employee}) {
    return AuthResult(status: AuthStatus.success, token: token, employee: employee);
  }

  factory AuthResult.failure(AuthStatus status, [String? message]) {
    return AuthResult(status: status, message: message);
  }

  bool get isSuccess => status == AuthStatus.success;
}
