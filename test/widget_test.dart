import 'package:flutter_test/flutter_test.dart';
import 'package:icore_ess/app.dart';
import 'test_utils.dart';

void main() {
  setupSecureStorageMock();

  testWidgets('Login screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ICoreEssApp());
    await tester.pumpAndBootstrap();
    expect(find.text('ebaConnect'), findsWidgets);
    expect(find.text('Login'), findsOneWidget);
  });
}
