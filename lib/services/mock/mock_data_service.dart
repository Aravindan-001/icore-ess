import '../../models/employee.dart';
import '../../models/employment.dart';
import '../../models/leave.dart';
import '../../models/payslip.dart';
import '../../models/overtime.dart';
import '../../models/personal_info.dart';
import '../../models/family.dart';
import '../../models/bank.dart';
import '../../models/education.dart';
import '../../models/skill.dart';
import '../../models/identity.dart';
import '../../models/work_history.dart';
import '../../models/certificate.dart';
import '../../models/pending_request.dart';
import '../../models/airfare.dart';
import '../../models/education_declaration.dart';

class MockDataService {
  static final Employee mockEmployee = Employee(
    id: '20140',
    name: 'ANITHA K',
    email: 'anitha.k@ebaconnect.com',
    phone: '+971 501234567',
    department: 'RETAIL',
    designation: 'EXECUTIVE-SALES-ELIFE',
    joiningDate: '01-Mar-2024',
    profileImageUrl: '',
    role: UserRole.employee,
  );

  static final Employee mockHrEmployee = Employee(
    id: 'HR001',
    name: 'HR MANAGER',
    email: 'hr.manager@ebaconnect.com',
    phone: '+971 509876543',
    department: 'MANAGEMENT',
    designation: 'CHIEF TECHNOLOGY OFFICER',
    joiningDate: '01-Jan-2020',
    profileImageUrl: '',
    role: UserRole.hr,
  );

  static final List<Employee> mockAllEmployees = [
    mockEmployee,
    mockHrEmployee,
    Employee(
      id: '10032',
      name: 'RAHUL K',
      email: 'rahul.k@ebaconnect.com',
      phone: '+971 501112222',
      department: 'IT',
      designation: 'SOFTWARE ENGINEER',
      joiningDate: '15-May-2022',
      profileImageUrl: '',
    ),
    Employee(
      id: '10033',
      name: 'PRIYA S',
      email: 'priya.s@ebaconnect.com',
      phone: '+971 503334444',
      department: 'FINANCE',
      designation: 'ACCOUNTANT',
      joiningDate: '10-Oct-2023',
      profileImageUrl: '',
    ),
  ];

  static final EmployeeEmployment mockEmployment = EmployeeEmployment(
    employeeId: '20140',
    legacyId: 'LEG20140',
    joiningDate: '01/03/2024',
    grade: 'G1',
    employmentType: 'Permanent',
    pointOfHire: 'Dubai',
    department: 'RETAIL',
    designation: 'EXECUTIVE-SALES-ELIFE',
    location: 'DUBAI',
    yearsOfService: '0 Years 11 Months',
  );

  static final PersonalInformation mockPersonalInformation = PersonalInformation(
    personalDetails: PersonalDetails(
      firstName: 'ANITHA',
      lastName: 'K',
      displayName: 'ANITHA K',
      dateOfBirth: '12/08/1996',
      gender: 'Female',
      placeOfBirth: 'Dubai',
      nationality: 'Indian',
      motherTongue: 'Malayalam',
      bloodGroup: 'B+',
      maritalStatus: 'Single',
      residentialStatus: 'Resident',
      disability: 'None',
    ),
    employmentDetails: mockEmployment,
    contactInfo: EmployeeContact(
      mobile: '+971 501234567',
      phone: '+971 42233445',
      officialEmail: 'anitha.k@ebaconnect.com',
      personalEmail: 'anitha.k@gmail.com',
    ),
  );

  static final List<FamilyMember> mockFamily = [
    FamilyMember(
      name: 'Rajesh Kumar',
      relationship: 'Father',
      dateOfBirth: '12/05/1965',
      gender: 'Male',
      contactNumber: '+91 9840012345',
      isDependent: false,
    ),
    FamilyMember(
      name: 'Lakshmi Kumar',
      relationship: 'Mother',
      dateOfBirth: '20/08/1970',
      gender: 'Female',
      contactNumber: '+91 9840054321',
      isDependent: true,
    ),
  ];

  static final BankInformation mockBank = BankInformation(
    bankName: 'HDFC Bank',
    accountNumber: '50100234567890',
    accountHolder: 'ANITHA K',
    branch: 'OMR Road, Chennai',
    iban: 'HDFC0001234',
    swiftCode: 'HDFCCINBB',
  );

  static final List<EducationRecord> mockEducation = [
    EducationRecord(
      degree: 'Bachelor of Technology',
      institution: 'Anna University',
      specialization: 'Computer Science',
      startYear: '2013',
      endYear: '2017',
      grade: '8.5 CGPA',
    ),
    EducationRecord(
      degree: 'Higher Secondary',
      institution: 'St. Marys School',
      specialization: 'Computer Science',
      startYear: '2011',
      endYear: '2013',
      grade: '92%',
    ),
  ];

  static final List<EducationDocument> mockEducationDocuments = [
    EducationDocument(
      name: 'Degree Certificate',
      educationLevel: 'B.Tech',
      uploadDate: DateTime(2017, 6, 15),
      fileType: 'PDF',
    ),
    EducationDocument(
      name: 'HSC Marksheet',
      educationLevel: '12th',
      uploadDate: DateTime(2013, 5, 20),
      fileType: 'PDF',
    ),
  ];

  static final List<Skill> mockSkills = [
    Skill(name: 'Flutter', level: 'Expert', category: SkillCategory.technical),
    Skill(name: 'Dart', level: 'Expert', category: SkillCategory.technical),
    Skill(name: 'Firebase', level: 'Intermediate', category: SkillCategory.technical),
    Skill(name: 'Problem Solving', level: 'Expert', category: SkillCategory.soft),
    Skill(name: 'Communication', level: 'Expert', category: SkillCategory.soft),
    Skill(name: 'English', level: 'Expert', category: SkillCategory.language),
  ];

  static final List<IdentityDocument> mockIdentities = [
    IdentityDocument(
      type: 'Aadhaar Card',
      documentNumber: '1234 5678 9012',
      issueDate: '10/10/2012',
      status: 'Verified',
    ),
    IdentityDocument(
      type: 'PAN Card',
      documentNumber: 'ABCDE1234F',
      issueDate: '15/05/2015',
      status: 'Verified',
    ),
    IdentityDocument(
      type: 'Passport',
      documentNumber: 'Z1234567',
      issueDate: '01/01/2020',
      expiryDate: '31/12/2030',
      status: 'Verified',
    ),
  ];

  static final List<WorkExperience> mockWorkHistory = [
    WorkExperience(
      company: 'Tech Solutions Inc',
      designation: 'Junior Developer',
      fromDate: '01/06/2017',
      toDate: '31/12/2021',
      location: 'Chennai, India',
    ),
  ];

  static final List<Certificate> mockCertificates = [
    Certificate(
      name: 'Google Associate Android Developer',
      issuingOrganization: 'Google',
      issueDate: '10/12/2020',
    ),
    Certificate(
      name: 'AWS Certified Cloud Practitioner',
      issuingOrganization: 'Amazon Web Services',
      issueDate: '05/03/2022',
      expiryDate: '05/03/2025',
    ),
  ];

  static final List<PendingRequest> mockProfileRequests = [
    PendingRequest(
      id: 'REQ001',
      type: 'Bank Detail Update',
      submittedDate: DateTime.now().subtract(const Duration(days: 2)),
      status: 'Pending',
      lastUpdated: DateTime.now().subtract(const Duration(days: 1)),
      description: 'Request to change salary account to ICICI Bank.',
    ),
    PendingRequest(
      id: 'REQ002',
      type: 'Education Update',
      submittedDate: DateTime.now().subtract(const Duration(days: 10)),
      status: 'Approved',
      lastUpdated: DateTime.now().subtract(const Duration(days: 5)),
      description: 'Adding AWS Certification details.',
    ),
  ];

  static final List<LeaveBalance> mockLeaveBalances = [
    LeaveBalance(type: 'Annual Leave', total: 25, used: 0, pending: 13),
    LeaveBalance(type: 'Roster Leave', total: 24, used: 0, pending: 0),
    LeaveBalance(type: 'Sick Leave', total: 45, used: 0, pending: 0),
    LeaveBalance(type: 'Casual Leave', total: 5, used: 1, pending: 0),
  ];

  static final List<LeaveRequest> mockLeaveRequests = [
    LeaveRequest(
      id: 'LR001',
      type: 'Annual Leave',
      startDate: DateTime(2023, 10, 10),
      endDate: DateTime(2023, 10, 12),
      reason: 'Family function',
      status: LeaveStatus.approved,
      appliedDate: DateTime(2023, 10, 1),
    ),
    LeaveRequest(
      id: 'LR002',
      type: 'Sick Leave',
      startDate: DateTime(2023, 11, 5),
      endDate: DateTime(2023, 11, 5),
      reason: 'Fever',
      status: LeaveStatus.approved,
      appliedDate: DateTime(2023, 11, 4),
    ),
    LeaveRequest(
      id: 'LR003',
      type: 'Annual Leave',
      startDate: DateTime(2024, 1, 20),
      endDate: DateTime(2024, 1, 22),
      reason: 'Vacation',
      status: LeaveStatus.pending,
      appliedDate: DateTime(2024, 1, 10),
    ),
  ];

  static final List<Payslip> mockPayslips = [
    Payslip(month: 'January', year: '2025', netSalary: 1500.00, currency: 'AED'),
    Payslip(month: 'December', year: '2024', netSalary: 1500.00, currency: 'AED'),
    Payslip(month: 'November', year: '2024', netSalary: 1450.00, currency: 'AED'),
  ];

  static final List<OvertimeRequest> mockOvertimeRequests = [
    OvertimeRequest(
      id: 'OT-2026-001',
      date: DateTime(2026, 9, 15),
      hours: 4.0,
      reason: 'Weekend support for server migration',
      status: OvertimeStatus.pending,
      submittedDate: DateTime(2026, 9, 16),
    ),
    OvertimeRequest(
      id: 'OT-2026-002',
      date: DateTime(2026, 8, 20),
      hours: 2.5,
      reason: 'Late night bug fixing for release 1.2',
      status: OvertimeStatus.approved,
      submittedDate: DateTime(2026, 8, 21),
      approvedBy: 'John Doe (Manager)',
      approvalDate: DateTime(2026, 8, 23),
      remarks: 'Good job on the release.',
    ),
    OvertimeRequest(
      id: 'OT-2026-003',
      date: DateTime(2026, 7, 10),
      hours: 8.0,
      reason: 'Public holiday deployment',
      status: OvertimeStatus.rejected,
      submittedDate: DateTime(2026, 7, 11),
      remarks: 'Deployment was postponed, overtime not required.',
    ),
  ];

  static PayslipDetail getMockPayslipDetail(String year, String month) {
    final cleanMonth = month.trim();
    final monthAbbrev = cleanMonth.length >= 3
        ? cleanMonth.substring(0, 3).toUpperCase()
        : cleanMonth.toUpperCase();

    if (cleanMonth.toLowerCase() == 'november' || cleanMonth.toLowerCase() == 'nov') {
      return PayslipDetail(
        employeeId: '20140',
        employeeName: 'ANITHA K',
        department: 'RETAIL',
        designation: 'EXECUTIVE-SALES-ELIFE',
        location: 'DUBAI',
        currency: 'AED',
        payPeriod: '$monthAbbrev-$year',
        payMode: 'Cash',
        dateOfJoining: '01-Mar-2024',
        bankName: 'Emirates NBD',
        accountNumber: '1234567890',
        workDays: 30,
        paidLeave: 0.00,
        otHours: 0,
        lop: 1.00,
        earnings: [
          SalaryComponent(name: 'Basic Salary', amount: 975.00),
          SalaryComponent(name: 'Housing Allowance', amount: 300.00),
          SalaryComponent(name: 'Transportation Allowance', amount: 150.00),
          SalaryComponent(name: 'Other Allowance', amount: 75.00),
        ],
        deductions: [
          SalaryComponent(name: 'Unpaid Leave / LOP', amount: 50.00),
        ],
        totalEarnings: 1500.00,
        totalDeductions: 50.00,
        netPay: 1450.00,
        documentUrl: 'mock_payslip_url',
      );
    }

    return PayslipDetail(
      employeeId: '20140',
      employeeName: 'ANITHA K',
      department: 'RETAIL',
      designation: 'EXECUTIVE-SALES-ELIFE',
      location: 'DUBAI',
      currency: 'AED',
      payPeriod: '$monthAbbrev-$year',
      payMode: 'Cash',
      dateOfJoining: '01-Mar-2024',
      bankName: 'Emirates NBD',
      accountNumber: '1234567890',
      workDays: 31,
      paidLeave: 0.00,
      otHours: 0,
      lop: 0.00,
      earnings: [
        SalaryComponent(name: 'Basic Salary', amount: 975.00),
        SalaryComponent(name: 'Housing Allowance', amount: 300.00),
        SalaryComponent(name: 'Transportation Allowance', amount: 150.00),
        SalaryComponent(name: 'Other Allowance', amount: 75.00),
      ],
      deductions: [],
      totalEarnings: 1500.00,
      totalDeductions: 0.00,
      netPay: 1500.00,
      documentUrl: 'mock_payslip_url',
    );
  }

  static final List<AirfareDeclaration> mockAirfareDeclarations = [
    AirfareDeclaration(
      id: 'AFD-2026-001',
      employeeId: 'EMP001',
      travelYear: '2026',
      travelDate: DateTime(2026, 5, 10),
      fromLocation: 'Chennai (MAA)',
      toLocation: 'Delhi (DEL)',
      travelType: 'Annual Leave Travel',
      amount: 12500.0,
      status: AirfareStatus.pending,
      submittedDate: DateTime(2026, 5, 12),
    ),
    AirfareDeclaration(
      id: 'AFD-2026-002',
      employeeId: 'EMP001',
      travelYear: '2026',
      travelDate: DateTime(2026, 3, 15),
      fromLocation: 'Chennai (MAA)',
      toLocation: 'Mumbai (BOM)',
      travelType: 'Business Travel',
      amount: 8500.0,
      status: AirfareStatus.approved,
      submittedDate: DateTime(2026, 3, 16),
      approvedBy: 'John Doe (HR Manager)',
      approvalDate: DateTime(2026, 3, 18),
      remarks: 'Approved as per company airfare policy.',
    ),
    AirfareDeclaration(
      id: 'AFD-2026-003',
      employeeId: 'EMP001',
      travelYear: '2026',
      travelDate: DateTime(2026, 1, 20),
      fromLocation: 'Chennai (MAA)',
      toLocation: 'London (LHR)',
      travelType: 'Personal Travel',
      amount: 45000.0,
      status: AirfareStatus.rejected,
      submittedDate: DateTime(2026, 1, 22),
      remarks: 'International personal travel is not covered under standard annual airfare allowance.',
    ),
    AirfareDeclaration(
      id: 'AFD-2026-004',
      employeeId: 'EMP001',
      travelYear: '2026',
      travelDate: DateTime(2026, 8, 5),
      fromLocation: 'Chennai (MAA)',
      toLocation: 'Singapore (SIN)',
      travelType: 'Business Travel',
      amount: 32000.0,
      status: AirfareStatus.pending,
      submittedDate: DateTime(2026, 8, 7),
    ),
  ];

  static final List<EducationDeclaration> mockEducationDeclarations = [
    EducationDeclaration(
      id: 'EDD-2026-001',
      employeeId: 'EMP001',
      academicYear: '2026',
      institutionName: 'Stanford Graduate School of Business',
      courseProgram: 'Executive Leadership Program',
      educationLevel: 'Postgraduate',
      academicPeriod: 'Spring Semester',
      amount: 150000.0,
      status: EducationStatus.pending,
      submittedDate: DateTime(2026, 4, 10),
    ),
    EducationDeclaration(
      id: 'EDD-2026-002',
      employeeId: 'EMP001',
      academicYear: '2026',
      institutionName: 'Harvard Extension School',
      courseProgram: 'Strategic Management Certificate',
      educationLevel: 'Certification',
      academicPeriod: 'Term 1',
      amount: 85000.0,
      status: EducationStatus.approved,
      submittedDate: DateTime(2026, 2, 14),
      approvedBy: 'Jane Smith (HR Director)',
      approvalDate: DateTime(2026, 2, 18),
      remarks: 'Approved under executive higher education policy sponsorship program.',
    ),
    EducationDeclaration(
      id: 'EDD-2026-003',
      employeeId: 'EMP001',
      academicYear: '2026',
      institutionName: 'Absurd Learning Center',
      courseProgram: 'Random Non-Accredited Course',
      educationLevel: 'Other',
      academicPeriod: 'Full Year',
      amount: 25000.0,
      status: EducationStatus.rejected,
      submittedDate: DateTime(2026, 1, 5),
      remarks: 'The institution is not on the company approved accredited university listing.',
    ),
  ];
}
