import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/theme_cubit.dart';
import 'lite_rolling.dart';

class ThemeSwitchButton extends StatelessWidget {
  final bool value;
  final bool hasBorder;

  const ThemeSwitchButton({
    super.key,
    required this.value,
      this.hasBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return CustomLiteRollingSwitch(
      value: value,
      hasBorder: hasBorder,
      onTap: () {},
      onSwipe: (bool p1) {
        context.read<ThemeCubit>().setTheme(p1);
      },
    );
  }
}
