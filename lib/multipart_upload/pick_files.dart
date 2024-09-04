import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'widgets/snackbar.dart';

class PickFiles extends StatefulWidget {
  const PickFiles({super.key});

  @override
  State<PickFiles> createState() => _PickFilesState();
}

class _PickFilesState extends State<PickFiles> {
  ImagePicker imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pick Images")),
      body: Card(
        elevation: 5,
        child: IconButton(
          onPressed: () {
            addProfilePicture(imageSource: ImageSource.camera);
          },
          icon: const Icon(Icons.camera_alt),
        ),
      ),
    );
  }

  addProfilePicture({required ImageSource imageSource}) async {
    XFile? image = await imagePicker.pickImage(source: imageSource);
    if (image != null) {
      updateUserProfile(
        profilePath: image.path,
        documentPath: image.path,
        printLog: true,
      );
    } else {
      return;
    }
  }

  Future<void> updateUserProfile({
    bool printLog = false,
    required String profilePath,
    required String documentPath,
  }) async {
    final url = Uri.parse(
        "http://172.16.116.93:5000/api/v1/profile/doctor/upload-doctor-profile-image");

    Map<String, String> body = {
      "email": "admindentist@gmail.com",
      "profileUrl": profilePath
    };

    var headers = {
      'Content-type': 'application/json',
    };

    if (printLog) {
      debugPrint("URL == $url");
      debugPrint("BODY == $body");
      debugPrint("HEADERS == $headers");
    }

    // if (!mounted) return;

    try {
      http.MultipartRequest response = http.MultipartRequest("PATCH", url);
      response.fields.addAll(body);
      response.files
          .add(await http.MultipartFile.fromPath("profileUrl", profilePath));
      response.headers.addAll(headers);
      http.StreamedResponse res =
          await response.send().timeout(const Duration(seconds: 15));
      http.Response httpResponse = await http.Response.fromStream(res);
      if (printLog) {
        debugPrint("Status Code == ${httpResponse.statusCode}");
      }
      if (httpResponse.statusCode == 200) {
        if (!mounted) return;
        // Navigator.pop(context);
        Snackbar.showSnackBar(
            context, jsonDecode(httpResponse.body)["practice"]["message"]);
      } else {
        if (!mounted) return;
        // Navigator.pop(context);
        Snackbar.showSnackBar(
            context, jsonDecode(httpResponse.body)["practice"]["message"]);
      }
    } catch (e) {
      // Navigator.pop(context);
      debugPrint("Error = $e");
    }
  }
}
