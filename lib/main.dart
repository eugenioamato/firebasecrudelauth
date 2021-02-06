import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'app.dart';
import 'web_database_interface.dart'
if (dart.library.io)
'database_interface.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb)
  await DatabaseInterface().initializeApp();
  runApp(FirebaseCrudExampleApp());
}
