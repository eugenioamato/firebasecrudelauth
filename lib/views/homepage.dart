import 'dart:async';
import 'dart:collection';
import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crud_example/res/custom_colors.dart';
import 'package:firebase_crud_example/services/auth_adapter.dart';
import 'package:firebase_crud_example/views/sign_in_screen.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import '../helper.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../services/db_interface_stub.dart'
    if (dart.library.io) '../services/database_interface.dart'
    if (dart.library.html) '../services/web_database_interface.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController scrollController = ScrollController();
  StreamSubscription? listener;
  late bool _isEmailVerified;
  late User _user;
  bool _verificationEmailBeingSent = false;
  bool _isSigningOut = false;

  Key formKey = Key('form');

  double step = 0.0;
  double vstep = 0.0;
  String formCaption = 'Ready!';
  Color formColor = Colors.black;
  bool formVisible = true;
  bool waitingForFirstConnection = true;

  List _dbMessages = [];

  List<Widget> get pageItems => [
        Image.asset(
          'assets/images/flutter_logo.png',
          height: vstep * 8.0,
        ),
        Image.asset(
          'assets/images/firebase_logo.png',
          height: vstep * 7.0,
        ),
        SizedBox(
          height: vstep * 2.0,
        ),
        Center(
          child: Text(
            'Welcome ${_user.displayName??_user.uid}'
          ),
        ),
    Visibility(
      visible: !_user.isAnonymous,
      child: _isEmailVerified
          ? Flex(
        direction: Axis.horizontal,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(flex:1,
            child: ClipOval(
              child: Material(
                color: Colors.greenAccent.withOpacity(0.6),
                child: Padding(
                  padding:  EdgeInsets.all(vstep/3.0),
                  child: Icon(
                    Icons.check,
                    //size: vstep*2,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: vstep),
          Expanded(
            flex: 2,
            child: AutoSizeText(
              'Email is verified',
              style: TextStyle(
                color: Colors.greenAccent,
                fontSize: vstep,
                letterSpacing: vstep/4.0,
              ),
            ),
          ),
        ],
      )
          : Flex(
        direction: Axis.horizontal,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(flex:1,
            child: ClipOval(
              child: Material(
                color: Colors.redAccent.withOpacity(0.8),
                child: Padding(
                  padding:  EdgeInsets.all(vstep/2),
                  child: Icon(
                    Icons.close,
                    //size: vstep*2,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: vstep),
          Expanded(flex:2,
            child: AutoSizeText(
              'Email is not verified',
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: vstep,
                letterSpacing: vstep/4.0,
              ),
            ),
          ),
        ],
      ),
    ),
    Visibility(
      visible: (!_isEmailVerified)&&(!_user.isAnonymous),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _verificationEmailBeingSent
              ? CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              CustomColors.firebaseGrey,
            ),
          )
              : ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                CustomColors.firebaseGrey,
              ),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            onPressed: () async {
              setState(() {
                _verificationEmailBeingSent = true;
              });
              await _user.sendEmailVerification();
              setState(() {
                _verificationEmailBeingSent = false;
              });
            },
            child: Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Text(
                'Verify',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: CustomColors.firebaseNavy,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
          SizedBox(width: 16.0),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () async {
              User? user = await AuthServiceAdapter.refreshUser(_user);

              if (user != null) {
                setState(() {
                  _user = user;
                  _isEmailVerified = user.emailVerified;
                });
              }
            },
          ),
        ],
      ),
    ),
    InkWell(
      child: Container(
        padding:  EdgeInsets.all(vstep),
        color: Colors.amber,
        child: Center(child:
        Text('Logout')
        ),
      ),
      onTap: logout,
    ),

    SizedBox(height: vstep *2.0),

        Center(
            child: VisibilityDetector(
          key: formKey,
          onVisibilityChanged: (VisibilityInfo info) {
            formVisible = info.visibleFraction == 1.0;
          },
          child: AutoSizeText(
            formCaption,
            maxLines: 2,
            style: TextStyle(color: formColor),
            semanticsLabel: 'formCaption',
          ),
        )),
        SizedBox(
          height: vstep,
        ),
        actionButton('Create', Icons.create, _create),
        SizedBox(
          height: vstep,
        ),
        actionButton('Read', Icons.read_more, _read),
        SizedBox(
          height: vstep,
        ),
        actionButton('Update', Icons.update, _update),
        SizedBox(
          height: vstep,
        ),
        actionButton('Delete', Icons.delete, _delete),
        SizedBox(
          height: vstep,
        ),
        AutoSizeText(dbMessages),
        SizedBox(
          height: vstep,
        ),
      ];

  String get dbMessages => _dbMessages.toString();

  Future<void> startListening() async {
    listener = DatabaseInterface().listen('users', manageEvent);
  }

  actionButton(text, icon, func) => ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.amberAccent),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
        ),
        child: Flex(direction: Axis.horizontal, children: [
          Expanded(child: Icon(icon)),
          Expanded(
            flex: 3,
            child: AutoSizeText(
              text,
              semanticsLabel: text,
              maxLines: 1,
            ),
          ),
        ]),
        onPressed: Helper.isLoading() ? null : func,
      );

  void refresh() {
    if (mounted) setState(() {});
  }

  initState() {
    super.initState();
    _user=widget._user;
    _isEmailVerified = _user.emailVerified;
    print('user: $_user verified: $_isEmailVerified');
    Helper.startLoading(refresh);
    DatabaseInterface().init('users', startListening);
  }

  dispose() {
    super.dispose();
    listener?.cancel();
  }

  void showErrorSnackbar(bool short) {
    SnackBar errorSnackBar = SnackBar(
      content: Text('No Internet connection!'),
      backgroundColor: Colors.red,
      duration: Duration(seconds: short ? 5 : 5000),
    );
    ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
  }

  bool errorInConnectivity = false;

  void manageEvent(events) {
    if (waitingForFirstConnection) {
      if (events.toString() == '()') {
        showErrorSnackbar(false);
        errorInConnectivity = true;
      } else {
        if (errorInConnectivity) {
          errorInConnectivity = false;
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        }
        waitingForFirstConnection = false;
        Helper.stopLoading(refresh);
      }
    }
    _dbMessages.clear();
    setState(() {
      _dbMessages.addAll(events);
    });
  }

  Future<void> _showMessage(String messageTitle, String message,
      String okCaption, Color textColor) async {
    setState(() {
      formCaption = message;
      formColor = textColor;
    });
    if (!formVisible)
      scrollController.animateTo(0,
          duration: Duration(seconds: 1), curve: Curves.linear);
  }

  void _create() async {
    Helper.startLoading(refresh);
    try {
      bool exists = await DatabaseInterface().exists('users', 'testUser');
      if (exists) {
        _showMessage('ERROR', 'ERROR ON CREATE: THE RECORD ALREADY EXISTS',
            'Awww...', Colors.red);
      } else {
        await DatabaseInterface().set('users', 'testUser', {
          'firstName': 'Sandro',
          'lastName': 'Manzoni',
        });

        _showMessage(
            'Success!', 'Record written Successfully', 'Ok!', Colors.black);
      }
    } catch (e) {
      if (e.toString().startsWith('[cloud_firestore/unavailable]')) {
        errorInConnectivity = true;
        waitingForFirstConnection = true;
        showErrorSnackbar(true);
      }
    }

    Helper.stopLoading(refresh);
  }

  void _read() async {
    Helper.startLoading(refresh);
    try {
      Map<String, dynamic>? rec =
          await DatabaseInterface().read('users', 'testUser');

      if (rec == null) {
        _showMessage('Error', 'ERROR ON READ, THE RECORD WAS NOT FOUND',
            'What a pity...', Colors.red);
      } else {
        SplayTreeMap<String, dynamic> record = SplayTreeMap.from(rec);
        _showMessage(
            'Success!', 'Data found: $record', 'Got it!', Colors.black);
      }
    } catch (e) {
      if (e.toString().startsWith('[cloud_firestore/unavailable]')) {
        errorInConnectivity = true;
        waitingForFirstConnection = true;
        showErrorSnackbar(true);
      }
    }
    Helper.stopLoading(refresh);
  }

  void _update() async {
    Helper.startLoading(refresh);

    try {
      DatabaseInterface().update('users', 'testUser', {
        'firstName': 'Alessandro',
      }).then((_) {
        _showMessage(
            'Success!',
            'Record updated Successfully! The name is changed to Alessandro',
            'Ok, thank you!',
            Colors.black);
        Helper.stopLoading(refresh);
      }).catchError((e) {
        if ((e.toString().startsWith("[cloud_firestore/not-found]")) ||
            (e.toString().startsWith("FirebaseError: No document to update"))) {
          _showMessage('ERROR', 'ERROR ON UPDATE, THE RECORD WAS NOT FOUND',
              'Cannot update? WTF!', Colors.red);
        } else {
          _showMessage(
              'ERROR', 'Error on update:${e.toString()}', 'Ok', Colors.red);
        }
        Helper.stopLoading(refresh);
      });
    } catch (e) {
      if (e.toString().startsWith('[cloud_firestore/unavailable]')) {
        errorInConnectivity = true;
        waitingForFirstConnection = true;
        showErrorSnackbar(true);
        Helper.stopLoading(refresh);
      }
    }
  }

  void _delete() async {
    Helper.startLoading(refresh);
    try {
      bool exists = await DatabaseInterface().exists('users', 'testUser');

      if (!exists) {
        _showMessage('ERROR', 'ERROR ON DELETE: THE RECORD DOESN`T EXIST',
            'Can`t I delete the void?', Colors.red);
      } else {
        await DatabaseInterface().delete('users', 'testUser');
        _showMessage('Success!', 'Record deleted Successfully!',
            'I will miss it!', Colors.black);
      }
    } catch (e) {
      if (e.toString().startsWith('[cloud_firestore/unavailable]')) {
        errorInConnectivity = true;
        waitingForFirstConnection = true;
        showErrorSnackbar(true);
      }
    }
    Helper.stopLoading(refresh);
  }

  @override
  Widget build(BuildContext context) {
    if (step == 0.0) {
      Size size = MediaQuery.of(context).size;
      step = size.width / 20.0;
      vstep = size.height / 30.0;
    }

    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Colors.white,
          Colors.white,
          Colors.white,
          Colors.cyanAccent
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              toolbarHeight: vstep,
              title: Helper.isLoading()
                  ? LinearProgressIndicator(minHeight: vstep)
                  : Container(
                      color: Colors.transparent,
                    ),
            ),
            body: Padding(
              padding: EdgeInsets.only(left: step, right: step),
              child: ListView.builder(
                  controller: scrollController,
                  itemCount: pageItems.length,
                  itemBuilder: (context, index) => pageItems[index]),
            ),
          ),
        ));
  }

  void logout()  async {
      setState(() {
        _isSigningOut = true;
      });
      await FirebaseAuth.instance.signOut();
      setState(() {
        _isSigningOut = false;
      });
      Navigator.of(context)
          .pushReplacement(_routeToSignInScreen());
    }

  Route _routeToSignInScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SignInScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

}
