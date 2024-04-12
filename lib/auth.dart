import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gwen_chat/User.dart';
import 'package:gwen_chat/chat_page.dart';
import 'package:gwen_chat/user_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

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
  bool _isLoading = false;
  bool _isLogin = true;
  File? selectedImage;

  void updateImage(File updatedFile){
    selectedImage= updatedFile;
  }

  Future<void> signUp() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        final storageRef = FirebaseStorage.instance.ref();
        final profilepicRef = storageRef.child("profile_pics/${path.basename(selectedImage!.path)}");
        await profilepicRef.putFile(selectedImage!);
        final url= await profilepicRef.getDownloadURL();

        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: enteredEmail,
          password: enteredPassword,

        ); final userId= credential.user?.uid;
       UserDetails user=  UserDetails(userId!, enteredUserName, enteredEmail, url);
       await FirebaseFirestore.instance.collection('users').doc(userId!).set(user.toJson());
        print(credential);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        }
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: enteredEmail, password: enteredPassword);
        print(credential);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
      }
    }
  }

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
                        if (!_isLogin) UserImage(onUpdateImage:updateImage ,),
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
                            onPressed: () async{
                              setState(() {
                                _isLoading=true;
                              });

                             _isLogin ? await login() : await signUp();
                             setState(() {
                               _isLoading=false;
                             });


                            },
                            child: SizedBox(
                                width: 100,
                                child: Center(
                                    child: _isLoading
                                        ? CircularProgressIndicator()
                                        : Text(
                                            _isLogin ? 'Login' : 'sign up')))),
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
