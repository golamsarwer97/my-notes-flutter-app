// ignore_for_file: prefer_const_constructors, avoid_print, use_build_context_synchronously

import 'dart:developer' as devtools show log;

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../screens/login_view.dart';
import '../screens/verify_email_view.dart';
import '../utilities/show_custom_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  var isRegister = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.red,
      appBar: AppBar(
        title: Text('Register'),
        centerTitle: false,
      ),
      body: FutureBuilder(
        builder: (context, snapshot) {
          return Column(
            children: [
              TextField(
                controller: _email,
                enableSuggestions: true,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(hintText: 'Enter your email here'),
              ),
              TextField(
                controller: _password,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration:
                    InputDecoration(hintText: 'Enter your password here'),
              ),
              TextButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;

                  try {
                    final userCredential =
                        await _auth.createUserWithEmailAndPassword(
                      email: email,
                      password: password,
                    );
                    devtools.log(userCredential.toString());

                    final user = _auth.currentUser;
                    await user!.sendEmailVerification();
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => VerifiedEmail()),
                      (_) => false,
                    );

                    setState(() {
                      userCredential.additionalUserInfo!.isNewUser
                          ? isRegister = true
                          : isRegister = false;
                    });
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      // devtools.log('Weak Password');
                      await showErrorDialog(context, 'Weak Password');
                    } else if (e.code == 'email-already-in-use') {
                      // devtools.log('Email is already in use');
                      await showErrorDialog(context, 'Email is already in use');
                    } else if (e.code == 'invalid-email') {
                      // devtools.log('Invalid email entered');
                      await showErrorDialog(context, 'Invalid email entered');
                    } else {
                      devtools.log(e.code);
                      await showErrorDialog(context, e.code);
                    }
                  } catch (e) {
                    await showErrorDialog(context, 'Error: ${e.toString()}');
                  }
                },
                child: Text('Register'),
              ),
              // SizedBox(height: 50),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LoginView()),
                    (_) => false,
                  );
                },
                child: Text(isRegister
                    ? 'You registered successfully. Go to the Login Page !!'
                    : 'Already registered? Login here!!'),
              ),
            ],
          );
        },
      ),
    );
  }
}
