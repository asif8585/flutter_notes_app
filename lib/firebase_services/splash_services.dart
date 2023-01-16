import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_flutter_int/auth/login_screen.dart';
import 'package:firebase_flutter_int/auth/signup_screen.dart';
import 'package:firebase_flutter_int/ui/posts/add_postScreen.dart';
import 'package:firebase_flutter_int/ui/posts/post_screen.dart';
import 'package:flutter/material.dart';

class Splash_Services {
  void isLogin(BuildContext context) {

    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    if(user != null){
      Timer(

        Duration(seconds: 3),

            () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>Post_Screen(),
          ),
        ),

      );
    }else {
      Timer(
        Duration(seconds: 3),
            () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>LoginScreen(),
          ),
        ),
      );
    }

  }
}
