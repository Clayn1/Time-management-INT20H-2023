class HtmlTagsRemover {
  static String removeHtmlTags(String text) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    String parsedString = text.replaceAll(exp, '');
    return parsedString;
  }
}
