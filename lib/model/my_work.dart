class MyWork{
  String? id;
  String? status;
  String? date;
  MyWork({this.id,this.date,this.status});

  MyWork.fromJson(Map<String, dynamic> json) {
    id=json['id'];
    status=json['status'];
    date=json['date'];
  }

  Map<String, dynamic> toJson()=>{
    "id":id,
    "status":status,
    "date":date
  };
}