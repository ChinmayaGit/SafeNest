import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parental_controll_app/children.dart';
import 'package:parental_controll_app/myhome_page.dart';
import 'package:parental_controll_app/parent.dart';
import 'package:parental_controll_app/parent_display.dart';

import 'signin.dart';

class SignUp extends StatefulWidget {
  final String title;
  final bool isParent;

  const SignUp({super.key, required this.title, required this.isParent});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _parentCodeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool isSignup = true;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _parentCodeController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
  }

  String generateRandomCode() {
    const String alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
    const int codeLength = 6;
    final Random random = Random();
    String code = '';

    for (int i = 0; i < codeLength; i++) {
      final int randomIndex = random.nextInt(alphabet.length);
      code += alphabet[randomIndex];
    }
    return code;
  }

  Future<String> checkParentCode(String parentCode) async {
    return await FirebaseFirestore.instance
        .collection('Parents')
        .where('parentCode', isEqualTo: parentCode)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        return value.docs[0]['userId'];
      }
      return value.docs[0]['userId'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.title} SignUp')),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!widget.isParent)
              Container(
                width: MediaQuery.of(context).size.width * 0.75,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(width: 1, color: Colors.grey),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: TextField(
                    controller: _parentCodeController,
                    decoration: const InputDecoration(
                      hintText: 'Enter Parent Code',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            if (!widget.isParent)
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),

            if (!widget.isParent)
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
                child: const Center(child: Text('')),
              ),
            if (!widget.isParent)
              Container(
                width: MediaQuery.of(context).size.width * 0.75,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      15,
                    ),
                    border: Border.all(
                      width: 1,
                      color: Colors.black,
                    )),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      hintText: 'Enter Name',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),

            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
              child: const Center(child: Text('')),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.75,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(width: 1, color: Colors.grey),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: 'Enter name',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Container(
              width: MediaQuery.of(context).size.width * 0.75,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(width: 1, color: Colors.grey),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    hintText: 'Enter email',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Container(
              width: MediaQuery.of(context).size.width * 0.75,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(width: 1, color: Colors.grey),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    hintText: 'Enter password',
                    border: InputBorder.none,
                  ),
                  obscureText: true,
                ),
              ),
            ),
            if (!isSignup)
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: const Text(
                  'User does not exist, please signup',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            // SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            // SizedBox(
            //   width: MediaQuery.of(context).size.width * 0.5,
            //   child: TextButton(
            //     style: TextButton.styleFrom(
            //       backgroundColor: Colors.green,
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(25),
            //       ),
            //     ),
            //     onPressed: () async {
            //       try {
            //         if (_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
            //           UserCredential credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            //             email: _emailController.text,
            //             password: _passwordController.text,
            //           );
            //
            //           if (credential.user != null) {
            //             print('USER CREDENTIAL');
            //             Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            //               return widget.isParent
            //                   ? ParentDisplay(
            //                 isParent: widget.isParent,
            //               )
            //                   : MyHomePage(
            //                 title: 'Screen Control', //bool isParent =widget.title == 'Parent' ? true : false
            //                 isParent: widget.isParent,
            //               );
            //             }));
            //           } else {
            //             setState(() {
            //               isSignup = !isSignup;
            //             });
            //           }
            //         }
            //       } catch (e) {
            //         print(e);
            //         setState(() {
            //           isSignup = !isSignup;
            //         });
            //       }
            //     },
            //     child: const Text(
            //       'Signin',
            //       style: TextStyle(color: Colors.white, fontSize: 18),
            //     ),
            //   ),
            // ),
            // SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onPressed: () async {
                  try {
                    if (widget.isParent &&
                        _emailController.text.isNotEmpty &&
                        _passwordController.text.isNotEmpty) {
                      UserCredential credential = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                        email: widget.isParent==true?"0${_emailController.text}":"1${_emailController.text}",
                        password: _passwordController.text,
                      );
                      print(credential.user);

                      if (credential.user != null) {
                        _emailController.clear();
                        _passwordController.clear();
                        _parentCodeController.clear();

                        setState(() {
                          _emailController.text = '';
                          _passwordController.text = '';
                        });

                        Parent parent = Parent(
                          credential.user!.uid,
                          _nameController.text,
                          '',
                          '',
                          '',
                          '',
                          [],
                          generateRandomCode(),
                        );
                        await FirebaseFirestore.instance
                            .collection('Parents')
                            .doc(credential.user!.uid.isNotEmpty
                                ? credential.user!.uid
                                : null)
                            .set(parent.toJSON());
                      }
                    } else {
                      String parentId =
                          await checkParentCode(_parentCodeController.text);
                      print('PARENT ID OF PARENT CODE $parentId');
                      if (parentId.isNotEmpty) {
                        UserCredential credential = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                          email: widget.isParent==true?"0${_emailController.text}":"1${_emailController.text}",
                          password: _passwordController.text,
                        );
                        Children children = Children(
                          credential.user!.uid,
                          _nameController.text,
                          '',
                          '',
                          '',
                          '',
                          '',
                          [],
                          _parentCodeController.text,
                          parentId,
                        );
                        await FirebaseFirestore.instance
                            .collection('Children')
                            .doc(credential.user!.uid.isNotEmpty
                                ? credential.user!.uid
                                : null)
                            .set(children.toJSON());
                        // await FirebaseFirestore.instance
                        //     .collection("Parents")
                        //     .doc(credential.user!.uid.isNotEmpty
                        //         ? credential.user!.uid
                        //         : null)
                        //     .update({
                        //   "name": _nameController.text,
                        // });
                      }
                    }
                    setState(() {
                      _parentCodeController.clear();
                      _nameController.clear();
                      _emailController.clear();
                      _passwordController.clear();
                    });
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute<Object>(
                        builder: (BuildContext context) => SignIn(
                          title: widget.title,
                          isParent: widget.isParent,
                        ),
                      ),
                    );
                  } catch (e) {
                    print(e);
                    setState(() {
                      isSignup = !isSignup;
                    });
                  }
                },
                child: const Text(
                  'Signup',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute<Object>(
                          builder: (BuildContext context) => SignIn(
                            title: widget.title,
                            isParent: widget.isParent,
                          ),
                        ),
                      );
                    },
                    child:const Text(
                      "SignIn",
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
