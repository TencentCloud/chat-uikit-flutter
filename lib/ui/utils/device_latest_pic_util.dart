import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class DeviceLatestPicUtil {
  static final DeviceLatestPicUtil of = DeviceLatestPicUtil._();
  DeviceLatestPicUtil._();

  String _lastImgPath = '';

  Future<String> getLatestImage() async {
    try {
      List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        onlyAll: true,
        type: RequestType.image,
        filterOption: FilterOptionGroup(
          createTimeCond: DateTimeCond(
            // 1分钟内新增的图片
            min: DateTime.fromMillisecondsSinceEpoch(
              DateTime.now().millisecondsSinceEpoch - 1 * 60 * 1000,
            ),
            max: DateTime.now(),
          ),
        ),
      );

      debugPrint('latestAsset albums: ${albums.length}');

      List<AssetEntity> allAssets = [];

      for (final album in albums) {
        List<AssetEntity> assets =
            await album.getAssetListRange(start: 0, end: 1);
        if (assets.isNotEmpty) {
          allAssets.add(assets.first);
        }
      }

      // allAssets.sort((a, b) => b.createDateTime.compareTo(a.createDateTime));
      debugPrint('latestAsset allAssets: ${allAssets.length}');

      allAssets.forEach((asset) {
        debugPrint('latestAsset: ${asset.createDateTime}');
      });

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
      rethrow;
    }
  }
}
