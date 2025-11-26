import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_note_player/player/src/presentation/player/view/player_overlay.dart';
import 'package:video_player/video_player.dart';
import 'controller/player_cubit.dart';

class VideoScreen extends StatelessWidget {
  const VideoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerCubit, PlayerState>(
      buildWhen: (prev, current) =>
          prev.fetchStatus != current.fetchStatus ||
          prev.controller != current.controller,

      builder: (context, state) {
        if (state.fetchStatus == FetchStatus.fail) {
          return Center(
            child: Text(
              'Ошибка загрузки видео.',
              style: TextStyle(color: Colors.red),
            ),
          );
        }

        return SizedBox(
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: double.maxFinite,
                height: double.maxFinite,
                child: ColoredBox(color: Colors.black87),
              ),
              state.controller == null
                  ? Center(child: CircularProgressIndicator())
                  : AspectRatio(
                      aspectRatio:
                          state.controller?.value.aspectRatio ?? 16 / 9,
                      child: Center(child: VideoPlayer(state.controller!)),
                    ),

              const VideoControlsOverlay(),
            ],
          ),
        );
      },
    );
  }
}
