import 'package:flutter/material.dart';

showLoadingDialog(BuildContext context) {
  showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) => const Dialog(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(),
            ),
            SizedBox(height: 10),
            Text("Loading! Please wait!!!"),
          ],
        ),
      ),
    ),
  );
}
