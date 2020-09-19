class CustomValidasiEmail {
  static isEmail(String value) {
    RegExp regex =
    new RegExp(r"^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$");

    if (value.isEmpty) {
      return 'Email Tidak Valid';
    }
    return null;
  }
}