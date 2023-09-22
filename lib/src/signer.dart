part of aliyun_oss_flutter;

class SignedInfo {
  const SignedInfo({
    required this.dateString,
    required this.accessKeyId,
    required this.signature,
    this.securityToken,
  });

  final String dateString;
  final String accessKeyId;
  final String signature;
  final String? securityToken;

  Map<String, String> toHeaders() => {
        'Date': dateString,
        'Authorization': 'OSS $accessKeyId:$signature',
        if (securityToken != null) 'x-oss-security-token': securityToken!,
      };
}

class Signer {
  const Signer(this.credentials);
  final Credentials credentials;

  /// [dateString]  `Date` in [HttpDate] or `Expires` in [DateTime.secondsSinceEpoch]
  SignedInfo sign({
    required String httpMethod,
    required String resourcePath,
    Map<String, String>? parameters,
    Map<String, String>? headers,
    String? contentMd5,
    String? dateString,
  }) {
    final securityHeaders = {
      if (headers != null) ...headers,
      if (credentials.securityToken != null) ...{
        'x-oss-security-token': credentials.securityToken!,
      }
    };
    final sortedHeaders = _sortByLowerKey(securityHeaders);
    final contentType = sortedHeaders
        .firstWhere(
          (e) => e.key == 'content-type',
          orElse: () => const MapEntry('', ''),
        )
        .value;
    final canonicalizedOSSHeaders = sortedHeaders
        .where((e) => e.key.startsWith('x-oss-'))
        .map((e) => '${e.key}:${e.value}')
        .join('\n');

    final securityParameters = {
      if (parameters != null) ...parameters,
    };
    final canonicalizedResource =
        _buildCanonicalizedResource(resourcePath, securityParameters);

    final date = dateString ?? _requestTime();
    final canonicalString = [
      httpMethod,
      contentMd5 ?? '',
      contentType,
      date,
      if (canonicalizedOSSHeaders.isNotEmpty) canonicalizedOSSHeaders,
      canonicalizedResource,
    ].join('\n');

    final signature = _computeHmacSha1(canonicalString);
    return SignedInfo(
        dateString: date,
        accessKeyId: credentials.accessKeyId,
        signature: signature,
        securityToken: credentials.securityToken);
  }

  String _buildCanonicalizedResource(
      String resourcePath, Map<String, String> parameters) {
    if (parameters.isNotEmpty == true) {
      final queryString = _sortByLowerKey(parameters)
          .map((e) => '${e.key}=${e.value}')
          .join('&');
      return '$resourcePath?$queryString';
    }
    return resourcePath;
  }

  String _computeHmacSha1(String plaintext) {
    final digest = Hmac(sha1, utf8.encode(credentials.accessKeySecret))
        .convert(utf8.encode(plaintext));
    return base64.encode(digest.bytes);
  }

  List<MapEntry<String, String>> _sortByLowerKey(Map<String, String> map) {
    final lowerPairs = map.entries.map(
        (e) => MapEntry(e.key.toLowerCase().trim(), e.value.toString().trim()));
    return lowerPairs.toList()..sort((a, b) => a.key.compareTo(b.key));
  }

  String _requestTime() {
    initializeDateFormatting('en', null);
    final DateTime now = DateTime.now();
    final String string =
        DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_ISO').format(now.toUtc());
    return '$string GMT';
  }
}
