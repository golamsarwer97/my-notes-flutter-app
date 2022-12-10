// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './login_view.dart';

class VerifiedEmail extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Email'),
        centerTitle: false,
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Text(
            "We've sent you an email verification. Please open it to verify your account.",
          ),
          SizedBox(height: 10),
          Text(
            "If you haven't received a verification email yet, press the button below.",
          ),
          TextButton(
            onPressed: () async {
              final user = _auth.currentUser;
              await user!.sendEmailVerification();
            },
            child: Text('Send verification email'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginView()),
                (_) => false,
              );
            },
            child: Text('Go to the Login Page !!'),
          ),
        ],
      ),
    );
  }
}
