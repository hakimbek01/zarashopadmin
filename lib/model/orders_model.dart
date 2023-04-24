class Orders {
  String? orderId;
  String? phoneNumber;
  String? adminUID;
  bool? accept;
  String? checkImage;
  String? comment;
  String? totalPrice;
  String? useruid;
  String? location;
  bool isVisiable = false;
  List<dynamic>? products;
  Orders({this.accept,this.orderId,this.location,this.useruid,this.products,this.totalPrice,this.comment,this.phoneNumber,this.adminUID,this.checkImage});

  Orders.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    location = json['location'];
    products = json['products'];
    useruid = json['useruid'];
    totalPrice = json['totalPrice'];
    accept = json['accept'];
    comment = json['comment'];
    checkImage = json['checkImage'];
    adminUID = json['adminUID'];
    phoneNumber = json["phoneNumber"];
    isVisiable = json["isVisiable"];
  }

  Map<String, dynamic> toJson() => {
    "isVisiable":isVisiable,
    "accept":accept,
    "orderId":orderId,
    "location":location,
    "products":products,
    "useruid":useruid,
    "totalPrice":totalPrice,
    "comment":comment,
    "checkImage":checkImage,
    "phoneNumber":phoneNumber,
  };
}