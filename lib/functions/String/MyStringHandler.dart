
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

  static String breakString(String input, int maxLength) {
    StringBuffer result = StringBuffer();

    for (int i = 0; i < input.length; i += maxLength) {
      int end = (i + maxLength < input.length) ? i + maxLength : input.length;
      result.write(input.substring(i, end));

      if (end < input.length) {
        result.write('\n');
      }
    }

    return result.toString();
  }
}