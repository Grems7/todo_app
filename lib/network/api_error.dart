class ApiError {
  final String message;
  final int? statuscode;

  ApiError({
    required this.message,this.statuscode
});
  @override
  String toString(){
    return 'error is : $message statuscode : $statuscode';
  }
}