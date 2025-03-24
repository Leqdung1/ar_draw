extension DurationExt on Duration{
  String get toMMss {
    final minutes = inMinutes;
    final seconds = inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2,'0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String get toHHmmss {
    final hours = inHours;
    final minutes = inMinutes.remainder(60);
    final seconds = inSeconds.remainder(60);
    return '${hours.toString().padLeft(2,'0')}:${minutes.toString().padLeft(2,'0')}:${seconds.toString().padLeft(2,'0')}';
  }

  String get toHHmm {
    final hours = inHours;
    final minutes = inMinutes.remainder(60);
    return '${hours.toString().padLeft(2,'0')}:${minutes.toString().padLeft(2,'0')}';
  }

  String get toHH {
    final hours = inHours;
    return '${hours.toString().padLeft(2,'0')}';
  }

}