import 'dart:io';
import 'package:gwen_chat/user_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  var enteredEmail = '';
  var enteredUserName = '';
  var enteredPassword = '';
  bool _isLogin = true;
  File? selectedImage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(right: 20, left: 20, top: 30),
              width: 200,
              child: Icon(
                Icons.chat,
                size: 160,
              ),
            ),
            Card(
              margin: EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        if (!_isLogin) UserImage(),
                        TextFormField(
                          decoration: InputDecoration(
                            label: Text('Email Address'),
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                !value.contains('@')) {
                              return 'please enter valid email address';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            enteredEmail = newValue!;
                          },
                        ),
                        if (!_isLogin)
                          TextFormField(
                            decoration: InputDecoration(
                              label: Text('User Name'),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'please enter valid user name';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              enteredUserName = newValue!;
                            },
                          ),
                        TextFormField(
                          decoration: InputDecoration(
                            label: Text('Password'),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().length < 10) {
                              return 'please enter password atleast 10 characters';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            enteredPassword = newValue!;
                          },
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        ElevatedButton(
                            onPressed: () {},
                            child: Text(_isLogin ? 'Login' : 'sign up')),
                        TextButton(
                            onPressed: () {
                              setState(() {
                                _isLogin = !_isLogin;
                              });
                            },
                            child: Text(_isLogin
                                ? 'Create new account'
                                : 'Already have an account?'))
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
