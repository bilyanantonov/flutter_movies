class ValidationHelper {
  static String validateSearchText(String value) {
    if (value.length <= 0) {
      return "Search must contain least 1 character";
    }
    return null;
  }
}
