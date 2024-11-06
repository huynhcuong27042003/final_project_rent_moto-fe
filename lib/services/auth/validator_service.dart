class ValidatorService {
  bool isValidPassword(String password) {
    // Kiểm tra password có nhiều hơn 8 ký tự
    if (password.length < 8) return false;

    // Kiểm tra có ít nhất 1 chữ hoa, 1 chữ thường, và 1 số
    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    bool hasDigits = password.contains(RegExp(r'[0-9]'));

    return hasUppercase && hasLowercase && hasDigits;
  }

  bool isValidEmail(String email) {
    // Biểu thức kiểm tra định dạng email
    String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    return RegExp(emailPattern).hasMatch(email);
  }

  bool isValidCode(String code) {
    // Kiểm tra code có đúng 6 ký tự
    if (code.length != 6) return false;

    // Kiểm tra có ít nhất 1 chữ và 1 số
    bool hasLetters = code.contains(RegExp(r'[A-Z]')); // Chỉ cho phép chữ hoa
    bool hasDigits = code.contains(RegExp(r'[0-9]'));

    // Kiểm tra tất cả chữ cái phải là chữ hoa
    bool allUppercase = !code.contains(RegExp(r'[a-z]'));

    return hasLetters && hasDigits && allUppercase;
  }
}
