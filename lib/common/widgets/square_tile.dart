import 'package:flutter/material.dart';

class SquareTile extends StatelessWidget {
  const SquareTile({super.key, required this.imagePath, required this.onTap});

  final String imagePath;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 0,
              blurRadius: 4,
              offset: const Offset(0, 4), // changes the position of the shadow
            ),
          ],
        ),
        child: Image.asset(
          imagePath,
          height: 85,
        ),
      ),
    );
  }
}
