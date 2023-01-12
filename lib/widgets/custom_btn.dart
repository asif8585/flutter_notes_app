import 'package:firebase_flutter_int/constants/global_variables.dart';
import 'package:flutter/material.dart';

class Custom_btn extends StatelessWidget {
  final bool loading;
  final String btn_title;
  final VoidCallback onTap;
  const Custom_btn(
      {Key? key,
      required this.btn_title,
      required this.onTap,
      this.loading = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: onTap,
          child: loading
              ? CircularProgressIndicator(color: Colors.white,strokeWidth: 3,)
              : Text(
                  btn_title,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
          style: ElevatedButton.styleFrom(
            backgroundColor: GlobalVariables.secondaryColor,
            minimumSize: Size(double.infinity, 40),
          ),
        ),
      ),
    );
  }
}
