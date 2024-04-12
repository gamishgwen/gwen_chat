import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gwen_chat/auth.dart';
import 'package:gwen_chat/user_provider.dart';
import 'package:provider/provider.dart';

import 'User.dart';
import 'firebase_options.dart';
import 'chat_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final UserProvider userProvider = UserProvider();

  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user != null) {
        userProvider.fetchCurrentUser(user.uid);
      }else {
        userProvider.resetCurrentUser();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableProvider(
      create: (context) {
        return userProvider;
      },
      child: MaterialApp(
        theme: ThemeData.dark(),
        home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return const AuthScreen();
              }
              return const ChatScreen();
            }),
      ),
    );
  }
}
