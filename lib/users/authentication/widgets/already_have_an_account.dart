import 'package:flutter/material.dart';

class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final bool login;
  final VoidCallback press;
  const AlreadyHaveAnAccountCheck({
    super.key,
    this.login = true,
    required this.press,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          login ? "Don't have a Account ? " : 'Already Have an Account ? ',
          style: const TextStyle(
            color: Colors.purple,
            fontSize: 16,
          ),
        ),
        GestureDetector(
          onTap: press,
          child: Text(
            login ? "Register" : "Sign in",
            style: const TextStyle(
              color: Colors.deepPurple,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        )
      ],
    );
  }
}
