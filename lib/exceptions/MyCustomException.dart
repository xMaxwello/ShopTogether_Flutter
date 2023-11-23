class MyCustomException implements Exception {

  final String message;
  final String keyword;

  MyCustomException(this.message, this.keyword);
}