class Validators {
  static String? validateMobile(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mobile number is required';
    }
    if (value.length != 10) {
      return 'Mobile number must be 10 digits';
    }
    return null;
  }
  
  static String? validateOTP(String? value) {
    if (value == null || value.isEmpty) {
      return 'OTP is required';
    }
    if (value.length != 6) {
      return 'OTP must be 6 digits';
    }
    return null;
  }

  static String? validateImei(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'IMEI number is required';
    }
    final clean = value.trim().replaceAll(RegExp(r'\D'), '');
    if (clean.length != 15) {
      return 'IMEI must be 15 digits';
    }
    return null;
  }
}
