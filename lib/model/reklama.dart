class Reklama {
  List? reklama;
  String? id;
  Reklama({this.reklama});

  Reklama.fromJson(Map<String, dynamic> json) {
    List<Map<String, dynamic>> m = List.from(json['reklama']);
    reklama = m;
    id = json['id'];
  }

  Map<String, dynamic> toJson() => {
    "reklama": reklama,
    "id":id,
  };
}