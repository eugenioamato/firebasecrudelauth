import 'package:flutter/material.dart';
import 'app.dart';
import 'database_interface.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseInterface().initializeApp();
  runApp(FirebaseCrudExampleApp());
}
