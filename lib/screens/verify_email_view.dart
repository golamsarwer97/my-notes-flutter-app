// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
          Text('Please Verify Your Email'),
          TextButton(
            onPressed: () async {
              final user = _auth.currentUser;
              await user!.sendEmailVerification();
            },
            child: Text('Send verification email'),
          ),
        ],
      ),
    );
  }
}
