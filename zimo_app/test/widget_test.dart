import 'package:flutter_test/flutter_test.dart';

import 'package:zimo_app/app/zimo_app.dart';

void main() {
  testWidgets('renders splash screen and opens welcome screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ZimoApp());

    expect(find.text('ZIMO'), findsOneWidget);
    expect(find.text('Powered by Cetus Technologys'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Rent without middlemen and find your next home faster.',
      ),
      findsOneWidget,
    );
  });
}
