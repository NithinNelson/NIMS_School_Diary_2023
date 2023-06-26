// import 'package:flutter/cupertino.dart';
 import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String msg, Color clr) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg),
      backgroundColor: clr,
    ),
  );
}
