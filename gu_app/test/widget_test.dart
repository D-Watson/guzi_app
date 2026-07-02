import 'package:flutter_test/flutter_test.dart';

import 'package:gu_app/main.dart';

void main() {
  testWidgets('App renders home page', (WidgetTester tester) async {
    await tester.pumpWidget(const GuApp());
    // 验证首页包含"首页"标签
    expect(find.text('首页'), findsOneWidget);
  });
}