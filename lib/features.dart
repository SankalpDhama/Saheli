import 'package:flutter/material.dart';
import 'package:saheli/colors.dart';

class Feature extends StatelessWidget {
  final Color color;
  final String header;
  final String description;
  const Feature({super.key, required this.color, required this.header, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 15),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                header,
                style: const TextStyle(
                    fontFamily: 'Cera Pro',
                    color: Pallete.blackColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height:  3),
            Text(
              description,
              style: const TextStyle(
                fontFamily: 'Cera Pro',
                color: Pallete.blackColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
