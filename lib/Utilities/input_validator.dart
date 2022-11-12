class InputValidator {
  final String? email;
  final String? password;
  final String? fullName;
  final String? confirmPassword;

  InputValidator(
      {this.email, this.password, this.confirmPassword, this.fullName});

  bool emailFieldIsEmpty() {
    if (email!.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  bool passwordFieldIsEmpty() {
    if (password!.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  bool fullNameIsEmpty() {
    if (fullName!.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  bool confirmPasswordIsEmpty() {
    if (confirmPassword!.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  bool passwordIsValid() {
    if (!passwordFieldIsEmpty() && password!.length > 8) {
      return true;
    } else {
      return false;
    }
  }

  bool emailIsValid() {
    if (!emailFieldIsEmpty() && email!.contains("@")) {
      return true;
    } else {
      return false;
    }
  }

  bool passwordsMatch() {
    if ((password == confirmPassword)) {
      return true;
    } else {
      return false;
    }
  }

  bool formIsValid() {
    if (passwordsMatch() && emailIsValid() && !fullNameIsEmpty()) {
      return true;
    } else {
      return false;
    }
  }

  bool loginFormIsValid() {
    if (passwordIsValid() && emailIsValid()) {
      return true;
    } else {
      return false;
    }
  }
}
