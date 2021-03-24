import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crud_example/services/auth_adapter.dart';
import 'package:flutter/material.dart';
import '../res/custom_colors.dart';
import 'homepage.dart';
import '../widgets/sign_in_form.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomePage(
            user: user,
          ),
        ),
      );
    }

    return firebaseApp;
  }

  double step= 1.0;
  double vstep= 1.0;

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    step = size.width / 20.0;
    vstep = size.height / 30.0;


    return GestureDetector(
      onTap: () {
        _emailFocusNode.unfocus();
        _passwordFocusNode.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 20.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Image.asset(
                          'assets/images/firebase_logo.png',
                          height: 160,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'FlutterFire',
                        style: TextStyle(
                          color: CustomColors.firebaseYellow,
                          fontSize: 40,
                        ),
                      ),
                      Text(
                        'Authentication',
                        style: TextStyle(
                          color: CustomColors.firebaseOrange,
                          fontSize: 40,
                        ),
                      ),
                    ],
                  ),
                ),
                FutureBuilder(
                  future: _initializeFirebase(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error initializing Firebase');
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      return SignInForm(
                        emailFocusNode: _emailFocusNode,
                        passwordFocusNode: _passwordFocusNode,
                      );
                    }
                    return CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        CustomColors.firebaseOrange,
                      ),
                    );
                  },
                )
                ,
                SizedBox(height: vstep*2.0,),
                InkWell(
                  child: Container(
                    padding:  EdgeInsets.all(vstep),
                    color: Colors.grey,
                    child: Center(child:
                    Text('Login with Google')
                    ),
                  ),
                  onTap: loginWithGoogle,
                ),
                SizedBox(height: vstep*2.0,),
                InkWell(
                  child: Container(
                    padding:  EdgeInsets.all(vstep),
                    color: Colors.amber,
                    child: Center(child:
                      Text('Login anonimously')
                    ),
                  ),
                  onTap: loginAnonimously,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void loginAnonimously() async{
      User? user =
          await AuthServiceAdapter.signInAnonimously(
        context: context,
      );

      if (user != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomePage(
              user: user,
            ),
          ),
        );
      }


  }

  void loginWithGoogle() async{
    User? user =
    await AuthServiceAdapter.signInWithGoogle(
    );

    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomePage(
            user: user,
          ),
        ),
      );
    }


  }
}
