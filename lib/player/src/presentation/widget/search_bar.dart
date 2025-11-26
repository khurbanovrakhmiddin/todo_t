import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_note_player/player/src/presentation/widget/theme_switch_button.dart';

import '../bloc/theme_cubit.dart';

class CustomSearchAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final double height = 83.0;

  final VoidCallback onMenuPressed;
  final VoidCallback onSignInPressed;

  const CustomSearchAppBar({
    super.key,
    required this.onMenuPressed,
    required this.onSignInPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: height,
        color: Theme.of(context).scaffoldBackgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),

        child: Row(
          children: <Widget>[
            IconButton(icon: const Icon(Icons.menu), onPressed: onMenuPressed),

            const SizedBox(width: 8.0),

            const Spacer(),
            Expanded(
              flex: 5,
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.search_rounded),
                    hintText: 'Search...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 15.0,
                      vertical: 8.0,
                    ),
                  ),
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ),
            const Spacer(),

            const SizedBox(width: 8.0),
            ThemeSwitchButton(
              value: context.read<ThemeCubit>().state.isDark,
              hasBorder: false,
            ),
            const SizedBox(width: 8.0),

            SizedBox(
              height: 40,
              child: ElevatedButton(
                onPressed: onSignInPressed,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 0,
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Sign In',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
