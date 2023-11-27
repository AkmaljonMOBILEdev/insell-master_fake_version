class AppValidator {
  // Form base validation
  final String? message;

  AppValidator({this.message});

  String? Function(String?) nameValidate = (String? value) {
    if (value == null || value.isEmpty) {
      return "Ism va familiyani kiriting";
    } else {
      return null;
    }
  };
  String? Function(String?) numberValidate = (String? value) {
    if (value == null || value.isEmpty) {
      return "Telefon raqamini kiriting";
    } else {
      return null;
    }
  };
  String? Function(String?) productNameValidate = (String? value) {
    if (value == null || value.isEmpty) {
      return "Maxsulot nomini kiriting";
    } else {
      return null;
    }
  };
  String? Function(String?) loginValidate = (String? value) {
    if (value == null || value.isEmpty) {
      return "Login kiriting";
    } else {
      return null;
    }
  };
  String? Function(String?) passwordValidate = (String? value) {
    if (value == null || value.isEmpty) {
      return "Parol kiriting";
    } else {
      return null;
    }
  };
  String? Function(String?) namedValidate = (String? value) {
    if (value == null || value.isEmpty) {
      return "Nomlanish kiriting";
    } else {
      return null;
    }
  };

  String? Function(String?) sumValidate = (String? value) {
    if (value == null || value.isEmpty) {
      return "Summa kiriting";
    } else {
      return null;
    }
  };

  String? Function(String?) regionValidate = (String? value) {
    if (value == null || value.isEmpty) {
      return "Regioni kiriting";
    } else {
      return null;
    }
  };

  String? Function(String?) validate = (String? value) {
    if (value == null || value.isEmpty) {
      return "Bo'sh bo'lmasin";
    } else {
      return null;
    }
  };
}
