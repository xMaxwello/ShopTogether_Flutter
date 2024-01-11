
class MyStringHandler {

  static String truncateText(String text, int length) {
    if (text.length <= length) {
      return text;
    } else {
      return '${text.substring(0, length)}...';
    }
  }

  static String removeHtmlTags(String htmlString) {
    RegExp exp = RegExp(
      r"<[^>]*>",
      multiLine: true,
      caseSensitive: true,
    );
    return htmlString.replaceAll(exp, '');
  }

  ///TODO: Gucken ob das klappt wegen login
  static String validatePassword(String password) {
    RegExp disallowedChars = RegExp(r'[^\w\d!@#\$%^&*()_+]');
    if (disallowedChars.hasMatch(password)) {
      return password.replaceAll(disallowedChars, '');
    }
    return password;
  }
}