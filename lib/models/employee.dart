enum UserRole {
  employee,
  hr,
}

class Employee {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String department;
  final String designation;
  final String joiningDate;
  final String profileImageUrl;
  final UserRole role;

  Employee({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.department,
    required this.designation,
    required this.joiningDate,
    required this.profileImageUrl,
    this.role = UserRole.employee,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      department: json['department'] ?? '',
      designation: json['designation'] ?? '',
      joiningDate: json['joiningDate'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
      role: UserRole.values.firstWhere(
        (e) => e.toString().split('.').last == (json['role'] ?? 'employee'),
        orElse: () => UserRole.employee,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'department': department,
      'designation': designation,
      'joiningDate': joiningDate,
      'profileImageUrl': profileImageUrl,
      'role': role.toString().split('.').last,
    };
  }
}
