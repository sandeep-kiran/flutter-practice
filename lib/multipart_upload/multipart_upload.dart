import 'package:flutter/material.dart';

import 'pick_files.dart';

class MultipartUploadHome extends StatelessWidget {
  const MultipartUploadHome({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Multipart Upload',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PickFiles(),
    );
  }
}
