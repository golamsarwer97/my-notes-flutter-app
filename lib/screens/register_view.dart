// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_notes_flutter/screens/login_view.dart';

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
                        await _auth.createUserWithEmailAndPassword(
                      email: email,
                      password: password,
                    );
                    print(userCredential);
                    setState(() {
                      userCredential.additionalUserInfo!.isNewUser
                          ? isRegister = true
                          : isRegister = false;
                    });
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      print('Weak Password');
                    } else if (e.code == 'email-already-in-use') {
                      print('Email is already in use');
                    } else if (e.code == 'invalid-email') {
                      print('Invalid email entered');
                    } else {
                      print(e.code);
                    }
                  }
                },
                child: Text('Register'),
              ),
              // SizedBox(height: 50),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginView()),
                  );
                },
                child: Text(isRegister
                    ? 'Go to the Login Page !!'
                    : 'Already registered? Login here!!'),
              ),
            ],
          );
        },
      ),
    );
  }
}
