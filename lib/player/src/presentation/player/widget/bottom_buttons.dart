import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_note_player/player/src/presentation/player/widget/center_buttons.dart';
import 'package:task_note_player/player/src/presentation/player/widget/player_button.dart';
import 'package:task_note_player/player/src/presentation/player/widget/progress_bar.dart';
import '../../../../../services/check_device.dart';
import '../../../../../todo/src/core/parser/time_parser.dart';
import '../controller/player_cubit.dart';

class BottomButtons extends StatelessWidget {
  const BottomButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PlayerCubit>();

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<PlayerCubit, PlayerState>(
              buildWhen: (prev, current) =>
                  prev.currentPosition != current.currentPosition ||
                  prev.totalDuration != current.totalDuration,
              builder: (context, state) {
                return Text(
                  '${AppTimeParser.formatDuration(state.currentPosition)} / ${AppTimeParser.formatDuration(state.totalDuration)}',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                );
              },
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                if (!context.isMobileOr)
                  Padding(
                    padding: const EdgeInsetsGeometry.only(right: 8),
                    child: CenterButtons(),
                  ),

                ProgressBar(cubit: cubit),
                BlocBuilder<PlayerCubit, PlayerState>(
                  builder: (context, state) {
                    return PlayerButton(
                      icon: state.controller?.value.volume == 0
                          ? Icons.volume_off_outlined
                          : Icons.volume_up_outlined,
                      onTap: () {
                        cubit.muteUnmute();
                      },
                    );
                  },
                ),
                BlocBuilder<PlayerCubit, PlayerState>(
                  builder: (context, state) {
                    return PlayerButton(
                      icon: state.isFullscreen
                          ? Icons.close_fullscreen_rounded
                          : Icons.open_in_full_rounded,
                      onTap: () {
                        cubit.toggleFullscreen(null);
                        cubit.showControlsAndRestartTimer();
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
