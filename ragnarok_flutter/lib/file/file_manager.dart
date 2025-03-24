import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ragnarok_flutter/ads/ads_service.dart';
import 'package:ragnarok_flutter/permission/permission_utils.dart';
import 'package:ragnarok_flutter/utils/extensions/file_ext.dart';

class FileManager {
  /// File
  static final _filePicker = FilePicker.platform;

  /// read file
  static Future<FilePickerResult?> _pickFiles({
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    dynamic Function(FilePickerStatus)? onFileLoading,
    bool allowCompression = true,
    int compressionQuality = 30,
    bool withData = false,
    bool withReadStream = false,
    bool allowMultiple = false,
  }) async {
    bool isGranted = false;
    if (Platform.isAndroid) {
      final deviceInfo = await DeviceInfoPlugin().androidInfo;
      if (deviceInfo.version.sdkInt >= 33) {
        isGranted = true;
      } else {
        await PermissionUtils.permissionHandler(
          permission: Permission.storage,
          onGranted: () {
            print('Permission granted');
            isGranted = true;
          },
          onDenied: () {
            print('Permission denied');
            isGranted = false;
          },
        );
      }
    } else {
      await PermissionUtils.permissionHandler(
        permission: Permission.storage,
        onGranted: () {
          print('Permission granted');
          isGranted = true;
        },
        onDenied: () {
          print('Permission denied');
          isGranted = false;
        },
      );
    }
    if (!isGranted) {
      return null;
    }
    // AdsService.needToShowAds = false;
    return await _filePicker.pickFiles(
      type: type,
      allowedExtensions: allowedExtensions,
      allowCompression: allowCompression,
      compressionQuality: compressionQuality,
      allowMultiple: allowMultiple,
      withData: withData,
      withReadStream: withReadStream,
    );
  }

  static Future<File?> pickFile({
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    dynamic Function(FilePickerStatus)? onFileLoading,
    bool allowCompression = true,
    int compressionQuality = 30,
    bool withData = false,
    bool withReadStream = false,
  }) async {
    final result = await _pickFiles(
      type: type,
      allowedExtensions: allowedExtensions,
      allowCompression: allowCompression,
      compressionQuality: compressionQuality,
      withData: withData,
      withReadStream: withReadStream,
      allowMultiple: false,
    );

    if (result == null || result.files.isEmpty) {
      return null;
    }

    return File(result.files.single.path!);
  }

  static Future<List<File>> pickMultiFile({
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    dynamic Function(FilePickerStatus)? onFileLoading,
    bool allowCompression = true,
    int compressionQuality = 30,
    bool withData = false,
    bool withReadStream = false,
  }) async {
    final result = await _pickFiles(
      type: type,
      allowedExtensions: allowedExtensions,
      allowCompression: allowCompression,
      compressionQuality: compressionQuality,
      allowMultiple: true,
      withData: withData,
      withReadStream: withReadStream,
    );

    if (result == null || result.files.isEmpty) {
      return [];
    }

    return result.files.map((e) => File(e.path!)).toList();
  }
}
