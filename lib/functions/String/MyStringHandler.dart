
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

  static bool isHTMLValid(String s) {
    RegExp allowedChars = RegExp(r"^[^<>]*$");
    return allowedChars.hasMatch(s);
  }

  static bool isPasswordValid(String password) {

    if (password.length < 5) {
      return false;
    }

    bool containsDigit = RegExp(r'\d').hasMatch(password);
    bool containsSpecialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);
    return containsDigit && containsSpecialChar;
  }

  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+$');
    return emailRegex.hasMatch(email);
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