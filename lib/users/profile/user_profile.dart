import 'dart:convert';
import 'package:first_app/users/authentication/apis/api_urls.dart';
import 'package:first_app/users/source/model/user_data_model.dart';
import 'package:first_app/users/source/model/gender_model.dart';
import 'package:first_app/users/utils/api_class.dart';
import 'package:first_app/users/utils/constants.dart';
import 'package:first_app/users/widgets/loading_dialog.dart';
import 'package:first_app/users/widgets/scaffold_messanger.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'apis/api_urls.dart';
import 'package:http/http.dart' as http;

class UserProfileScreen extends StatefulWidget {
  final UserData user;
  const UserProfileScreen({super.key, required this.user});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  String? name;
  String? phoneNumber;
  GenderModel? genderValue;
  List<GenderModel> genderList = [];
  ImagePicker imagePicker = ImagePicker();
  String profilePhoto = "";
  String email = "";

  @override
  void initState() {
    getGenderList();
    getUserData();
    super.initState();
  }

  getUserData() async {
    ApiClient client = await ApiCall.patch(
      apiUrl: getUserUrl,
      printLog: false,
      body: {
        "email": widget.user.email,
      },
    );
    if (client.responseStatus == ApiResponseStatus.success) {
      UserData user = UserData.fromJson(client.data["data"]);
      email = user.email;
      nameController.text = user.name;
      phoneNumberController.text = user.phone;
      dobController.text = user.dob;
      profilePhoto = user.photo;
      genderValue =
          genderList.where((element) => element.gender == user.gender).first;
    } else {
      debugPrint("Message == ${client.mesage}");
    }
  }

  Future<List<GenderModel>> getGenderList() async {
    ApiClient client = await ApiCall.get(
      apiUrl: getGenderUrl,
      printLog: false,
    );
    if (client.responseStatus == ApiResponseStatus.success) {
      for (var data in client.data["data"]) {
        GenderModel gender = GenderModel.fromJson(data);
        genderList.add(gender);
      }
      setState(() {});
      return genderList;
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Stack(
                children: [
                  Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100)),
                    child: SizedBox(
                        height: 150,
                        width: 150,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.network(
                            imageUrl + profilePhoto,
                            fit: BoxFit.cover,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else if (loadingProgress.expectedTotalBytes !=
                                  null) {
                                return const CircularProgressIndicator();
                              } else {
                                return const SizedBox();
                              }
                            },
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace? stackTrace) {
                              return Center(
                                child: Text(
                                  name?[0] ?? email[0],
                                  style: const TextStyle(
                                      fontSize: 80,
                                      fontWeight: FontWeight.bold),
                                ),
                              );
                            },
                          ),
                        )),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: () {
                        openModelPopUp();
                      },
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Icon(Icons.edit),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 15),
              nameFormField(),
              const SizedBox(height: 15),
              phoneNumberFormField(),
              const SizedBox(height: 15),
              dobFormField(),
              const SizedBox(height: 15),
              genderFormField(),
              const SizedBox(height: 15),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  saveUserDetails();
                },
                child: const Text(
                  "Update Profile",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  saveUserDetails() async {
    showLoadingDialog(context);
    ApiClient client = await ApiCall.put(
      apiUrl: updateUserUrl,
      printLog: true,
      body: {
        "email": widget.user.email,
        "phoneNumber": phoneNumberController.text,
        "dob": dobController.text,
        "genderId": genderValue?.id,
        "name": nameController.text,
      },
    );
    if (client.responseStatus == ApiResponseStatus.success) {
      setState(() {});
      if (!mounted) return;
      Navigator.pop(context);
      Snackbar.showSnackBar(context, client.mesage);
    } else {
      if (!mounted) return;
      Navigator.pop(context);
      Snackbar.showSnackBar(context, client.mesage);
    }
  }

  TextFormField nameFormField() {
    return TextFormField(
      controller: nameController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: TextInputType.text,
      onSaved: (newValue) => name = newValue,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        hintText: "Enter Your Full Name",
        labelText: "Full Name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: Icon(Icons.person),
      ),
    );
  }

  TextFormField phoneNumberFormField() {
    return TextFormField(
      controller: phoneNumberController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      onSaved: (newValue) => phoneNumber = newValue,
      decoration: const InputDecoration(
        hintText: "Enter Your Phone Number",
        labelText: "Phone Number",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: Icon(Icons.person),
      ),
    );
  }

  TextFormField dobFormField() {
    return TextFormField(
      controller: dobController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: TextInputType.datetime,
      textInputAction: TextInputAction.done,
      onSaved: (newValue) => name = newValue,
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1947),
          lastDate: DateTime.now().add(const Duration(days: 30)),
        );
        if (picked != null) {
          dobController.text = "${picked.day}/${picked.month}/${picked.year}";
        }
      },
      decoration: const InputDecoration(
        hintText: "Enter Your DOB",
        labelText: "DOB",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: Icon(Icons.calendar_month),
      ),
    );
  }

  DropdownButtonFormField genderFormField() {
    return DropdownButtonFormField<GenderModel>(
      value: genderValue,
      items: genderList.map<DropdownMenuItem<GenderModel>>((GenderModel value) {
        return DropdownMenuItem<GenderModel>(
          value: value,
          child: Text(value.gender),
        );
      }).toList(),
      onChanged: (GenderModel? value) {
        setState(() {
          genderValue = value!;
        });
      },
      decoration: const InputDecoration(
        hintText: "Select Gender",
        labelText: "Gender",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: Icon(Icons.person_2),
      ),
    );
  }

  openModelPopUp() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          width: double.infinity,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(15),
              topLeft: Radius.circular(15),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Choose from Below!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    elevation: 5,
                    child: IconButton(
                      onPressed: () {
                        addProfilePicture(imageSource: ImageSource.camera);
                      },
                      icon: const Icon(Icons.camera_alt),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Card(
                    elevation: 10,
                    child: IconButton(
                      onPressed: () {
                        addProfilePicture(imageSource: ImageSource.gallery);
                      },
                      icon: const Icon(Icons.photo_library),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white),
                child: const Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  addProfilePicture({required ImageSource imageSource}) async {
    XFile? image = await imagePicker.pickImage(source: imageSource);
    if (image != null) {
      updateUserProfile(imagePath: image.path, printLog: true);
    } else {
      return;
    }
  }

  Future<void> updateUserProfile(
      {bool printLog = false, required String imagePath}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String bearerToken = sharedPreferences.getString('token') ?? "";
    final url = Uri.parse("$baseUrl$userProfilePicUrl");

    Map<String, String> body = {
      "email": widget.user.email,
      "profileUrl": imagePath,
    };

    var headers = {
      'Content-type': 'application/json',
      'Authorization': "Bearer $bearerToken"
    };

    if (printLog) {
      debugPrint("URL == $url");
      debugPrint("BODY == $body");
      debugPrint("HEADERS == $headers");
    }

    if (!mounted) return;
    Navigator.pop(context);
    showLoadingDialog(context);

    try {
      http.MultipartRequest response = http.MultipartRequest("PATCH", url);
      response.fields.addAll(body);
      response.files
          .add(await http.MultipartFile.fromPath("profileUrl", imagePath));
      response.headers.addAll(headers);
      http.StreamedResponse res =
          await response.send().timeout(const Duration(seconds: 15));
      http.Response httpResponse = await http.Response.fromStream(res);
      if (printLog) {
        debugPrint("Status Code == ${httpResponse.statusCode}");
      }
      if (httpResponse.statusCode == 200) {
        if (!mounted) return;
        Navigator.pop(context);
        Snackbar.showSnackBar(
            context, jsonDecode(httpResponse.body)["practice"]["message"]);
      } else {
        if (!mounted) return;
        Navigator.pop(context);
        Snackbar.showSnackBar(
            context, jsonDecode(httpResponse.body)["practice"]["message"]);
      }
    } catch (e) {
      Navigator.pop(context);
      debugPrint("Error = $e");
    }
  }
}
