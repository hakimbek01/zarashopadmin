import 'dart:isolate';

import 'package:cloud_firestore/cloud_firestore.dart' hide Query;
import 'package:firebase_database/firebase_database.dart';
import 'package:zarashopadmin/service/store_service.dart';
import '../model/admin_model.dart';
import '../model/orders_model.dart';
import '../model/product_model.dart';
import '../model/reklama.dart';
import 'auth_service.dart';

class DataService {

  static final _firestore = FirebaseFirestore.instance;
  static String folderAdmin = "admin";
  static String folderProduct = "products";
  static String folderAdvertising = "reklama";
  static String docAdvertising = "reklamalar";
  static String docInFolderAdvertising = "to'plam";
  static String folderOrder = "orders";


  ///admins
  static Future storeAdmin(Admin admin) async {
    await _firestore.collection(folderAdmin).doc(admin.uid).set(admin.toJson());
  }

  static Future<Admin?> loadAdmin() async {
    String uid=AuthService.currentUserId();
    var value = await _firestore.collection(folderAdmin).doc(uid).get();
    Admin admin=Admin.fromJson(value.data()!);
    return admin;
  }

  static Future<List<Admin>> loadAllAdmin() async {
    List<Admin> admins=[];
    var value=await _firestore.collection(folderAdmin).get();
    for (var item in value.docs) {
      Admin admin=Admin.fromJson(item.data());
      admins.add(admin);
    }
    return admins;
  }

  static Future<Admin?> updateAdmin(Admin admin) async {
    String uid=AuthService.currentUserId();
    Admin? response;
    await _firestore.collection(folderAdmin).doc(uid).update(admin.toJson());
    await loadAdmin().then((value) {
      response = value;
    });
    return response;
  }


  /// product
  static Future<String?> addProduct(Product product) async {
    var doc = _firestore.collection(folderProduct).doc();
    product.id = doc.id;
    await doc.set(product.toJson());
    return product.id;
  }

  static List<Product> p = [];
  static List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = [];
  static int loadedProductsCount = 0;

  static Future<List<Product>> getProduct({bool first = false}) async {

    if (first) {
      p = [];
      docs = [];
      loadedProductsCount = 0;
    }

    if (docs.isEmpty) {
      final resivePort = ReceivePort();
      await Isolate.spawn(getFirstTenDocuments,resivePort.sendPort);
      resivePort.listen((message) {
        docs = message;
      });
      /// docs = await getFirstTenDocuments();
      for (var a in docs) {
        p.add(Product.fromJson(a.data()));
      }
      loadedProductsCount += docs.length;
    } else {
      if (productsCount > loadedProductsCount) {
        docs = await getNextTenDocuments(docs.last);
        for (var a in docs) {
          p.add(Product.fromJson(a.data()));
        }
        loadedProductsCount += docs.length;
      }
    }
    return p;
  }

  static int limit=20;
  static int productsCount = 0;

  static Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getFirstTenDocuments1() async {
    var docs = await _firestore.collection(folderProduct).get();
    productsCount = docs.size;
    var querySnapshot = await _firestore.collection(folderProduct).orderBy("name").limit(limit).get();
    return querySnapshot.docs;
  }

  static Future<void> getFirstTenDocuments(SendPort sendPort) async {
    var docs = await _firestore.collection(folderProduct).get();
    productsCount = docs.size;
    var querySnapshot = await _firestore.collection(folderProduct).orderBy("name").limit(limit).get();
    sendPort.send(querySnapshot.docs);
    sendPort.send(querySnapshot.docs);
    // return querySnapshot.docs;
  }

  static Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getNextTenDocuments(DocumentSnapshot lastDocument) async {
    var querySnapshot = await _firestore.collection(folderProduct).orderBy("name").startAfterDocument(lastDocument).limit(limit).get();
    return querySnapshot.docs;
  }


  static Future<List<Product>> getCategoryProducts(String categoryName) async {
    List<Product> list = [];

    var docs = await _firestore.collection("products").where("category", isEqualTo: categoryName).get();

    for (var a in docs.docs) {
      list.add(Product.fromJson(a.data()));
    }

    return list;
  }

  static Future<Map<String, int>> getStatistic() async {
    Map<String, int> p = {};
    List<String> category = await RTDBService.getCategory();

    for (var item in category) {
      var docs = await _firestore.collection("products").where("category", isEqualTo: item).get();
      int count = 0;
      for (var i in docs.docs) {
        Product product = Product.fromJson(i.data());
        count += product.buyCount!;
      }
      p.addAll({item : count});
    }
    var docs= await _firestore.collection(folderProduct).get();
    for (var a in docs.docs) {
      Product product = Product.fromJson(a.data());
      
    }
    return p;
  }

  static Future updateProduct(Product product) async {
    await _firestore.collection(folderProduct).doc(product.id).update(product.toJson());
  }

  static Future removeProduct(List ids,List imgProduct) async {
    if (imgProduct.isNotEmpty) {
      await StoreService.removeImage(imgProduct);
    }
    for (var id in ids) {
      await _firestore.collection(folderProduct).doc(id).delete();
    }
  }



  ///category
  static Future clearCategory(String category) async {
    var doc = await _firestore.collection(folderProduct).where("category",isEqualTo: category).get();
    for (var a in doc.docs) {
      await removeProduct([a.data()['id']], a.data()['imgUrls']);
    }
  }



  /// buyurtmalar
  static Future orderAcceptance(Orders orders) async {
    orders.accept = true;
    await _firestore.collection(folderOrder).doc(orders.orderId).update(orders.toJson());
    return orders;
  }

  static Future orderViewed(Orders orders) async {
    orders.isVisiable = true;
    await _firestore.collection(folderOrder).doc(orders.orderId).update(orders.toJson());
  }

  static Future orderCancellation(Orders orders) async {
    orders.accept = false;
    await _firestore.collection(folderOrder).doc(orders.orderId).update(orders.toJson());
    return orders;
  }


  ///reklama
  static Future addAdvertising(Reklama reklama) async {
    var docs =  _firestore.collection(folderAdvertising).doc(docAdvertising).collection(docInFolderAdvertising).doc();
    reklama.id = docs.id;
    await docs.set(reklama.toJson());
    return reklama.id;
  }

  static Future<String> getCurrentAdvertisingId() async {
    String? id;
    await _firestore.collection(folderAdvertising).doc("hozirgireklama").get().then((value) {
      id = value.data()!["id"];
    });
    return id!;
  }

  static Future<Reklama> getCurrentAdvertising(String id) async {
    Reklama? reklama;
    await _firestore.collection(folderAdvertising).doc(docAdvertising).collection(docInFolderAdvertising).doc(id).get().then((value) {
      reklama = Reklama.fromJson(value.data()!);
    });
    return reklama!;
  }

  static Future updateCurrentAdvertising(String id) async {
    await _firestore.collection(folderAdvertising).doc("hozirgireklama").update({"id":id});
  }

  static Future<List<Reklama>> getAdvertisingList() async {
    Reklama reklama = Reklama();
    List<Reklama> list = [];
    await _firestore.collection(folderAdvertising).doc(docAdvertising).collection(docInFolderAdvertising).get().then((value) {
      for (var a in value.docs) {
        list.add(Reklama.fromJson(a.data()));
      }
    });
    return list;
  }

  static Future removeAdvertising(String id, List images) async {

    await StoreService.removeImage(images);

    await _firestore.collection(folderAdvertising).doc(docAdvertising).collection(docInFolderAdvertising).doc(id).delete();
  }

}

class RTDBService{
  static final _database=FirebaseDatabase.instance.ref();

  static Future<Stream<DatabaseEvent>> addCategory(List category) async {
    Map<String, dynamic> map = {};
    for (int i = 0; i < category.length; i++) {
      map.addAll({'$i' : category[i]});
    }
    _database.child("category").update(map);
    return _database.onChildAdded;
  }

  static Future<List<String>> getCategory() async {
    List<String> items = [];
    Query query = _database.ref.child("category");
    DatabaseEvent event = await query.once();
    var snapshot = event.snapshot;
    int index = 0;
    for (var a in snapshot.children) {
      items.add(a.value.toString());
      index+=1;
    }
    return items;
  }

  static Future<List?> deleteCategory(String category) async {
    print(category);
    List<String> list = [];

    await getCategory().then((value) {
      list = value;
    });

    list.remove(category);

    _database.ref.child("category").set(list);

    return list;
  }
}