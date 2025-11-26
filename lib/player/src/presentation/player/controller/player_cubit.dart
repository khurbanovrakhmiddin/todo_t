import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:video_player/video_player.dart';

part 'player_state.dart';

class PlayerCubit extends Cubit<PlayerState> {
  Timer? _positionTimer;
  Timer? _visibilityTimer;

  final Duration _hideDuration = const Duration(seconds: 5);

  VideoPlayerController? get controller => state.controller;

  PlayerCubit() : super(const PlayerState(fetchStatus: FetchStatus.init));

  Future<void> loadVideo(String assetPath) async {
    _positionTimer?.cancel();
    state.controller?.dispose();

    emit(
      state.copyWith(
        fetchStatus: FetchStatus.fetch,
        playerStatus: PlayerStatus.stop,
        controller: null,
      ),
    );

    VideoPlayerController newController;
    if (assetPath.contains('http')) {
      newController = VideoPlayerController.networkUrl(Uri.parse(assetPath));
    } else {
      newController = VideoPlayerController.asset(assetPath);
    }

    try {
      await newController.initialize();
      final totalDuration = newController.value.duration;

      emit(
        state.copyWith(
          controller: newController,
          fetchStatus: FetchStatus.success,
          playerStatus: PlayerStatus.play,
          totalDuration: totalDuration,
          controlsVisible: true,
        ),
      );

      newController.play();
      _startPositionTimer();
      _startVisibilityTimer();
    } catch (e) {
      newController.dispose();
      emit(state.copyWith(fetchStatus: FetchStatus.fail));
    }
  }

  bool _isReady() {
    return state.fetchStatus == FetchStatus.success &&
        controller != null &&
        controller!.value.isInitialized;
  }

  void _startVisibilityTimer() {
    _visibilityTimer?.cancel();
    _visibilityTimer = Timer(_hideDuration, () {
      if (state.controlsVisible) {
        emit(state.copyWith(controlsVisible: false));
      }
    });
  }

  void showControlsAndRestartTimer() {
    if (!_isReady()) return;

    if (!state.controlsVisible) {
      emit(state.copyWith(controlsVisible: true));
    }
    _startVisibilityTimer();
  }

  void muteUnmute() {
    if (!_isReady()) return;

    if (controller!.value.volume == 0) {
      controller!.setVolume(1.0);
    } else {
      controller!.setVolume(0);
    }
    showControlsAndRestartTimer();
  }

  void togglePlayPause() {
    if (!_isReady()) return;

    if (controller!.value.isPlaying) {
      controller!.pause();
      emit(state.copyWith(playerStatus: PlayerStatus.pause));
    } else {
      controller!.play();
      emit(state.copyWith(playerStatus: PlayerStatus.play));
    }
  }

  void _startPositionTimer() {
    _positionTimer?.cancel();

    _positionTimer = Timer.periodic(const Duration(milliseconds: 250), (timer) {
      if (controller != null) {
        if (controller!.value.isPlaying && controller!.value.isInitialized) {
          emit(state.copyWith(currentPosition: controller!.value.position));
        } else if (state.fetchStatus != FetchStatus.success) {
          _positionTimer?.cancel();
        }
      }
    });
  }

  void seekTo(Duration newPosition) {
    if (!_isReady()) return;

    controller!.seekTo(newPosition);
    emit(state.copyWith(currentPosition: newPosition));
  }

  void seekToF() {
    if (!_isReady()) return;

    final currentPosition = state.currentPosition;
    final totalDuration = state.totalDuration;

    final newPosition = currentPosition + const Duration(seconds: 5);

    final clampedPosition = newPosition < Duration.zero
        ? Duration.zero
        : (newPosition > totalDuration ? totalDuration : newPosition);

    seekTo(clampedPosition);
    showControlsAndRestartTimer();
  }

  void seekToB() {
    if (!_isReady()) return;

    final currentPosition = state.currentPosition;
    final totalDuration = state.totalDuration;

    final newPosition = currentPosition - const Duration(seconds: 5);

    final clampedPosition = newPosition < Duration.zero
        ? Duration.zero
        : (newPosition > totalDuration ? totalDuration : newPosition);

    seekTo(clampedPosition);
    showControlsAndRestartTimer();
  }

  void toggleFullscreen(bool? enable) {
    if (isClosed) return;

    final shouldBeFullscreen = enable ?? !state.isFullscreen;

    if (shouldBeFullscreen != state.isFullscreen) {
      emit(state.copyWith(isFullscreen: shouldBeFullscreen));
    }
    showControlsAndRestartTimer();
  }

  void clear() {
    if (isClosed) return;
    _positionTimer?.cancel();
    _visibilityTimer?.cancel();
    state.controller?.pause();
  }

  @override
  Future<void> close() {
    if (isClosed) return Future.value();

    _positionTimer?.cancel();
    _visibilityTimer?.cancel();

    state.controller?.dispose();

    return super.close();
  }
}