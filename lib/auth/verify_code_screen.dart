import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_flutter_int/ui/posts/post_screen.dart';
import 'package:firebase_flutter_int/ui/utilities/utils.dart';
import 'package:firebase_flutter_int/widgets/custom_btn.dart';
import 'package:flutter/material.dart';

import '../widgets/custom_textForm.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String verification;
  const VerifyCodeScreen({Key? key, required this.verification})
      : super(key: key);

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  bool loading = false;
  final TextEditingController _verificationCodeController =
      TextEditingController();
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Verify phone number"),
      ),
      body: Column(
        children: [
          CustomTextFormField(
              controller: _verificationCodeController,
              hintText: "6 digit code",
              icon: Icon(Icons.phone),
              keyboardType: TextInputType.number),
          Custom_btn(
            loading: loading,
            btn_title: "Verify",
            onTap: () async {
              setState(() {
                loading = true;
              });
              final credentials = PhoneAuthProvider.credential(
                  verificationId: widget.verification,
                  smsCode: _verificationCodeController.text.toString());
              try {
                await _auth.signInWithCredential(credentials);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Post_Screen(),
                    ));
              } catch (e) {
                setState(() {
                  loading = false;
                });
                Utils().toastMessage(e.toString());
                print(e);
              }
            },
          )
        ],
      ),
    );
  }
}
