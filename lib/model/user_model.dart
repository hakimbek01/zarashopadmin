class Users {
  String? Name;
  String? LastName;
  String? Gmail;
  String? uid;
  String? phoneNumber;
  String? productId;

  Users({this.Gmail,this.Name,this.productId,this.LastName,this.phoneNumber,this.uid});

  Users.fromJson(Map<String ,dynamic> json) {
    phoneNumber=json['phoneNumber'];
    productId=json['productId'];
    Name=json['Name'];
    LastName=json['LastName'];
    Gmail=json['Gmail'];
    uid=json['uid'];
  }

  Map<String,dynamic> toJson ()=>{
    "productId":productId,
    "phoneNumber":phoneNumber,
    "Name":Name,
    "LastName":LastName,
    "Gmail":Gmail,
    "uid":uid,
  };
}