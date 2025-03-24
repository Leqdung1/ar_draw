import 'dart:io';
import 'package:path/path.dart';
import 'package:ragnarok_flutter/top_level_variable.dart';

extension FileExt on File {
  String get name => path.split('/').last;

  String get extension => path.split('.').last;

  String get nameWithoutExtension => name.split('.').first;

  String get pathWithoutName => path.replaceAll(name, '');

  /// Get file size in KB
  double get sizeInKB => lengthSync() / 1024;

  /// Get file size in MB
  double get sizeInMB => sizeInKB / 1024;

  /// Get file size in GB
  double get sizeInGB => sizeInMB / 1024;

  /// Get file size in string format
  String get sizeInString {
    if (sizeInGB > 1) {
      return '${sizeInGB.toStringAsFixed(2)} GB';
    } else if (sizeInMB > 1) {
      return '${sizeInMB.toStringAsFixed(2)} MB';
    } else if (sizeInKB > 1) {
      return '${sizeInKB.toStringAsFixed(2)} KB';
    } else {
      return '${lengthSync()} B';
    }
  }

  /// check if file is image
  bool get isImage {
    final ext = extension.toLowerCase();
    return ext == 'jpg' ||
        ext == 'jpeg' ||
        ext == 'png' ||
        ext == 'gif' ||
        ext == 'webp';
  }

  /// check if file is video
  bool get isVideo {
    final ext = extension.toLowerCase();
    return ext == 'mp4' ||
        ext == 'avi' ||
        ext == 'mkv' ||
        ext == 'mov' ||
        ext == 'flv';
  }

  /// check if file is audio
  bool get isAudio {
    final ext = extension.toLowerCase();
    return ext == 'mp3' ||
        ext == 'wav' ||
        ext == 'flac' ||
        ext == 'm4a' ||
        ext == 'aac';
  }

  /// check if file is pdf
  bool get isPdf => extension.toLowerCase() == 'pdf';

  /// check if file is text
  bool get isText {
    final ext = extension.toLowerCase();
    return ext == 'txt' || ext == 'doc' || ext == 'docx' || ext == 'pdf';
  }

  Future<File> uniqueName(String name,
      {String format = 'd', bool space = true}) {
    var result = _name(name, format, space);
    return File(join(pathWithoutName, result)).create(recursive: true);
  }

  // with sync
  void uniqueNameSync(String name, {String format = 'd', bool space = true}) {
    var result = _name(name, format, space);
    return File(join(pathWithoutName, result)).createSync(recursive: true);
  }

  String _name(String name, String format, bool space) {
    if (Platform.isWindows) {
      return _forWindows(name, format, space);
    } else {
      return _forOthers(name, format, space);
    }
  }

  String _forOthers(String name, String format, bool space) {
    // get file name
    var fileName = name.substring(0, name.lastIndexOf('.'));

    // get file type
    var fileType = name.substring(name.lastIndexOf('.'), name.length);

    // make val for loop
    var result = name;

    int i = 0;
    while (File(join(pathWithoutName, result)).existsSync()) {
      i += 1;
      result = fileName +
          (space ? ' ' : '') +
          format.replaceAll('d', '$i') +
          fileType;
    }
    return result;
  }

  String _forWindows(String name, String format, bool space) {
    // get all from directory path
    var list = Directory(path).listSync();

    // make name list and it is case-insensitive for windows file systems
    // so nameList shoud be compared by lower-case
    var nameList = list
        .map((e) => e.absolute.path.split(separator).last.toLowerCase())
        .toList();

    // get file name
    var fileName = name.substring(0, name.lastIndexOf('.'));

    // get file type
    var fileType = name.substring(name.lastIndexOf('.'), name.length);

    // make val for loop
    var result = name;

    int i = 0;
    while (nameList.contains(result.toLowerCase())) {
      i += 1;
      result = fileName +
          (space ? ' ' : '') +
          format.replaceAll('d', '$i') +
          fileType;
    }
    return result;
  }
}
