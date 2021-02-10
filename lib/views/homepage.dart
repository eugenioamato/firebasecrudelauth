import 'dart:async';
import 'dart:collection';
import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import '../helper.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../services/database_interface.dart'
    if (dart.library.html) '../services/web_database_interface.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController scrollController = ScrollController();
  StreamSubscription listener;

  Key formKey = Key('form');

  double step = 0.0;
  double vstep = 0.0;
  String formCaption = 'Ready!';
  Color formColor = Colors.black;
  bool formVisible = true;

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

  actionButton(text, icon, func) => RaisedButton(
        color: Colors.amberAccent,
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

  initState() {
    super.initState();

    Helper.startLoading(this);
    DatabaseInterface()
        .init('users', () => Helper.stopLoading(this), startListening);
  }

  dispose() {
    super.dispose();
    listener.cancel();
  }

  void manageEvent(events) {
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
    Helper.startLoading(this);
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

    Helper.stopLoading(this);
  }

  void _read() async {
    Helper.startLoading(this);
    Map<String, dynamic> rec =
        await DatabaseInterface().read('users', 'testUser');

    if (rec == null) {
      _showMessage('Error', 'ERROR ON READ, THE RECORD WAS NOT FOUND',
          'What a pity...', Colors.red);
    } else {
      SplayTreeMap<String, dynamic> record = SplayTreeMap.from(rec);
      _showMessage('Success!', 'Data found: $record', 'Got it!', Colors.black);
    }

    Helper.stopLoading(this);
  }

  void _update() async {
    Helper.startLoading(this);

    DatabaseInterface().update('users', 'testUser', {
      'firstName': 'Alessandro',
    }).then((_) {
      _showMessage(
          'Success!',
          'Record updated Successfully! The name is changed to Alessandro',
          'Ok, thank you!',
          Colors.black);
      Helper.stopLoading(this);
    }).catchError((e) {
      if ((e.toString().startsWith("[cloud_firestore/not-found]")) ||
          (e.toString().startsWith("FirebaseError: No document to update"))) {
        _showMessage('ERROR', 'ERROR ON UPDATE, THE RECORD WAS NOT FOUND',
            'Cannot update? WTF!', Colors.red);
      } else {
        _showMessage(
            'ERROR', 'Error on update:${e.toString()}', 'Ok', Colors.red);
      }
      Helper.stopLoading(this);
    });
  }

  void _delete() async {
    Helper.startLoading(this);
    bool exists = await DatabaseInterface().exists('users', 'testUser');

    if (!exists) {
      _showMessage('ERROR', 'ERROR ON DELETE: THE RECORD DOESN`T EXIST',
          'Can`t I delete the void?', Colors.red);
    } else {
      await DatabaseInterface().delete('users', 'testUser');
      _showMessage('Success!', 'Record deleted Successfully!',
          'I will miss it!', Colors.black);
    }

    Helper.stopLoading(this);
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
}
