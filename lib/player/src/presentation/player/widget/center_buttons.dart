import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_note_player/player/src/presentation/player/widget/player_button.dart';
import '../controller/player_cubit.dart';

class CenterButtons extends StatelessWidget {
  final bool isCenter;

  const CenterButtons({super.key,   this.isCenter = false});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PlayerCubit>();

    double? size;
    if (isCenter) {
      size = 36;
    }
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PlayerButton(
          icon: Icons.skip_previous_outlined,
          onTap: () {},
          size: size,
        ),
        const SizedBox(width: 12),
        BlocBuilder<PlayerCubit, PlayerState>(
          buildWhen: (prev, current) =>
              prev.playerStatus != current.playerStatus,
          builder: (context, state) {
            return Center(
              child: PlayerButton(
                size: size,

                icon: state.playerStatus == PlayerStatus.play
                    ? Icons.pause_outlined
                    : Icons.play_arrow_outlined,

                onTap: () {
                  cubit.togglePlayPause();
                  cubit.showControlsAndRestartTimer();
                },
              ),
            );
          },
        ),
        const SizedBox(width: 12),
        PlayerButton(icon: Icons.skip_next_outlined, onTap: () {}, size: size),
      ],
    );
  }
}
