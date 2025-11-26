import 'package:flutter/material.dart';

class CustomCard extends Card {
  CustomCard({super.key, required super.child})
    : super(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(8),
        ),
      );
}
