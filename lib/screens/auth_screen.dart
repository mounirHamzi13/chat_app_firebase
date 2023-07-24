import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../widgets/image_picker.dart';
import 'package:flutter/services.dart' show rootBundle;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // final File noPfpPhoto = const AssetImage('assets/images/npPFP.jpg') as File;
  final auth = FirebaseAuth.instance;
  bool isLoading = false;

  Future<String> putImage(XFile? userImage, Reference ref) async {
    if (userImage != null) {
      await ref.putFile(File(userImage.path));
      return ref.getDownloadURL();
    } else {
      return 'https://i.pinimg.com/236x/9e/83/75/9e837528f01cf3f42119c5aeeed1b336.jpg';
    }
  }

  void submitAuthForm(String email, String password, String username,
      bool isLogin, XFile? userImage) async {
    print(email);
    print(password);
    print(username);
    UserCredential authResult;
    try {
      setState(() {
        isLoading = true;
      });

      if (isLogin) {
        // ... (existing code for login)
      } else {
        authResult = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        print('heeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeere');
        print(userImage);
        print(username);
        print(authResult.user!.uid);

        final ref = await FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child(authResult.user!.uid + '.jpg');
        // Use conditional expression to decide whether to upload userImage or asset image
        final url = await putImage(userImage, ref);
        print(url);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user!.uid)
            .set({
          'username': username,
          'email': email,
          'imageUrl': url,
        });
      }

      setState(() {
        isLoading = false;
      });
    } on PlatformException catch (e) {
      // ... (existing code for error handling)
    } catch (err) {
      // ... (existing code for error handling)
    }
  }

  final formkey = GlobalKey<FormState>();
  String userEmail = '';
  String userPassword = '';
  String userName = '';
  XFile? userImage;

  bool isLogin = false;

  void trySubmit() {
    final isValid = formkey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      formkey.currentState!.save();
      submitAuthForm(userEmail, userPassword, userName, isLogin, userImage);
    }
  }

  void setImage(XFile? image) {
    setState(() {
      userImage = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
          child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Form(
                  key: formkey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!isLogin) UserImagePicker(setImage),
                      TextFormField(
                        key: ValueKey('email'),
                        onSaved: (value) {
                          userEmail = value!;
                        },
                        validator: (value) {
                          if (value!.isEmpty || !value.contains('@')) {
                            return 'Please enter a valid email adress';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(label: Text('Email')),
                      ),
                      if (!isLogin)
                        TextFormField(
                          key: ValueKey('username'),
                          onSaved: (value) {
                            userName = value!;
                          },
                          validator: (value) {
                            if (value!.isEmpty || value.length < 4) {
                              return 'Please enter at least 4 characters ';
                            }
                            return null;
                          },
                          decoration: InputDecoration(label: Text('Username')),
                        ),
                      TextFormField(
                        key: ValueKey('password'),
                        onSaved: (value) {
                          userPassword = value!;
                        },
                        validator: (value) {
                          if (value!.isEmpty || value.length < 8) {
                            return 'Password is not long enough';
                          }
                          return null;
                        },
                        decoration: InputDecoration(label: Text('Password')),
                        obscureText: true,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      if (isLoading)
                        const Center(
                          child: CircularProgressIndicator(
                              backgroundColor: Colors.pink),
                        ),
                      // if (!isLoading)
                      //   ElevatedButton(
                      //     onPressed: trySubmit,
                      //     child: Text(isLogin ? 'Login' : 'Sign Up'),
                      //   ),
                      if (!isLoading)
                        TextButton(
                            onPressed: () {
                              setState(() {
                                isLogin = !isLogin;
                              });
                            },
                            child: Text(
                              isLogin
                                  ? 'Create New Account'
                                  : 'I already have an account',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            )),
                    ],
                  ),
                ),
                if (!isLoading)
                  ElevatedButton(
                    onPressed: trySubmit,
                    child: Text(isLogin ? 'Login' : 'Sign Up'),
                  ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
