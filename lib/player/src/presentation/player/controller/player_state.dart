part of 'player_cubit.dart';

enum FetchStatus { init, fetch, success, fail }

enum PlayerStatus { init, pause, stop, play }

class PlayerState extends Equatable {
  final FetchStatus fetchStatus;
  final PlayerStatus playerStatus;
  final Duration currentPosition;
  final Duration totalDuration;
  final VideoPlayerController? controller;
  final bool isFullscreen;
  final bool controlsVisible;

  const PlayerState({
    this.fetchStatus = FetchStatus.init,
    this.playerStatus = PlayerStatus.init,
    this.currentPosition = Duration.zero,
    this.totalDuration = Duration.zero,
    this.controller,
    this.controlsVisible = true,
    this.isFullscreen = false,
  });

  PlayerState copyWith({
    FetchStatus? fetchStatus,
    PlayerStatus? playerStatus,
    Duration? currentPosition,
    Duration? totalDuration,
    VideoPlayerController? controller,
    bool? controlsVisible,
    bool? isFullscreen,
  }) {
    return PlayerState(
      fetchStatus: fetchStatus ?? this.fetchStatus,
      playerStatus: playerStatus ?? this.playerStatus,
      currentPosition: currentPosition ?? this.currentPosition,
      totalDuration: totalDuration ?? this.totalDuration,
      controller: controller ?? this.controller,
      controlsVisible: controlsVisible ?? this.controlsVisible,
      isFullscreen: isFullscreen ?? this.isFullscreen,
    );
  }

  @override
  List<Object> get props => [
    fetchStatus,
    playerStatus,
    currentPosition,
    totalDuration,
    controlsVisible,
    isFullscreen,
  ];
}
