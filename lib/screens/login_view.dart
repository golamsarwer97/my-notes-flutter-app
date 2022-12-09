// ignore_for_file: prefer_const_constructors, avoid_print, use_build_context_synchronously

import 'dart:developer' as devtools show log;

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './home_view.dart';
import './register_view.dart';
import '../utilities/show_custom_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
        title: Text('Login'),
        centerTitle: false,
      ),
      body: FutureBuilder(
        builder: (context, snapshot) {
          // switch (snapshot.connectionState) {
          //   case ConnectionState.done:
          //     break;
          //   default:
          //     return const Text('Loading...');
          // }

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
                        await _auth.signInWithEmailAndPassword(
                      email: email,
                      password: password,
                    );
                    devtools.log(userCredential.toString());
                    await Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => MyHomePage()),
                      (_) => false,
                    );
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      // devtools.log('User not found');
                      await showErrorDialog(context, 'User not found');
                    } else if (e.code == 'wrong-password') {
                      // devtools.log('Wrong Password');
                      await showErrorDialog(context, 'Wrong Password');
                    } else {
                      devtools.log(e.code);
                      await showErrorDialog(context, e.code);
                    }
                  } catch (e) {
                    await showErrorDialog(context, 'Error: ${e.toString()}');
                  }
                },
                child: Text('Login'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => RegisterView()),
                  );
                },
                child: Text('Not registered yet? Register here !!'),
              ),
            ],
          );
        },
      ),
    );
  }
}
