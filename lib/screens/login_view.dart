// ignore_for_file: prefer_const_constructors, avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './home_view.dart';
import './register_view.dart';

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
                    print(userCredential);
                    await Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => MyHomePage()),
                    );
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      print('User not found');
                    } else if (e.code == 'wrong-password') {
                      print('Wrong Password');
                    }
                    print(e.code);
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
