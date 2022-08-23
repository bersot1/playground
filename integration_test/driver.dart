import 'dart:io';

import 'package:integration_test/integration_test_driver.dart';

Future<void> main() async {
  await Process.run('adb', [
    'shell',
    'pm',
    'grant',
    'com.example.playground',
    'android.permission.ACCESS_COARSE_LOCATION',
  ]);

  integrationDriver(
    
  );
}
