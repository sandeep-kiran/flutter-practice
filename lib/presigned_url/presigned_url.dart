import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PresignedURL extends StatefulWidget {
  const PresignedURL({super.key});

  @override
  State<PresignedURL> createState() => _PresignedURLState();
}

class _PresignedURLState extends State<PresignedURL> {
  PlatformFile? _paths;
  String _uploadStatus = '';
  String _fileName = '';
  String _fileType = '';
  File? _file;

  final String presignedUrlApi =
      'https://alpjv6pg27.execute-api.eu-west-2.amazonaws.com/api/v1/profile/practice/generate-presigned-url';

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      compressionQuality: 30,
      type: FileType.any,
      allowMultiple: false, // Single file selection
    );

    if (result != null && result.files.isNotEmpty) {
      final pickedFile = result.files.single;

      _file = File(pickedFile.path!);

      setState(() {
        _paths = pickedFile;
        _fileName = pickedFile.name;
        _fileType = pickedFile.extension ??
            'png'; // Default to 'png' if extension is null
      });

      debugPrint("File Name === $_fileName");
      debugPrint("File Type === $_fileType");
    } else {
      // Handle the case where no file is selected or file picker is canceled
      setState(() {
        _paths = null;
        _fileName = '';
        _fileType = 'png';
      });
    }
  }

  Future<void> _uploadFile() async {
    try {
      // Request presigned URL
      final response = await http.get(
        Uri.parse('$presignedUrlApi?fileName=$_fileName&fileType=$_fileType'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      setState(() {
        _uploadStatus = 'Generating presigned URL...';
      });

      debugPrint("StatusCode === ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = response.body;
        final Map<String, dynamic> jsonResponse = jsonDecode(data);

        debugPrint("Presigned URL === ${jsonResponse["url"]}");
        final presignedUrl = jsonResponse['url'];

        if (presignedUrl != null) {
          // Upload file to S3
          final uploadResponse = await http.put(
            Uri.parse(presignedUrl),
            headers: {
              'Content-Type': _fileType, // Set correct MIME type
            },
            body: await _file?.readAsBytes(),
          );

          debugPrint("Upload Status Code === ${uploadResponse.statusCode}");

          if (uploadResponse.statusCode == 200) {
            setState(() {
              _uploadStatus = 'Upload successful!';
            });
          } else {
            setState(() {
              _uploadStatus = 'Upload failed.';
            });
          }
        } else {
          setState(() {
            _uploadStatus = 'Failed to get presigned URL.';
          });
        }
      } else {
        setState(() {
          _uploadStatus = 'Failed to get presigned URL.';
        });
      }
    } catch (e) {
      debugPrint('Error uploading file: $e');
      setState(() {
        _uploadStatus = 'Error occurred during upload.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Upload File to S3'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _pickFile,
                child: const Text('Pick File'),
              ),
              if (_fileName.isNotEmpty) ...[
                Text('Selected file: $_fileName'),
                ElevatedButton(
                  onPressed: _uploadFile,
                  child: const Text('Upload File'),
                ),
              ],
              const SizedBox(height: 20),
              Text(_uploadStatus),
            ],
          ),
        ),
      ),
    );
  }
}
