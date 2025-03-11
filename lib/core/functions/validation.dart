validtion(String val, int min, int max) {
  if (val.isEmpty) {
    return 'حقل فارغ';
  } else {
    if (val.length < min) {
      return "أقل طول هو $min";
    }

    if (val.length > max) {
      return "أكثر طول هو $max";
    }
  }
}

emptyValidation(String val) {
  if (val.isEmpty) {
    return 'الحقل فارغ';
  }
}

emptyDateValidation(DateTime? val) {
  if (val == null) {
    return 'الحقل فارغ';
  }
}
