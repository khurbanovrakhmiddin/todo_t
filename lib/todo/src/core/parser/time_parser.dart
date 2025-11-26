import 'package:intl/intl.dart';

class AppTimeParser {
  static String time(DateTime? time) {
    if (time == null) return '';
    final res = DateFormat("yy MMMM").format(time);
    return res;
  }

  static String formatDuration(Duration d) {
    if (d == Duration.zero) return '00:00';
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    final hours = twoDigits(d.inHours);

    if (d.inHours > 0) {
      return "$hours:$minutes:$seconds";
    }
    return "$minutes:$seconds";
  }
}
