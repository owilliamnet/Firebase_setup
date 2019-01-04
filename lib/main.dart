import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Community Board',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: MyNewHomePage(),
    );
  }
}

class MyNewHomePage extends StatefulWidget {
  _MyNewHomePageState createState() => _MyNewHomePageState();
}

class _MyNewHomePageState extends State<MyNewHomePage> {
  String _imageURL;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Board'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          FlatButton(
            child: Text('Google Sign-in'),
            color: Colors.blue[400],
            onPressed: () => _gSignin(),
          ),
          FlatButton(
            child: Text('Sign-in with E-mail'),
            color: Colors.orange[400],
            onPressed: () {},
          ),
          FlatButton(
            child: Text('Create account'),
            color: Colors.teal[400],
            onPressed: () {},
          ),
          Image.network(_imageURL == null || _imageURL.isEmpty
              ? "https://via.placeholder.com/150"
              : _imageURL),
        ],
      ),
    );
  }

  Future<FirebaseUser> _gSignin() async {
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    FirebaseUser user = await _auth.signInWithGoogle(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    print("User is: ${user.displayName}");

    setState(() {
      _imageURL = user.photoUrl;
    });
  }
}
