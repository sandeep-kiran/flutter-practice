import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  final VoidCallback onTap;
  final IconData iconData;
  final String text;
  final Color defaultColor;
  const DrawerTile({
    super.key,
    required this.onTap,
    required this.iconData,
    required this.text,
    this.defaultColor = Colors.deepPurple,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: defaultColor),
      ),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: defaultColor,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Icon(
          iconData,
          color: Colors.white,
        ),
      ),
      title: Text(
        text,
        style: TextStyle(color: defaultColor),
      ),
    );
  }
}
