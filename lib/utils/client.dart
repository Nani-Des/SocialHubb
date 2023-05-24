class Client {
  final String name;
  final String state;
  final String date;
  final String number;

  Client({
    required this.name,
    required this.state,
    required this.date,
    required this.number,
  });

  Map<String, dynamic> toJson() => {
        "name": name,
        "state": state,
        "date": date,
        "number": number,
      };

  static Client fromJson(Map<String, dynamic> json) => Client(
        name: json['name'],
        state: json['state'],
        date: json['date'],
        number: json['number'],
      );
}
