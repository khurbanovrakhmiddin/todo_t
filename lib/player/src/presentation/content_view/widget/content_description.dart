import 'package:flutter/material.dart';

class ContentDescription extends StatelessWidget {
  final String description;

  const ContentDescription({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(16),
        ),
        color: Theme.of(context).cardColor,

        margin: EdgeInsets.all(16),
        elevation: 0,
        child: Padding(
          padding: EdgeInsetsGeometry.all(16),
          child: SizedBox(
            width: double.maxFinite,
            child: Text(description, style: TextStyle(fontSize: 14)),
          ),
        ),
      ),
    );
  }
}
