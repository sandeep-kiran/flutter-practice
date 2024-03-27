import 'package:first_app/users/source/model/user_data_model.dart';
import 'package:first_app/users/utils/constants.dart';
import 'package:flutter/material.dart';

class UserProfileWidget extends StatelessWidget {
  final UserData user;
  const UserProfileWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 5),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.deepPurple),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 50,
            width: 50,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.deepPurple.shade100),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
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
                      user.name[0],
                      style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 3),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Text(
                user.email,
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
              Text(
                "${user.dob} ${user.gender.isNotEmpty ? ({user.gender}) : ""}",
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
