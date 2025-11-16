import 'package:dio/dio.dart';
import 'package:todo_getx/network/api_error.dart';

class ApiException{
  static ApiError handleError(DioError error){
    switch (error.type){
      case DioErrorType.connectionTimeout :
        return ApiError(message: 'Bad connexion');
      case DioErrorType.badResponse :
        return ApiError(message: error.toString());
      default:
        return ApiError(message: "something went wrong ");
    }
  }
}