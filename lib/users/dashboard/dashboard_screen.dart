import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:first_app/users/authentication/login/login.dart';
import 'package:first_app/users/source/model/user_data_model.dart';
import 'package:first_app/users/dashboard/utils/dashboard_drawer.dart';
import 'package:first_app/users/profile/apis/api_urls.dart';
import 'package:first_app/users/profile/user_profile.dart';
import 'package:first_app/users/utils/api_class.dart';
import 'package:first_app/users/utils/user_utils.dart';
import 'package:first_app/users/widgets/scaffold_messanger.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../authentication/apis/api_urls.dart';
import '../utils/constants.dart';
import 'widgets/carousel_widget.dart';
import 'widgets/user_profile.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({
    super.key,
  });

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  List<UserData> userList = [];
  late UserData user;

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const DashboardScreen()));
      case 1:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UserProfileScreen(user: user)));
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  void logoutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Future.delayed(Duration.zero).then(
      (value) => Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
        ModalRoute.withName('/'),
      ),
    );
  }

  getUserEmail() async {
    return UserClass.getTheValue('_email');
  }

  getCurrentUser() async {
    debugPrint("User Email == ${await UserClass.getTheValue('_email') ?? ""}");
    ApiClient client = await ApiCall.patch(
      apiUrl: getUserUrl,
      printLog: false,
      body: {
        "email": await UserClass.getTheValue('_email') ?? "",
      },
    );
    if (client.responseStatus == ApiResponseStatus.success) {
      user = UserData.fromJson(client.data["data"]);
      setState(() {});
    } else {
      debugPrint("Message == ${client.mesage}");
    }
  }

  getAllUsers() async {
    ApiClient client = await ApiCall.get(
      apiUrl: getAllUsersUrl,
      printLog: true,
    );
    if (client.responseStatus == ApiResponseStatus.success) {
      List responseList = client.data["data"];
      userList = responseList.map((e) => UserData.fromJson(e)).toList();
      setState(() {});
    } else {
      if (!mounted) return;
      Snackbar.showSnackBar(context, jsonDecode(client.mesage));
    }
  }

  @override
  void initState() {
    getCurrentUser();
    getAllUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard Screen"), actions: [
        IconButton(
          icon: const Icon(
            Icons.logout,
          ),
          onPressed: () {
            logoutUser();
          },
        ),
      ]),
      drawer: DashboardDrawer(
        logout: logoutUser,
        user: user,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Upcoming Events",
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w500, height: 2),
            ),
            const SizedBox(height: 10),
            CarouselSlider.builder(
              itemCount: urls.length,
              itemBuilder: (ctx, index, realIdx) {
                return CarouselWidget(url: urls[index]);
              },
              options: CarouselOptions(
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 1,
                aspectRatio: 2.0,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Registered Users",
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w500, height: 2),
            ),
            const SizedBox(height: 10),
            Flexible(
              child: SizedBox(
                height: 75,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: userList.length,
                  itemBuilder: (context, index) {
                    return UserProfileWidget(user: userList[index]);
                  },
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.edit), label: "Update Profile")
        ],
      ),
    );
  }
}
