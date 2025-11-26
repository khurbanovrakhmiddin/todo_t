import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_note_player/player/src/presentation/content_view/widget/content_description.dart';
import 'package:task_note_player/player/src/presentation/content_view/widget/content_view_action.dart';
import 'package:task_note_player/services/check_device.dart';

import '../../domain/model/content_model.dart';
import '../bloc/theme_cubit.dart';
import '../player/controller/player_cubit.dart';
import '../player/player_view.dart';
import '../widget/search_bar.dart';

class ContentView extends StatefulWidget {
  final ContentModel contentModel;

  const ContentView({super.key, required this.contentModel});

  @override
  State<ContentView> createState() => _ContentViewState();
}

class _ContentViewState extends State<ContentView> {
  late final PlayerCubit _cubit;

  final UniqueKey _playerKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    _cubit = PlayerCubit();
    _cubit.loadVideo(widget.contentModel.url);
    _setSystemFullscreen(false);
  }

  ContentModel get contentModel => widget.contentModel;

  @override
  void didUpdateWidget(covariant ContentView oldWidget) {
    if (oldWidget.contentModel.url != widget.contentModel.url) {
      _cubit.loadVideo(widget.contentModel.url);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    _cubit.close();
    super.dispose();
  }

  void _setSystemFullscreen(bool enable) {
    if (enable) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: SystemUiOverlay.values,
      );
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
  }

  void _handleOrientationChange(Orientation orientation) {
    final bool shouldBeFullscreen = orientation == Orientation.landscape;

    if (shouldBeFullscreen != _cubit.state.isFullscreen) {
      _cubit.toggleFullscreen(shouldBeFullscreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final bool isDark = state.themeMode == ThemeMode.dark;

        final ThemeData localTheme = isDark
            ? ThemeData(
                cardColor: Colors.white10,
                brightness: Brightness.dark,
                iconTheme: IconThemeData(color: Colors.white),
                colorScheme: ColorScheme.dark(
                  primary: Colors.lightGreen,
                  background: Colors.grey.shade800,
                  surface: Colors.grey.shade900,
                ),
              )
            : ThemeData(
                cardColor: const Color(0x10000005),

                iconTheme: IconThemeData(color: Colors.black),
                brightness: Brightness.light,
                colorScheme: ColorScheme.light(
                  primary: Colors.blue,
                  background: Colors.white,
                  surface: Colors.grey.shade200,
                ),
              );

        return Theme(
          data: localTheme,
          child: BlocProvider(
            create: (_) => _cubit,
            child: Builder(
              builder: (context) {
                return BlocListener<PlayerCubit, PlayerState>(
                  listenWhen: (previous, current) =>
                      previous.isFullscreen != current.isFullscreen,
                  listener: (context, state) {
                    _setSystemFullscreen(state.isFullscreen);
                  },
                  child: Scaffold(
                    appBar:
                        context.select(
                          (PlayerCubit cubit) => cubit.state.isFullscreen,
                        )
                        ? null
                        : !context.isMobileOr
                        ? CustomSearchAppBar(
                            onMenuPressed: () {
                              Navigator.pop(context);
                            },
                            onSignInPressed: () {},
                          )
                        : AppBar(),
                    //chtobi mojno bilo viyti nazad dve task obedenil poetomu
                    body: OrientationBuilder(
                      builder: (context, orientation) {
                        _handleOrientationChange(orientation);

                        final isFullscreen = context.select(
                          (PlayerCubit cubit) => cubit.state.isFullscreen,
                        );

                        if (isFullscreen) {
                          return VideoScreen(key: _playerKey);
                        }

                        return SafeArea(
                          child: Column(
                            children: [
                              SizedBox(
                                width: double.maxFinite,
                                height: MediaQuery.sizeOf(context).height / 3,
                                child: VideoScreen(key: _playerKey),
                              ),
                              SizedBox(height: context.height * .03),
                              ContentViewAction(contentModel: contentModel),
                              Expanded(
                                child: ContentDescription(
                                  description: contentModel.description,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
