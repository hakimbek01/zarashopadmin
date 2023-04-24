class Product {
  String? content;
  List? imgUrls;
  String? id;
  String? name;
  String? category;
  String? date;
  int? buyCount;
  String? productOwner;
  bool removeVisible = false;
  bool? isAvailable;

  List<Map<String, dynamic>>? types;
  String? img;
  List? sizes;
  int? price;
  int? size;


  Product({this.types,this.buyCount,this.date,this.productOwner,this.content,this.category,this.id,this.name,this.imgUrls,this.isAvailable});

  Product.fromJson(Map<String, dynamic> json) {
    List<Map<String, dynamic>> m = List.from(json['types']);
    types = m;
    productOwner=json["productOwner"];
    date=json['date'];
    content=json['content'];
    imgUrls=json['imgUrls'];
    id=json['id'];
    name=json['name'];
    category=json['category'];
    isAvailable=json['isAvailable'];
    buyCount = json["buyCount"];
  }

  Map<String, dynamic> toJson() => {
    "buyCount":buyCount,
    "types":types,
    "productOwner":productOwner,
    "content":content,
    "date":date,
    "imgUrls":imgUrls,
    "id":id,
    "name":name,
    "category":category,
    "isAvailable":isAvailable
  };

}