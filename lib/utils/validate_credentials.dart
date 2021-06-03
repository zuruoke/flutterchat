bool validateCredentials(String email, String password) {
    if (password.length < 8) {
    return false;
  }

  var status = validateEmail(email);
  if (!status) {
    return false;
  }
  return true;
}

bool validateEmail(String email) {
  String p =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  RegExp regExp = RegExp(p);

  var status = regExp.hasMatch(email);
  return status;
}