import 'package:flutter/material.dart' show MaterialColor, Colors;

class StatusParser {
  static (MaterialColor?, String) getStatus(DateTime? time) {
    if (time == null) return (Colors.red, '');
    final diff = time.difference(DateTime.now());

    if (diff.inSeconds > 0) {
      return (null, '');
    } else if (diff.inSeconds.abs() <= 3600) {
      return (null, '');
    } else {
      return (Colors.red, 'Просрочено');
    }
  }
}
