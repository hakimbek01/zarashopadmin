class Admin {
  String? fullName;
  String? uid;
  List placedProduct=[];
  List buyurtmalar=[];
  Admin({this.fullName,});

  Admin.fromJson(Map<String ,dynamic> json) {
    fullName=json['fullName'];
    placedProduct=json['placedProduct'];
    uid=json['uid'];
    buyurtmalar=json['buyurtmalar'];
  }

  Map<String,dynamic> toJson ()=>{
    "buyurtmalar":buyurtmalar,
    "fullName":fullName,
    "uid":uid,
    "placedProduct":placedProduct,
  };
}