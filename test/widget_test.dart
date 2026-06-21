import 'package:flutter_test/flutter_test.dart';
import 'package:subtrack/main.dart';

void main() {
  testWidgets('SubsTrack app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const SubsTrackApp());
    expect(find.text('SubsTrack'), findsWidgets);
  });
}
