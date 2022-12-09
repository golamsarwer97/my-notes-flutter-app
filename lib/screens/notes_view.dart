// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:developer' as devtools show log;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/login_view.dart';
import '../utilities/show_custom_dialog.dart';

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
