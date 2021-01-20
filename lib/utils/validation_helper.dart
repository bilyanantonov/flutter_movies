class ValidationHelper {
  static String validateSearchText(String value) {
    if (value.length <= 0) {
      return "This field can not be empty";
    }
    return null;
  }
}
