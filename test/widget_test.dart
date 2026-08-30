import 'package:flutter_test/flutter_test.dart';
import 'package:icore_ess/app.dart';

void main() {
  testWidgets('Login screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ICoreEssApp());
    expect(find.text('ebaConnect'), findsWidgets);
    expect(find.text('Login'), findsOneWidget);
  });
}
