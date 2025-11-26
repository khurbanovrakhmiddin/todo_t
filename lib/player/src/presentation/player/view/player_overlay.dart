import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_note_player/services/check_device.dart';
import '../controller/player_cubit.dart';
import '../widget/bottom_buttons.dart';
import '../widget/center_buttons.dart';
import '../widget/overlay_background_color.dart';
import '../widget/top_buttons.dart';

class VideoControlsOverlay extends StatelessWidget {
  const VideoControlsOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PlayerCubit>();

    return BlocBuilder<PlayerCubit, PlayerState>(
      buildWhen: (prev, current) =>
          prev.controlsVisible != current.controlsVisible,
      builder: (context, state) {
        return GestureDetector(
          onTap: cubit.showControlsAndRestartTimer,
          child: AbsorbPointer(
            absorbing: !state.controlsVisible,
            child: AnimatedOpacity(
              opacity: state.controlsVisible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Stack(
                children: <Widget>[
                  OverlayBackgroundColor(),
                  if(context.isMobileOr)TopButtons(),
                  CenterButtons(isCenter: !context.isMobileOr),
                  BottomButtons(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
