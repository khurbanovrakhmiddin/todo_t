import 'package:flutter/material.dart';

class PlayerButton extends StatelessWidget {
  final IconData icon;
  final size;
  final void Function() onTap;

  const PlayerButton({super.key, required this.icon, required this.onTap, this.size});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(Colors.grey),
      ),
      icon: Icon(icon, color: Colors.white,size: size,),
      onPressed: onTap,
    );
  }
}
