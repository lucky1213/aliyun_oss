# aliyun_oss_flutter

aliyun oss plugin for flutter. Use this plugin to upload files to aliyun oss.

## Usage

To use this plugin, add `aliyun_oss_flutter` as a [dependency in your pubspec.yaml file](https://flutter.dev/docs/development/platform-integration/platform-channels).

`OSSClient` is a static class

## 压缩需求
现版本已移除图片压缩、宽高获取，如需对视频、图片进行压缩可以使用[media_asset_utils](https://pub.flutter-io.cn/packages/media_asset_utils) 

- [x] 视频硬编码压缩以及图片仿微信[Luban](https://github.com/Curzibn/Luban)压缩
- [x] 视频缩略图获取
- [x] 视频和图片的width、height、orientation等信息获取
- [x] 保存到相册，支持Android Q+

### Example
``` dart
import 'package:flutter/material.dart';
import 'package:aliyun_oss_flutter/aliyun_oss_flutter.dart';

void main() {

  // 初始化OSSClient
  OSSClient.init(
    endpoint: 'oss-cn-hangzhou.aliyuncs.com',
    bucket: 'xxxx',
    credentials: () {
      // Future Credentials
      return Credentials.fromJson(response.data);
      // Or Credentials Config
      return Credentials(
        accessKeyId: 'xxxx',
        accessKeySecret: 'xxxx',
      );
    },
  );

  runApp(...);
}

Future<void> upload() async {
  final object = await OSSClient().putObject(
    object: OSSObject
    bucket: xxx, // String?
    endpoint: xxx, // String?
    path: xxx, // String?
  );
}
```