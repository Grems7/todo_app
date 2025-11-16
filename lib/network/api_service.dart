import 'package:dio/dio.dart';
import 'package:todo_getx/network/api_exception.dart';
import 'package:todo_getx/network/dio_client.dart';

class ApiService {
  final DioClient _dioClient = DioClient();

  //get
  Future<dynamic> get(String endPoint) async {
    try {
      final response = await _dioClient.dio.get(endPoint);
      return response.data;
    } on DioError catch (e) {
      return ApiException.handleError(e);
    }
  }

  //post
  Future<dynamic> post(String endPoint, Map<String, dynamic> body) async {
    try {
      final response = await _dioClient.dio.post(endPoint, data: body);
      return response.data;
    } on DioError catch (e) {
      return ApiException.handleError(e);
    }
  }

  //postforma

  Future<dynamic> postFormData(String endPoint, FormData formData) async {
    try {
      final response = await _dioClient.dio.post(
        endPoint,
        data: formData,
        options: Options(
          headers: {
            "Content-Type": "multipart/form-data",
          },
        ),
      );
      return response.data;
    } on DioError catch (e) {
      return ApiException.handleError(e);
    }
  }

  //put
  Future<dynamic> put(String endPoint, dynamic body) async {
    try {
      final response = await _dioClient.dio.put(endPoint, data: body);
      return response.data;
    } on DioError catch (e) {
      return ApiException.handleError(e);
    }
  }

  //delete
  Future<dynamic> delete(String endPoint, Map<String, dynamic>body) async {
    try {
      final response = await _dioClient.dio.delete(endPoint, data: body);
      return response.data;
    } on DioError catch (e) {
      return ApiException.handleError(e);
    }
  }

}