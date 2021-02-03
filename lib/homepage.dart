import 'dart:collection';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'database_interface.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double step = 0.0;
  double vstep = 0.0;
  String formCaption = 'Ready!';
  Color formColor = Colors.black;
  bool formVisible = true;

  bool loading = true;

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
          height: vstep * 4.0,
        ),
        Center(
            child: VisibilityDetector(
              key: formKey,
              onVisibilityChanged: (VisibilityInfo info) { formVisible=info.visibleFraction==1.0; },
              child: AutoSizeText(formCaption,
                  maxLines: 2, style: TextStyle(color: formColor)),
            )),
        SizedBox(
          height: vstep,
        ),
        Flex(
          direction: Axis.horizontal,
          children: [
            Spacer(
              flex: 1,
            ),
            Expanded(
              flex: 8,
              child: ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    RaisedButton(
                      color: Colors.amberAccent,
                      child: AutoSizeText(
                        "Create",
                        semanticsLabel: 'Create',
                        maxLines: 1,
                      ),
                      onPressed: loading ? null : _create,
                    ),
                    SizedBox(
                      height: vstep,
                    ),
                    RaisedButton(
                      color: Colors.amberAccent,
                      child: AutoSizeText(
                        "Read",
                        semanticsLabel: 'Read',
                        maxLines: 1,
                      ),
                      onPressed: loading ? null : _read,
                    ),
                    SizedBox(
                      height: vstep,
                    ),
                    RaisedButton(
                      color: Colors.amberAccent,
                      child: AutoSizeText(
                        "Update",
                        semanticsLabel: 'Update',
                        maxLines: 1,
                      ),
                      onPressed: loading ? null : _update,
                    ),
                    SizedBox(
                      height: vstep,
                    ),
                    RaisedButton(
                      color: Colors.amberAccent,
                      child: AutoSizeText(
                        "Delete",
                        semanticsLabel: 'Delete',
                        maxLines: 1,
                      ),
                      onPressed: loading ? null : _delete,
                    ),
                  ]),
            ),
            Spacer(
              flex: 1,
            )
          ],
        ),
        SizedBox(
          height: vstep,
        )
      ];

  ScrollController scrollController = ScrollController();
  Key formKey = Key('form');

  initState() {
    DatabaseInterface().init(stopLoading);

    super.initState();
  }

  startLoading() {
    setState(() {
      loading = true;
    });
  }

  stopLoading() {
    setState(() {
      loading = false;
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
    startLoading();
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

    stopLoading();
  }

  void _read() async {
    startLoading();
    Map<String, dynamic> rec =
        await DatabaseInterface().read('users', 'testUser');

    if (rec == null) {
      _showMessage('Error', 'ERROR ON READ, THE RECORD WAS NOT FOUND',
          'What a pity...', Colors.red);
    } else {
      SplayTreeMap<String, dynamic> record = SplayTreeMap.from(rec);
      _showMessage(
          'Success!', 'Data found: $record', 'Got it!', Colors.black);
    }

    stopLoading();
  }

  void _update() async {
    startLoading();

    DatabaseInterface().update('users', 'testUser', {
      'firstName': 'Alessandro',
    }).then((_) {
      _showMessage(
          'Success!',
          'Record updated Successfully! The name is changed to Alessandro',
          'Ok, thank you!',
          Colors.black);
      stopLoading();
    }).catchError((e) {
      if (e.toString().startsWith("[cloud_firestore/not-found]")) {
        _showMessage('ERROR', 'ERROR ON UPDATE, THE RECORD WAS NOT FOUND',
            'Cannot update? WTF!', Colors.red);
      } else {
        _showMessage('ERROR', 'Error on update:\n', 'Ok', Colors.red);
      }
      stopLoading();
    });
  }

  void _delete() async {
    startLoading();
    bool exists = await DatabaseInterface().exists('users', 'testUser');

    if (!exists) {
      _showMessage('ERROR', 'ERROR ON DELETE: THE RECORD DOESN`T EXIST',
          'Can`t I delete the void?', Colors.red);
    } else {
      await DatabaseInterface().delete('users', 'testUser');
      _showMessage('Success!', 'Record deleted Successfully!',
          'I will miss it!', Colors.black);
    }

    stopLoading();
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
              title: loading
                  ? LinearProgressIndicator(minHeight: vstep)
                  : Container(color: Colors.transparent,),
            ),
            body: Padding(
              padding: EdgeInsets.only(left: step, right: step),
              child: ListView.builder(
                  key: Key('scroller'),
                  controller: scrollController,
                  shrinkWrap: true,
                  itemCount: pageItems.length,
                  itemBuilder: (context, index) => pageItems[index]),
            ),
          ),
        ));
  }
}
