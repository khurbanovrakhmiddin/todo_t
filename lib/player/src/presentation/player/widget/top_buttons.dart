import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_note_player/player/src/presentation/bloc/theme_cubit.dart';
import 'package:task_note_player/player/src/presentation/player/widget/player_button.dart';
import '../../widget/lite_rolling.dart';
import '../../widget/theme_switch_button.dart';

class TopButtons extends StatelessWidget {
  const TopButtons({super.key});

  void _showMenu(
    BuildContext context,
    Offset position,
    Size size,
    bool value,
  ) async {
    final double anchorBottom = position.dy + size.height;
    await showMenu<bool>(
      color: Colors.transparent,
      context: context,
      elevation: 0,
      position: RelativeRect.fromLTRB(
        MediaQuery.sizeOf(context).width - size.width,
        anchorBottom,
        0.0,
        0.0,
      ),
      items: [
        CustomSwitchMenuEntry(switchWidget: ThemeSwitchButton(value: value)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 10,
      top: 10,
      child: Column(
        children: [
          PlayerButton(
            icon: Icons.settings_outlined,
            onTap: () {
              final RenderBox renderBox =
                  context.findRenderObject() as RenderBox;
              final offset = renderBox.localToGlobal(Offset.zero);
              final Size size = renderBox.size;
              _showMenu(
                context,
                offset,
                size,
                context.read<ThemeCubit>().state.isDark,
              );
            },
          ),
        ],
      ),
    );
  }
}
