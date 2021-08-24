class Validator {
  String? checkObject(Object? value) {
    if (value != null) return value.toString();
    return null;
  }

  String? fieldEmptyValidator(String value) {
    if (value.trim().isEmpty) return 'Field is empty';
    return null;
  }

  String? fieldDoubleValidator(String value) {
    if (double.tryParse(value) == null) return 'Field is not number';
    return null;
  }
}
