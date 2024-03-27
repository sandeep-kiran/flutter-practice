import 'package:flutter/material.dart';

class Snackbar {
  static SnackBar snackbar({required String text, bool isError = false}) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(
        text,
        style: const TextStyle(color: Colors.deepPurple),
      ),
      showCloseIcon: true,
      closeIconColor: Colors.deepPurple,
      backgroundColor: Colors.purple.shade50,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    );
  }

  static showSnackBar(BuildContext context, text) {
    ScaffoldMessenger.of(context).showSnackBar(snackbar(text: text));
  }

  static hideSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
  }
}
