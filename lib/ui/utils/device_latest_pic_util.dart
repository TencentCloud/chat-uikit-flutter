import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class DeviceLatestPicUtil {
  static final DeviceLatestPicUtil of = DeviceLatestPicUtil._();
  DeviceLatestPicUtil._();

  String _lastImgPath = '';

  // 间隔时间：多少毫秒之内保存的图片
  // more 2 分钟内新增的图片
  final int _spaceTime = 2 * 60 * 1000;

  Future<String> getLatestImage() async {
    try {
      List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        onlyAll: true,
        type: RequestType.image,
        filterOption: FilterOptionGroup(
          createTimeCond: DateTimeCond(
            min: DateTime.fromMillisecondsSinceEpoch(
              DateTime.now().millisecondsSinceEpoch - _spaceTime,
            ),
            max: DateTime.now(),
          ),
        ),
      );

      List<AssetEntity> allAssets = [];

      for (final album in albums) {
        List<AssetEntity> assets =
            await album.getAssetListRange(start: 0, end: 1);
        if (assets.isNotEmpty) {
          allAssets.add(assets.first);
        }
      }

      if (allAssets.isNotEmpty) {
        AssetEntity latestAsset = allAssets.first;
        File? file = await latestAsset.file;
        final filePath = file?.path ?? '';
        if (filePath == _lastImgPath) {
          // 整个应用周期内，显示过的图片不在显示
          return '';
        }
        if (filePath.isNotEmpty) {
          _lastImgPath = filePath;
        }
        return file?.path ?? '';
      }

      return '';
    } catch (e) {
      debugPrint('getLatestImage error: $e');
      return '';
    }
  }
}
