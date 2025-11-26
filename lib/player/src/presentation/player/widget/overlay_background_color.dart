import 'package:flutter/material.dart';

class OverlayBackgroundColor extends Positioned {
  OverlayBackgroundColor({super.key})
    : super(
        bottom: 0,
        left: 0,
        right: 0,
        top: 0,
        child: ColoredBox(color: Colors.black54),
      );
}
