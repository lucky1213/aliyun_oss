part of aliyun_oss;

var _http = _DioUtils.getInstance();

class _DioUtils {
  static Dio _instance;

  static Dio getInstance() {
    if (_instance == null) {
      _instance = Dio(BaseOptions(
        connectTimeout: 1000 * 30,
        receiveTimeout: 1000 * 30,
      ));
      
      _instance.interceptors.add(LogInterceptor(responseBody: true));
    }

    return _instance;
  }
}
