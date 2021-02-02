import 'dart:collection';

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(FirebaseCrudExampleApp());
}

class FirebaseCrudExampleApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String formCaption = 'Ready!';


  Future<void> _showDialog(String messageTitle,String message,String okCaption) async {
    setState(() {
      formCaption=message;
    });

    return showDialog<void>(
      context: context,
      barrierDismissible: false,

      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(messageTitle,semanticsLabel: "dialogTitle",),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(okCaption,semanticsLabel: 'Back',),
              onPressed: () {
                Navigator.of(context).pop();
              },

            ),
          ],
        );
      },
    );
  }


  void _create() async {
    bool exists=(await firestore.collection('users').doc('testUser').get()).exists;
    if (exists)
      {
        _showDialog('ERROR','ERROR ON CREATE: THE RECORD ALREADY EXISTS','Awww...');
        setState(() {
          formCaption='ERROR';
        });
      }
    else {
      await firestore.collection('users').doc('testUser').set({
        'firstName': 'Sandro',
        'lastName': 'Manzoni',});
      _showDialog('Success!','Record written successfully','Ok!');

    }

  }

  void _read() async {
    DocumentSnapshot documentSnapshot= await firestore.collection('users').doc('testUser').get();
      Map<String,dynamic> rec=documentSnapshot.data();

      if (rec==null)
        {
          _showDialog('Error','ERROR ON READ, THE RECORD WAS NOT FOUND','What a pity...');
        }
      else {
        SplayTreeMap<String,dynamic> record=SplayTreeMap.from(rec);
        _showDialog('Success!','Data found:\n $record','Got it!');
      }


  }

  void _update() async {
    
    
      firestore.collection('users').doc('testUser').update({
        'firstName': 'Alessandro',
      }).then((_) =>

          _showDialog('Success!','Record updated successfully! The name is changed to Alessandro', 'Ok, thank you!')

        )
          .catchError((e)
            {

              if (e.toString().startsWith("[cloud_firestore/not-found]"))
                {
                  _showDialog('ERROR','ERROR ON UPDATE, THE RECORD WAS NOT FOUND','Cannot update? WTF!');
                }
              else
                {
                  _showDialog('ERROR', 'Error on update:\n', 'Ok');
                }
            });
  }

  void _delete() async {

        bool exists=(await firestore.collection('users').doc('testUser').get()).exists;

        if (!exists)
          {
            _showDialog('ERROR','ERROR ON DELETE: THE RECORD DOESN`T EXIST','Can`t I delete the void?');
          }
        else
          {
            firestore.collection('users').doc('testUser').delete();
            _showDialog('Success!','Record deleted successfully!', 'I will miss it!');

          }



  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter CRUD with Firebase"),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Text(formCaption),
          SizedBox(height: 12,),
          RaisedButton(
            child: Text("Create",semanticsLabel: 'Create',),
            onPressed: _create,
          ),
          SizedBox(height: 12,),
          RaisedButton(
            child: Text("Read",semanticsLabel: 'Read',),
            onPressed: _read,
          ),
          SizedBox(height: 12,),
          RaisedButton(
            child: Text("Update",semanticsLabel: 'Update',),
            onPressed: _update,
          ),
          SizedBox(height: 12,),
          RaisedButton(
            child: Text("Delete",semanticsLabel: 'Delete',),
            onPressed: _delete,
          ),
        ]),
      ),
    );
  }
}