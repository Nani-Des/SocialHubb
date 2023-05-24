String nameTrim(String name) {
  if (name.length == 0) {
    return "*";
  }
  List<String> names = name.trim().split(" ");

  String initials = "";
  names.forEach((item) {
    if (!(item == "")) {
      initials += item[0];
    }
  });

  return initials;
}
