// ignore_for_file: prefer_const_constructors, avoid_print, use_build_context_synchronously, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './verify_email_view.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        centerTitle: false,
      ),
      body: FutureBuilder(
        builder: (context, snapshot) {
          final user = _auth.currentUser;
          print(user);

          if (user!.emailVerified) {
            print('Your email verified');
          } else {
            print('you need to verify email first');
            Future.delayed(Duration.zero, () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => VerifiedEmail()));
            });
          }

          return Text('Done');
        },
      ),
    );
  }
}
