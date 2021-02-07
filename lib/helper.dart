import 'package:flutter/cupertino.dart';

import 'views/homepage.dart';

class Helper
{
  static bool _loading=false;

  // ignore: invalid_use_of_protected_member
  static void startLoading(State s)=> s.setState((){_loading=true;});

  // ignore: invalid_use_of_protected_member
  static void stopLoading(State s)=> s.setState((){_loading=false;});

  static bool isLoading() => _loading;
}