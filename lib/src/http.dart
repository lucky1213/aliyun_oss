part of aliyun_oss_flutter;

var _http = _DioUtils.getInstance();

class _DioUtils {
  static Dio getInstance() {
    if (_instance == null) {
      _instance = Dio(BaseOptions(
        connectTimeout: const Duration(milliseconds: 1000 * 30),
        receiveTimeout: const Duration(milliseconds: 1000 * 30),
      ));

      _instance!.interceptors.add(LogInterceptor(responseBody: true));
    }

    return _instance!;
  }

  static Dio? _instance;
}
// ignore: use_late_for_private_fields_and_variables
