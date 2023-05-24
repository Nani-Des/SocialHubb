class Lawyer {
  final String name;
  //final String emailID;
  final String gender;
  final List practicearea;
  final String state;
  final String date;
  final String number;
  final String chambers;

  Lawyer({
    required this.name,
    //required this.emailID,
    required this.gender,
    required this.practicearea,
    required this.state,
    required this.date,
    required this.number,
    required this.chambers,
  });

  Map<String, dynamic> toJson() => {
        "name": name,
        //"emailID": emailID,
        "gender": gender,
        "practicearea": practicearea,
        "state": state,
        "date": date,
        "number": number,
        "chambers": chambers,
      };

  static Lawyer fromJson(Map<String, dynamic> json) => Lawyer(
      name: json['name'].toString(),
      gender: json['gender'].toString(),
      practicearea: json['practicearea'],
      //emailID: json['emailID'],
      state: json['state'].toString(),
      date: json['date'].toString(),
      number: json['number'].toString(),
      chambers: json['chambers'].toString());
}
