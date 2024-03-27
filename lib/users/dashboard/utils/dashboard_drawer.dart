import 'package:first_app/users/source/model/user_data_model.dart';
import 'package:first_app/users/profile/user_profile.dart';
import 'package:first_app/users/utils/constants.dart';
import 'package:flutter/material.dart';
import '../dashboard_screen.dart';
import '../widgets/drawer_tile.dart';

class DashboardDrawer extends StatelessWidget {
  final VoidCallback logout;
  final UserData user;
  const DashboardDrawer({super.key, required this.logout, required this.user});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.deepPurple.shade100),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  imageUrl + user.photo,
                  fit: BoxFit.cover,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else if (loadingProgress.expectedTotalBytes != null) {
                      return const CircularProgressIndicator();
                    } else {
                      return const SizedBox();
                    }
                  },
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    return Center(
                      child: Text(
                        user.name.isEmpty ? user.email[0] : user.name[0],
                        style: const TextStyle(
                            fontSize: 80, fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              user.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              user.email,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            DrawerTile(
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DashboardScreen()));
              },
              iconData: Icons.home,
              text: "Home",
            ),
            const SizedBox(height: 10),
            DrawerTile(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserProfileScreen(user: user)));
              },
              iconData: Icons.person,
              text: "Update Profile",
            ),
            const SizedBox(height: 10),
            DrawerTile(
              defaultColor: Colors.red,
              onTap: logout,
              iconData: Icons.logout,
              text: "Logout",
            ),
          ],
        ),
      ),
    );
  }
}
