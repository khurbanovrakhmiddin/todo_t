import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../controller/player_cubit.dart';

class ProgressBar extends StatelessWidget {
  final PlayerCubit cubit;

  const ProgressBar({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
        trackHeight: 3.0,
        overlayShape: SliderComponentShape.noOverlay,
      ),
      child: Expanded(
        child: BlocBuilder<PlayerCubit, PlayerState>(
          bloc: cubit,
          buildWhen: (prev, current) =>
              prev.currentPosition != current.currentPosition ||
              prev.totalDuration != current.totalDuration,
          builder: (context, state) {
            if (state.totalDuration == Duration.zero) {
              return const LinearProgressIndicator(
                value: 0,
                color: Colors.white24,
              );
            }

            final double maxDuration = state.totalDuration.inMilliseconds
                .toDouble();
            final double currentPos = state.currentPosition.inMilliseconds
                .toDouble();

            return Container(
              decoration: BoxDecoration(
                color: Colors.grey.withAlpha((255.0 * 0.8).round()),

                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(4),
              child: Slider(
                value: currentPos.clamp(0.0, maxDuration),
                min: 0.0,
                max: maxDuration,
                activeColor: Colors.white,
                inactiveColor: Colors.white54,
                onChanged: (double newValue) {
                  final newPosition = Duration(milliseconds: newValue.toInt());
                  cubit.seekTo(newPosition);
                  cubit.showControlsAndRestartTimer();
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
