import 'package:firebase_flutter_int/firebase_services/splash_services.dart';
import 'package:flutter/material.dart';

class Splash_screen extends StatefulWidget {
  const Splash_screen({Key? key}) : super(key: key);

  @override
  State<Splash_screen> createState() => _Splash_screenState();
}

class _Splash_screenState extends State<Splash_screen> {

  Splash_Services splash_services = Splash_Services();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
splash_services.isLogin(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset("assets/images/splash2.png",)
      ),
    );
  }
}
