import 'package:dio/dio.dart';
class DioClient {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://localhost:8000/api",
      headers: {
        "User-Agent":"PostmanRuntime/7.37.3",
        "Accept":"*/*",
        "Accept-Encoding":"gzip, deflate, br",
        "Connection":"keep-alive"
      }

    ));
    DioClient(){
      _dio.interceptors.add(
          InterceptorsWrapper(
            onRequest: (options,handler){
              final token ='tokenname';
              if(token != null && token.isNotEmpty){
                options.headers['Authorization']= 'Baerer $token';
                return handler.next(options);
              }
            }
          )
      );
    }
    Dio get dio => _dio;
}