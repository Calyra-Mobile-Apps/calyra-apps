class ServiceResponse<T> {
  final T? data;
  final String? message;
  final bool isSuccess;
  const ServiceResponse._({this.data, this.message, required this.isSuccess});
  factory ServiceResponse.success([T? data]) {
    return ServiceResponse._(data: data, isSuccess: true);
  }
  factory ServiceResponse.failure(String message) {
    return ServiceResponse._(message: message, isSuccess: false);
  }
}
