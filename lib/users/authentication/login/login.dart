import 'package:first_app/users/authentication/apis/api_urls.dart';
import 'package:first_app/users/source/model/user_data_model.dart';
import 'package:first_app/users/authentication/signup/registration.dart';
import 'package:first_app/users/dashboard/dashboard_screen.dart';
import 'package:first_app/users/utils/api_class.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/constants.dart';
import '../../widgets/loading_dialog.dart';
import '../../widgets/scaffold_messanger.dart';
import '../widgets/already_have_an_account.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
  });

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final List<String> errors = [];
  String? email;
  String? password;
  bool _confirmPasswordIsHidden = true;
  late SharedPreferences registrationForm;

  void _toggleConfirmPasswordView() {
    setState(() {
      _confirmPasswordIsHidden = !_confirmPasswordIsHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Login Now',
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
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(fontSize: 18),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            loginUser();
                          }
                        },
                      ),
                      const SizedBox(height: 30),
                      AlreadyHaveAnAccountCheck(
                        login: true,
                        press: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const RegistrationScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  loginUser() async {
    showLoadingDialog(context);
    ApiClient client = await ApiCall.post(
      apiUrl: loginUrl,
      printLog: false,
      requiredToken: false,
      body: {
        "email": emailController.text,
        "password": passwordController.text,
      },
    );
    if (client.responseStatus == ApiResponseStatus.success) {
      UserData user = UserData.fromJson(client.data["data"]);
      saveUserLoggedInStatus();
      UserData.saveUserData(user);
      String token = client.token ?? "";
      debugPrint(token);
      registrationForm = await SharedPreferences.getInstance();
      registrationForm.setString('token', token);
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
        hintText: "Enter Your Email",
        labelText: "User Id",
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
      onSaved: (newValue) => password = newValue,
      decoration: InputDecoration(
        hintText: "Enter Your Password",
        labelText: "Password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: const Icon(Icons.password),
        suffixIcon: GestureDetector(
            onTap: _toggleConfirmPasswordView,
            child: const Icon(Icons.remove_red_eye_sharp)),
      ),
    );
  }
}
