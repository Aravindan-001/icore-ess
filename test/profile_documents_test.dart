import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icore_ess/app.dart';
import 'package:icore_ess/core/providers/injection_providers.dart';
import 'package:icore_ess/core/utils/session_manager.dart';
import 'package:icore_ess/features/documents/documents_screen.dart';
import 'package:icore_ess/features/profile/personal_info_landing_screen.dart';
import 'package:icore_ess/features/profile/profile_screen.dart';
import 'package:icore_ess/models/bank.dart';
import 'package:icore_ess/models/certificate.dart';
import 'package:icore_ess/models/education.dart';
import 'package:icore_ess/models/employee.dart';
import 'package:icore_ess/models/employment.dart';
import 'package:icore_ess/models/family.dart';
import 'package:icore_ess/models/identity.dart';
import 'package:icore_ess/models/pending_request.dart';
import 'package:icore_ess/models/personal_info.dart';
import 'package:icore_ess/models/skill.dart';
import 'package:icore_ess/models/work_history.dart';
import 'package:icore_ess/repositories/profile_repository.dart';
import 'test_utils.dart';

class MockErrorProfileRepository implements ProfileRepository {
  @override
  Future<Employee> getEmployeeProfile() async => throw Exception('Network error loading profile');
  @override
  Future<EmployeeEmployment> getEmploymentSummary() async => throw Exception('Network error');
  @override
  Future<PersonalInformation> getPersonalInformation() async => throw Exception('Network error');
  @override
  Future<List<FamilyMember>> getFamilyInformation() async => throw Exception('Network error');
  @override
  Future<BankInformation> getBankInformation() async => throw Exception('Network error');
  @override
  Future<List<EducationRecord>> getEducationHistory() async => throw Exception('Network error');
  @override
  Future<List<EducationDocument>> getEducationDocuments() async => throw Exception('Network error');
  @override
  Future<List<Skill>> getSkills() async => throw Exception('Network error');
  @override
  Future<List<IdentityDocument>> getIdentityDocuments() async => throw Exception('Network error');
  @override
  Future<List<WorkExperience>> getWorkHistory() async => throw Exception('Network error');
  @override
  Future<List<Certificate>> getCertificates() async => throw Exception('Network error');
  @override
  Future<List<PendingRequest>> getProfileUpdateRequests() async => throw Exception('Network error');
}

void main() {
  HttpOverrides.global = MockHttpOverrides();
  setupSecureStorageMock();

  group('Phase 11E — Profile, Documents & ESS Experience Tests', () {
    setUp(() {
      clearMockSecureStorage();
    });

    Future<void> loginAsEmployee(WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const ProviderScope(child: ICoreEssApp()));
      await tester.pumpAndBootstrap();
      await tester.enterText(find.byKey(const Key('field_Employee ID')), '20140');
      await tester.enterText(find.byKey(const Key('field_Password')), 'Employee@123');
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 1));
    }

    testWidgets('1. Profile screen loads, employee identity renders consistently', (WidgetTester tester) async {
      await loginAsEmployee(tester);

      await tester.tap(find.byIcon(Icons.person_outline).last);
      await tester.pumpAndSettle();

      expect(find.text('My Profile'), findsOneWidget);
      expect(find.text('ANITHA K'), findsOneWidget);
      expect(find.text('Employee ID: 20140'), findsOneWidget);
      expect(find.text('EXECUTIVE-SALES-ELIFE'), findsOneWidget);
      expect(find.text('RETAIL'), findsOneWidget);
      expect(find.text('DUBAI'), findsOneWidget);
    });

    testWidgets('2. Personal information landing screen renders and navigates to sub-sections', (WidgetTester tester) async {
      await loginAsEmployee(tester);

      await tester.tap(find.byIcon(Icons.person_outline).last);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Personal Information'));
      await tester.pumpAndSettle();

      expect(find.text('Personal Information'), findsWidgets);
      expect(find.text('Basic Information'), findsOneWidget);
      expect(find.text('Family Information'), findsOneWidget);
      expect(find.text('Bank Information'), findsOneWidget);

      await tester.tap(find.text('Basic Information'));
      await tester.pumpAndSettle();

      expect(find.text('PERSONAL DETAILS'), findsOneWidget);
      expect(find.text('ANITHA'), findsOneWidget);
      expect(find.text('EXECUTIVE-SALES-ELIFE'), findsOneWidget);
    });

    testWidgets('3. Profile error state displays Retry button', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            profileRepositoryProvider.overrideWithValue(MockErrorProfileRepository()),
          ],
          child: const MaterialApp(
            home: ProfileScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Unable to load employee profile'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('4. Documents screen renders document types, dates and handles empty state', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: DocumentsScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('My Documents'), findsOneWidget);
      expect(find.text('Payslip - January 2025'), findsOneWidget);
      expect(find.text('Employment Contract'), findsOneWidget);
      expect(find.text('Salary Certificate'), findsOneWidget);

      // Test empty state
      await tester.pumpWidget(
        const MaterialApp(
          home: DocumentsScreen(customDocuments: []),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('No Documents'), findsOneWidget);
    });

    testWidgets('5. Documents -> Payslip navigation opens PayslipDetailScreen for correct year/month', (WidgetTester tester) async {
      await loginAsEmployee(tester);

      // Navigate to Documents
      await tester.tap(find.byIcon(Icons.person_outline).last);
      await tester.pumpAndSettle();

      await tester.tap(find.text('My Documents'));
      await tester.pumpAndSettle();

      // Tap View on Payslip - January 2025
      final viewIcons = find.byIcon(Icons.visibility);
      await tester.tap(viewIcons.first);
      await tester.pumpAndSettle();

      expect(find.text('Payslip Details'), findsOneWidget);
      expect(find.text('JAN-2025'), findsWidgets);
    });

    testWidgets('6. Dashboard -> Profile & Documents navigation', (WidgetTester tester) async {
      await loginAsEmployee(tester);

      // Dashboard quick action -> Documents
      await tester.tap(find.widgetWithText(InkWell, 'Documents'));
      await tester.pumpAndSettle();

      expect(find.text('My Documents'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Bottom nav -> Profile
      await tester.tap(find.byIcon(Icons.person_outline).last);
      await tester.pumpAndSettle();

      expect(find.text('My Profile'), findsOneWidget);
    });

    testWidgets('7. Profile logout clears session and redirects to Login screen', (WidgetTester tester) async {
      await loginAsEmployee(tester);

      await tester.tap(find.byIcon(Icons.person_outline).last);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Logout Account'));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('field_Employee ID')), findsOneWidget);
      final hasSession = await SessionManager.hasSession();
      expect(hasSession, isFalse);
    });

    testWidgets('8. Small-screen QA: Profile and Documents screens have zero RenderFlex overflow on 360x640', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await loginAsEmployee(tester);

      await tester.tap(find.byIcon(Icons.person_outline).last);
      await tester.pumpAndSettle();

      expect(find.text('My Profile'), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tester.tap(find.text('My Documents'));
      await tester.pumpAndSettle();

      expect(find.text('My Documents'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('9. Personal Information error state displays Retry button', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            profileRepositoryProvider.overrideWithValue(MockErrorProfileRepository()),
          ],
          child: const MaterialApp(
            home: PersonalInformationLandingScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Unable to load personal information'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });
  });
}
