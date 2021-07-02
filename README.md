# aliyun_oss_flutter

aliyun oss plugin for flutter. Use this plugin to upload files to aliyun oss.

## Usage

To use this plugin, add `aliyun_oss_flutter` as a [dependency in your pubspec.yaml file](https://flutter.dev/docs/development/platform-integration/platform-channels).

`OSSClient` is a static class

### Example
``` dart
import 'package:flutter/material.dart';
import 'package:aliyun_oss_flutter/aliyun_oss.dart';

void main() {

  // 初始化OSSClient
  OSSClient.init(
    endpoint: 'oss-cn-hangzhou.aliyuncs.com',
    bucket: 'xxxx',
    credentials: () {
      // Future Credentials
      return Credentials.fromJson(response.data);
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