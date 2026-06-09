import 'package:flutter_test/flutter_test.dart';
import 'package:ghras_app/main.dart';

void main() {
  testWidgets('GhrasApp test', (WidgetTester tester) async {
    // نبني التطبيق الخاص بك
    await tester.pumpWidget(const GhrasApp());
  });
}
