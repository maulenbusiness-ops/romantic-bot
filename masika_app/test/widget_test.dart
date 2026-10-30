import 'package:flutter_test/flutter_test.dart';
import 'package:masika/main.dart';

void main() {
  testWidgets('Masika app loads', (tester) async {
    await tester.pumpWidget(const MasikaApp());

    expect(find.text('Masika'), findsOneWidget);
    expect(find.text('Добавить расход'), findsOneWidget);
  });
}
