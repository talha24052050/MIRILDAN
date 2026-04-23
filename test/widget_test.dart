import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mirildan/app.dart';

void main() {
  testWidgets('MiriildanApp renders without crash', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MiriildanApp()),
    );
    expect(find.byType(MiriildanApp), findsOneWidget);
  });
}
