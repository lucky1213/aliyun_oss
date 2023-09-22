part of aliyun_oss_flutter;

class Credentials {
  Credentials({
    required this.accessKeyId,
    required this.accessKeySecret,
    this.securityToken,
    this.expiration,
  }) {
    if (!useSecurityToken) {
      clearSecurityToken();
    }
  }

  factory Credentials.fromJson(String str) =>
      Credentials.fromMap(json.decode(str) as Map<String, dynamic>);

  factory Credentials.fromMap(Map<String, dynamic> json) {
    return Credentials(
      accessKeyId: json['access_key_id'] as String,
      accessKeySecret: json['access_key_secret'] as String,
      securityToken: json['security_token'] as String,
      expiration: json['expiration'] != null
          ? DateTime.parse(json['expiration'] as String)
          : null,
    );
  }

  final String accessKeyId;
  final String accessKeySecret;
  String? securityToken;
  DateTime? expiration;

  bool get useSecurityToken => securityToken != null && expiration != null;

  void clearSecurityToken() {
    securityToken = null;
    expiration = null;
  }
}

abstract class OSSObject {
  OSSObject._({
    required this.bytes,
    MediaType? mediaType,
    this.uuid,
  }) : _mediaType = mediaType ?? MediaType('application', 'octet-stream');

  final Uint8List bytes;

  final MediaType _mediaType;
  MediaType get mediaType => _mediaType;

  final String? uuid;

  String url = '';

  int get length => bytes.lengthInBytes;

  String get type => _mediaType == MediaType('application', 'octet-stream')
      ? 'file'
      : _mediaType.type;

  String get name =>
      (uuid ?? const Uuid().v1()) +
      (type == 'file' ? '' : '.${_mediaType.subtype}');

  String get folderPath => [
        type,
        DateFormat('y/MM/dd').format(DateTime.now()),
      ].join('/');

  String resourcePath(String? path) => '${path ?? folderPath}/$name';

  void uploadSuccessful(String url) {
    this.url = url;
  }
}

/// * [quality] 压缩存在问题，如果当图片没有exif将无法压缩
class OSSImageObject extends OSSObject {
  OSSImageObject._({
    required Uint8List bytes,
    required MediaType mediaType,
    String? uuid,
  }) : super._(bytes: bytes, mediaType: mediaType, uuid: uuid);

  factory OSSImageObject.fromBytes({
    required Uint8List bytes,
    required MediaType mediaType,
    String? uuid,
  }) {
    return OSSImageObject._(
      bytes: bytes,
      mediaType: mediaType,
      uuid: uuid,
    );
  }

  factory OSSImageObject.fromFile({
    required File file,
    String? uuid,
  }) {
    String subtype = path.extension(file.path).toLowerCase();
    subtype = subtype.isNotEmpty ? subtype.replaceFirst('.', '') : '*';
    return OSSImageObject._(
      bytes: file.readAsBytesSync(),
      mediaType: MediaType('image', subtype),
      uuid: uuid,
    );
  }

  // decodeImage UI
  // late int _width;
  // late int _height;
  // int get width => _width;
  // int get height => _height;

  // void _decodeExif() {
  //   img.Image image;
  //   if (mediaType.subtype == 'jpg' || mediaType.subtype == 'jpeg') {
  //     image = img.decodeJpg(bytes);
  //   } else if (mediaType.subtype == 'png') {
  //     image = img.decodePng(bytes)!;
  //   } else if (mediaType.subtype == 'gif') {
  //     image = img.decodeGif(bytes)!;
  //   } else {
  //     image = img.decodeImage(bytes)!;
  //   }
  //   _width = image.width;
  //   _height = image.height;
  //   if (image.exif.hasOrientation) {
  //     print(image.exif.orientation);
  //   }
  // }
}

/// * [length] 秒为单位
class OSSAudioObject extends OSSObject {
  OSSAudioObject._({
    required Uint8List bytes,
    required MediaType mediaType,
    String? uuid,
  }) : super._(bytes: bytes, mediaType: mediaType, uuid: uuid);

  factory OSSAudioObject.fromBytes({
    required Uint8List bytes,
    required MediaType mediaType,
    String? uuid,
  }) {
    return OSSAudioObject._(
      bytes: bytes,
      mediaType: mediaType,
      uuid: uuid,
    );
  }

  factory OSSAudioObject.fromFile({
    required File file,
    String? uuid,
  }) {
    String subtype = path.extension(file.path).toLowerCase();
    subtype = subtype.isNotEmpty ? subtype.replaceFirst('.', '') : '*';

    return OSSAudioObject._(
      bytes: file.readAsBytesSync(),
      mediaType: MediaType('audio', subtype),
      uuid: uuid,
    );
  }
}

/// * [length] 秒为单位
class OSSVideoObject extends OSSObject {
  OSSVideoObject._({
    required Uint8List bytes,
    required MediaType mediaType,
    String? uuid,
  }) : super._(bytes: bytes, mediaType: mediaType, uuid: uuid);

  factory OSSVideoObject.fromBytes({
    required Uint8List bytes,
    required MediaType mediaType,
    String? uuid,
  }) {
    return OSSVideoObject._(
      bytes: bytes,
      mediaType: mediaType,
      uuid: uuid,
    );
  }

  factory OSSVideoObject.fromFile({
    required File file,
    String? uuid,
  }) {
    String subtype = path.extension(file.path).toLowerCase();
    subtype = subtype.isNotEmpty ? subtype.replaceFirst('.', '') : '*';

    return OSSVideoObject._(
      bytes: file.readAsBytesSync(),
      mediaType: MediaType('video', subtype),
      uuid: uuid,
    );
  }
}
