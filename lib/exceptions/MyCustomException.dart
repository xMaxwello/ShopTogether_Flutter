class MyCustomException implements Exception {

  final String message;
  final String keywords;

  MyCustomException(this.message, this.keywords);
}