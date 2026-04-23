import 'package:flutter_test/flutter_test.dart';

import 'package:gamerloop/main.dart';

void main() {
  testWidgets('Welcome screen shows heading', (WidgetTester tester) async {
    await tester.pumpWidget(const GamerApp());

    expect(find.text('HOŞGELDİN'), findsOneWidget);
  });
}
