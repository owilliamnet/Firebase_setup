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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            FlatButton(
              child: Text('Google Sign-in'),
              color: Colors.blue[400],
              onPressed: () => _gSignin(),
            ),
            FlatButton(
              child: Text('Sign-in with E-mail'),
              color: Colors.orange[400],
              onPressed: () => _signInWithEmail(),
            ),
            FlatButton(
              child: Text('Create account'),
              color: Colors.teal[400],
              onPressed: () => _createUser(),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: FlatButton(
                color: Colors.redAccent,
                child: Text('Logout'),
                onPressed: () => _logout(),
              ),
            ),
            Image.network(_imageURL == null || _imageURL.isEmpty
                ? "https://via.placeholder.com/150"
                : _imageURL),
          ],
        ),
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

  Future _createUser() async {
    FirebaseUser user = await _auth
        .createUserWithEmailAndPassword(
            email: "wjpm222@gmail.com", password: "test0987")
        .then((user) {
      print("User created: ${user.displayName}");
      print("Email : ${user.email}");
    });
  }

  _logout() {
    setState(() {
      _googleSignIn.signOut();
      _imageURL = null;
    });
  }

  _signInWithEmail() {
    _auth
        .signInWithEmailAndPassword(
            email: "wjpm222@gmail.com", password: "test0987")
        .catchError((error) {
      print("Something went wrong! Error: ${error.toString()}");
    }).then((newUser) {
      print("User signed in: ${newUser.email}");
    });
  }
}
