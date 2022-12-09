// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:developer' as devtools show log;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/login_view.dart';

enum MenuAction { logout }

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Notes'),
          actions: [
            PopupMenuButton(
              onSelected: (value) async {
                // log(value.toString());
                switch (value) {
                  case MenuAction.logout:
                    final shouldLogout = await showLogoutDialog(context);
                    devtools.log(shouldLogout.toString());
                    // break;
                    if (shouldLogout) {
                      await FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => LoginView()),
                        (_) => false,
                      );
                    }
                }
              },
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    value: MenuAction.logout,
                    child: Text('Log Out'),
                  ),
                ];
              },
            ),
          ],
        ),
        body: Text('hello dhaka !!!!!'),
      ),
    );
  }
}

Future<bool> showLogoutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Sign Out'),
        content: Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text('Log Out'),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}
