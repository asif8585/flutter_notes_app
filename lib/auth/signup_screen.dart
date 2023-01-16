import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_flutter_int/auth/login_screen.dart';
import 'package:firebase_flutter_int/constants/global_variables.dart';
import 'package:firebase_flutter_int/ui/utilities/utils.dart';
import 'package:firebase_flutter_int/widgets/custom_btn.dart';
import 'package:firebase_flutter_int/widgets/custom_textForm.dart';
import 'package:flutter/material.dart';

class SignUp_Screen extends StatefulWidget {
  const SignUp_Screen({Key? key}) : super(key: key);

  @override
  State<SignUp_Screen> createState() => _SignUp_ScreenState();
}

class _SignUp_ScreenState extends State<SignUp_Screen> {
  bool loading = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _signupFormKey = GlobalKey<FormState>();

  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void signUp() {
    setState(() {
      loading = true;
    });
    _auth
        .createUserWithEmailAndPassword(
            email: _emailController.text.toString(),
            password: _passwordController.text.toString())
        .then((value) {
      setState(() {
        loading = false;
             });
    }).onError((error, stackTrace) {
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
        // backgroundColor: GlobalVariables.secondaryColor,
        title: Center(
          child: Text(
            "Sign Up",
            style: TextStyle(
                fontSize: 22, color: Colors.white, fontWeight: FontWeight.w800),
          ),
        ),
      ),
      body: Form(
        key: _signupFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 35,
            ),
            CustomTextFormField(
              controller: _nameController,
              keyboardType: TextInputType.emailAddress,
              hintText: 'Enter name',
              icon: Icon(Icons.person_outline),
            ),
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
            SizedBox(
              height: 10,
            ),
            Custom_btn(
              btn_title: "Sign Up",
              loading: loading,
              onTap: () {
                if (_signupFormKey.currentState!.validate()) {
                  signUp();
                }

                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(),));

              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account ?",
                  style: TextStyle(fontSize: 16),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
