import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/binding.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:playground/main.dart' as app;

void main() {
  final WidgetsBinding binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('test integration', (tester) async {
    app.main();

    await tester.pumpAndSettle(Duration(seconds: 5));

    await tester.tap(find.text('Dialog')); 

    await tester.pumpAndSettle(Duration(seconds: 5));

    await tester.tap(find.text('HelloWorld!')); 

    await tester.pumpAndSettle();

    await tester.pumpAndSettle(Duration(seconds: 5));



    print(test);
 
  });
}
