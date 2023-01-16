// import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_flutter_int/auth/signup_screen.dart';
import 'package:firebase_flutter_int/auth/verify_code_screen.dart';
import 'package:firebase_flutter_int/constants/global_variables.dart';
import 'package:firebase_flutter_int/ui/posts/post_screen.dart';
import 'package:firebase_flutter_int/widgets/custom_btn.dart';
import 'package:firebase_flutter_int/widgets/custom_textForm.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../ui/utilities/utils.dart';

enum Auth_method { email, phone }

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Auth_method _auth_method = Auth_method.email;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  final _signupFormKey = GlobalKey<FormState>();
  final _phoneFormKey = GlobalKey<FormState>();
  bool loading = false;
  final _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _emailController.dispose();
    _passwordController.dispose();
    _phoneNumberController.dispose();
  }

  void login() {
    setState(() {
      loading = true;
    });
    _auth
        .signInWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text)
        .then((value) {
      Utils().toastMessage(value.user!.email.toString());

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Post_Screen(),
          ));
      setState(() {
        loading = false;
      });
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      Utils().toastMessage(error.toString());
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // backgroundColor: Colors.orange[400],
        title: Center(
          child: Text(
            "Welcome",
            style: TextStyle(
                fontSize: 22,
                // color: Colors.white,
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              ListTile(
                tileColor: _auth_method == Auth_method.email
                    ? Colors.orange[200]
                    :Colors.blueGrey[50],
                title: Text("Login with email"),
                leading: Radio(
                  activeColor: GlobalVariables.secondaryColor,
                  value: Auth_method.email,
                  groupValue: _auth_method,
                  onChanged: (Auth_method? value) {
                    setState(() {
                      _auth_method = value!;
                    });
                  },
                ),
              ),
              if (_auth_method == Auth_method.email)
                Container(
                  child: Form(
                    key: _signupFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomTextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          hintText: 'Enter email',
                          icon: Icon(Icons.email_outlined),
                        ),
                        CustomTextFormField(
                          controller: _passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          hintText: 'Enter password',
                          icon: Icon(Icons.lock_outline),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Custom_btn(
                          loading: loading,
                          btn_title: "Login",
                          onTap: () {
                            if (_signupFormKey.currentState!.validate()) {
                              login();
                            }
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account ?",
                              style: TextStyle(fontSize: 16),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignUp_Screen(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Sign Up",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              SizedBox(
                height: 15,
              ),
              ListTile(
                tileColor: _auth_method == Auth_method.phone
                    ? Colors.orange[200]
                    :Colors.blueGrey[50],
                title: Text("Login with phone"),
                leading: Radio(
                  activeColor: GlobalVariables.secondaryColor,
                  value: Auth_method.phone,
                  groupValue: _auth_method,
                  onChanged: (Auth_method? value) {
                    setState(() {
                      _auth_method = value!;
                    });
                  },
                ),
              ),
              if (_auth_method == Auth_method.phone)
                Container(
                  child: Form(
                    key: _phoneFormKey,
                    child: Column(
                      children: [
                        CustomTextFormField(
                            controller: _phoneNumberController,
                            hintText: "Phone number",
                            icon: Icon(Icons.phone),
                            keyboardType: TextInputType.number),
                        Custom_btn(
                          loading: loading,
                          btn_title: "Login",
                          onTap: () {
                            if (_phoneFormKey.currentState!.validate()) {
                              _auth.verifyPhoneNumber(
                                phoneNumber: "+91" + _phoneNumberController.text,
                                verificationCompleted: (phoneAuthCredential) {},
                                verificationFailed: (error) {
                                  Utils().toastMessage(error.toString());
                                },
                                codeSent: (String verificationId, int? token) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => VerifyCodeScreen(
                                          verification: verificationId,
                                        ),
                                      ));
                                },
                                codeAutoRetrievalTimeout: (error) {
                                  Utils().toastMessage(error.toString());
                                },
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
