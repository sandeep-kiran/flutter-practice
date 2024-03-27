import 'dart:convert';

import 'package:first_app/users/dashboard/dashboard_screen.dart';
import 'package:first_app/users/utils/api_class.dart';
import 'package:first_app/users/widgets/loading_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/constants.dart';
import '../../widgets/scaffold_messanger.dart';
import '../apis/api_urls.dart';
import '../widgets/already_have_an_account.dart';
import '../login/login.dart';
import '../../source/model/user_data_model.dart';
import 'package:http/http.dart' as http;

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  RegistrationScreenState createState() => RegistrationScreenState();
}

class RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repeatPasswordController = TextEditingController();
  bool _confirmPasswordIsHidden = true;
  bool _repeatPasswordIsHidden = true;
  late SharedPreferences registrationForm;
  String? email;
  bool? newuser;
  late String password;
  late String repeatPassword;
  late UserData user;

  void _toggleConfirmPasswordView() {
    setState(() {
      _confirmPasswordIsHidden = !_confirmPasswordIsHidden;
    });
  }

  void _toggleRepeatPasswordView() {
    setState(() {
      _repeatPasswordIsHidden = !_repeatPasswordIsHidden;
    });
  }

  void redirectUserToDashboard() async {
    registrationForm = await SharedPreferences.getInstance();
    newuser = (registrationForm.getBool('login') ?? true);
    setState(() {});
    if (kDebugMode) {
      debugPrint("newUser = $newuser");
    }
    if (newuser == false) {
      Future.delayed(Duration.zero).then(
        (value) => {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const DashboardScreen(),
            ),
          )
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    redirectUserToDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Register Now',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Complete Your Details',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 30),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      emailFormField(),
                      const SizedBox(height: 30),
                      passwordFormField(),
                      const SizedBox(height: 30),
                      repeatPasswordFormField(),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text(
                          'Register',
                          style: TextStyle(fontSize: 18),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            // saveUser(printLog: true);
                            registerUser();
                          }
                        },
                      ),
                      const SizedBox(height: 30),
                      AlreadyHaveAnAccountCheck(
                        login: false,
                        press: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  registerUser() async {
    showLoadingDialog(context);
    ApiClient client = await ApiCall.post(
      apiUrl: signUpUrl,
      printLog: true,
      requiredToken: false,
      body: {
        "email": emailController.text,
        "password": passwordController.text,
      },
    );
    if (client.responseStatus == ApiResponseStatus.success) {
      String token = client.token ?? "";
      registrationForm = await SharedPreferences.getInstance();
      registrationForm.setString('token', token);
      saveUserLoggedInStatus();
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
          ModalRoute.withName('/'));
      Snackbar.showSnackBar(context, client.mesage);
    } else {
      if (!mounted) return;
      Navigator.pop(context);
      Snackbar.showSnackBar(context, client.mesage);
    }
  }

  saveUserLoggedInStatus() async {
    registrationForm = await SharedPreferences.getInstance();
    registrationForm.setBool('login', false).then(
        // ignore: avoid_print
        (value) =>
            debugPrint('Userdata Successfully Saved in Shared Preference'));
    setState(() {});
  }

  Future<void> saveUser({bool printLog = false}) async {
    final url = Uri.parse("$baseUrl$signUpUrl");

    var body = jsonEncode({
      "email": emailController.text,
      "password": passwordController.text,
    });

    var headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };

    if (printLog) {
      debugPrint("URL == $url");
      debugPrint("BODY == $body");
      debugPrint("HEADERS == $headers");
    }

    showLoadingDialog(context);

    try {
      var response = await http.post(url, headers: headers, body: body);
      if (printLog) {
        debugPrint("Status Code == ${response.statusCode}");
      }
      if (response.statusCode == 201) {
        String token = jsonDecode(response.body)["practice"]["token"];
        registrationForm = await SharedPreferences.getInstance();
        registrationForm.setString('token', token);
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const DashboardScreen()),
            ModalRoute.withName('/'));
        Snackbar.showSnackBar(
            context, jsonDecode(response.body)["practice"]["message"]);
      } else {
        if (!mounted) return;
        Navigator.pop(context);
        Snackbar.showSnackBar(
            context, jsonDecode(response.body)["practice"]["message"]);
      }
    } catch (e) {
      Navigator.pop(context);
      debugPrint("Error = $e");
    }
  }

  TextFormField emailFormField() {
    return TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value!.isEmpty && !errors.contains(emailNullError)) {
          return emailNullError;
        } else if (!emailValidatorRegExp.hasMatch(value) &&
            !errors.contains(invalidEmailError)) {
          return invalidEmailError;
        }
        return null;
      },
      decoration: const InputDecoration(
        hintText: "Enter your Email",
        labelText: "Email",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: Icon(Icons.email_outlined),
      ),
    );
  }

  TextFormField passwordFormField() {
    return TextFormField(
      controller: passwordController,
      obscureText: _confirmPasswordIsHidden,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value!.isEmpty && !errors.contains(passWordNullError)) {
          return passWordNullError;
        } else if (value.length < 8 && !errors.contains(shortPassError)) {
          return shortPassError;
        }
        return null;
      },
      keyboardType: TextInputType.text,
      onSaved: (newValue) => password = newValue!,
      decoration: InputDecoration(
        hintText: "Enter your password",
        labelText: "Password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: const Icon(Icons.password),
        suffixIcon: GestureDetector(
            onTap: _toggleConfirmPasswordView,
            child: const Icon(Icons.remove_red_eye_sharp)),
      ),
    );
  }

  TextFormField repeatPasswordFormField() {
    return TextFormField(
      controller: repeatPasswordController,
      obscureText: _repeatPasswordIsHidden,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value!.isEmpty && !errors.contains(passWordNullError)) {
          return passWordNullError;
        } else if (value.length < 8 && !errors.contains(shortPassError)) {
          return shortPassError;
        } else if (value != passwordController.text) {
          return "Password dont match";
        }
        return null;
      },
      keyboardType: TextInputType.text,
      onSaved: (newValue) => repeatPassword = newValue!,
      decoration: InputDecoration(
        hintText: "Retype the password",
        labelText: "Repeat Password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: const Icon(Icons.password),
        suffixIcon: GestureDetector(
            onTap: _toggleRepeatPasswordView,
            child: const Icon(Icons.remove_red_eye_sharp)),
      ),
    );
  }
}
