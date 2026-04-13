import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:visitcn_app/main.dart';

void main() {
  testWidgets('App loads correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const VisitCNApp());

    // Verify the app title is present
    expect(find.text('VisitCN'), findsOneWidget);
  });
}
