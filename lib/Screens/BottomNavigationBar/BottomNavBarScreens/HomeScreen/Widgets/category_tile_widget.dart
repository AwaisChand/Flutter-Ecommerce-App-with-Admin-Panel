import 'package:flutter/material.dart';

class CategoryTileWidget extends StatelessWidget {
  const CategoryTileWidget(
      {super.key,
      required this.image,
      required this.onTapped});

  final String image;
  final VoidCallback onTapped;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapped,
      child: Container(
        height: 100,
        width: 60,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage(image),
              height: 50,
              width: 50,
              fit: BoxFit.cover,
            ),
            const SizedBox(
              height: 10.0,
            ),
            const Icon(Icons.arrow_forward)
          ],
        ),
      ),
    );
  }
}
