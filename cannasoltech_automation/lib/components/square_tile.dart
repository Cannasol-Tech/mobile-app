import 'package:flutter/material.dart';

class SquareTile extends StatelessWidget {

  final String imagePath;

  const SquareTile({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white
        
      ),
      child: Image.asset(imagePath, height: 50),
    );
  }
}