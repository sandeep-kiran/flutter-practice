import 'package:flutter/material.dart';

class CarouselWidget extends StatelessWidget {
  final String url;
  const CarouselWidget({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          fit: BoxFit.cover,
          onError: (exception, stackTrace) {
            const AssetImage("assets/images/no_data.png");
          },
          image: NetworkImage(url),
        ),
      ),
    );
  }
}
