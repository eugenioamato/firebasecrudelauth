import 'package:firebase_crud_example/services/auth.dart';
import 'package:firebase_crud_example/services/auth_adapter.dart';
import 'package:firebase_crud_example/views/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FirebaseCrudExampleApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Provider<AuthService>(
        create: (_) => AuthServiceAdapter(),
    dispose: (_, AuthService authService) => authService.dispose(),
    child: MaterialApp(
      home: SignInScreen(),
      debugShowCheckedModeBanner: false,
    )
    )
    ;
  }
}

