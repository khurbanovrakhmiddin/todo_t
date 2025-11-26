import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math';

import 'package:task_note_player/player/src/core/app_icons.dart';

class CustomSwitchMenuEntry extends PopupMenuEntry<bool> {
  final Widget switchWidget;

  const CustomSwitchMenuEntry({required this.switchWidget, super.key});

  @override
  double get height => 54.0;

  @override
  bool represents(bool? value) => false;

  @override
  State<CustomSwitchMenuEntry> createState() => _CustomSwitchMenuEntryState();
}

class _CustomSwitchMenuEntryState extends State<CustomSwitchMenuEntry> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: widget.switchWidget,
    );
  }
}

class CustomLiteRollingSwitch extends StatefulWidget {
  final bool value;
  final bool hasBorder;
  final Function(bool)? onChanged;
  final void Function()? onTap;
  final void Function()? onDoubleTap;
  final void Function(bool isDarkd)? onSwipe;

  const CustomLiteRollingSwitch({
    super.key,
    this.value = false,
    this.hasBorder = true,
    required this.onTap,
    this.onDoubleTap,
    this.onSwipe,
    this.onChanged,
  });

  @override
  State<CustomLiteRollingSwitch> createState() =>
      _CustomLiteRollingSwitchState();
}

class _CustomLiteRollingSwitchState extends State<CustomLiteRollingSwitch>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;
  double value = 0.0;

  bool turnState = false;
  final Duration animationDuration = const Duration(milliseconds: 600);

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      lowerBound: 0.0,
      upperBound: 1.0,
      duration: animationDuration,
    );
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    );
    animationController.addListener(() {
      setState(() {
        value = animation.value;
      });
    });
    turnState = widget.value;
    _determine();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void _action() {
    _determine(changeState: true);
  }

  void _determine({bool changeState = false}) {
    setState(() {
      if (changeState) turnState = !turnState;
      (turnState)
          ? animationController.forward()
          : animationController.reverse();

      widget.onChanged?.call(turnState);
    });
  }

  Widget _buildChild(Widget child) {
    if (!widget.hasBorder) return child;
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade500,

        borderRadius: BorderRadiusGeometry.circular(16),
      ),

      padding: EdgeInsetsGeometry.symmetric(horizontal: 14, vertical: 10),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    Color? transitionColor = Color.lerp(
      const Color(0xff73C0FC),
      const Color(0xff004884),
      value,
    );

    return GestureDetector(
      onDoubleTap: () {
        _action();
        if (widget.onDoubleTap != null) widget.onDoubleTap?.call();
      },
      onTap: () {
        _action();
        if (widget.onTap != null) widget.onTap?.call();
        if (widget.onSwipe != null) widget.onSwipe?.call(turnState);
      },
      onPanEnd: (details) {
        _action();
        if (widget.onSwipe != null) widget.onSwipe?.call(turnState);
      },
      child: _buildChild(
        Container(
          padding: const EdgeInsets.all(3),
          width: 72,
          decoration: BoxDecoration(
            color: transitionColor,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Stack(
            children: <Widget>[
              Positioned(
                left: 0,
                child: Opacity(
                  opacity: value,
                  child: SizedBox(
                    height: 30,
                    width: 35,
                    child: Image.asset(AppIcons.icNight),
                  ),
                ),
              ),

              Positioned(
                right: 0,
                child: Opacity(
                  opacity: 1.0 - value,
                  child: SizedBox(
                    height: 30,
                    width: 35,
                    child: Image.asset(AppIcons.icLight),
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(35 * value, 0),
                child: Transform.rotate(
                  angle: lerpDouble(0, 2 * pi, value)!,
                  child: Container(
                    height: 30,
                    width: 35,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
