import 'package:flutter_test/flutter_test.dart';
import 'package:mirildan/mockup_app.dart';

void main() {
  testWidgets('MockupApp renders', (WidgetTester tester) async {
    await tester.pumpWidget(const MockupApp());
    expect(find.text('Mırıldan Mockuplar'), findsOneWidget);
  });
}
