import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zarashopadmin/pages/select_types.dart';
import '../model/admin_model.dart';
import '../model/my_work.dart';
import '../model/product_model.dart';
import '../service/auth_service.dart';
import '../service/data_service.dart';
import '../service/store_service.dart';
import '../service/utils_service.dart';

class UpdatePage extends StatefulWidget {
  final Product? product;
  const UpdatePage({Key? key, this.product}) : super(key: key);

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  Product? product;

  final TextEditingController _content = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _createCategory = TextEditingController();

  String _category = "Kiyimlar";
  bool isAvailable = false;
  List<PopupMenuEntry<dynamic>> popupMenuItem = [];
  List<String> categories = [];
  bool loadingImage = false;
  bool isLoading = false;
  List imgUrls = [];
  List newImages = [];
  List fileImages = [];
  List deleteImages = [];
  List<Map<String, dynamic>>? types;
  final ImagePicker _imagePicker = ImagePicker();
  int currentImageIndex = 1;

  @override
  void initState() {
    getCategory();
    types = widget.product!.types;
    isAvailable = widget.product!.isAvailable!;
    _content.text = widget.product!.content!.toString();
    _name.text = widget.product!.name!.toString();

    _category = widget.product!.category!;
    imgUrls = List.from(widget.product!.imgUrls!);
    newImages = List.from(imgUrls);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.black),
            elevation: 0,
            backgroundColor: Colors.white,
            title: const Text(
              "Mahsulot Sozlamalari",
              style: TextStyle(color: Colors.black),
            ),
          ),
          body: SingleChildScrollView(
            child: Stack(
              children: [
                // images
                Container(
                  height: MediaQuery.of(context).size.width - 70,
                  width: MediaQuery.of(context).size.width,
                  child: newImages.isNotEmpty
                      ? Swiper(
                          onIndexChanged: (value) {
                            setState(() {
                              currentImageIndex = value + 1;
                            });
                          },
                          pagination: const SwiperPagination(),
                          itemCount: newImages.length,
                          itemBuilder: (context, index) {
                            return Stack(
                                children: [
                              GestureDetector(
                                onTap: () async {
                                  List<Map<String, dynamic>> sizeAndPriceList =
                                      [];
                                  Map<String, dynamic> map = {};

                                  if (newImages[index] is File) {
                                    for (var a = 0; types!.length > a; a++) {
                                      if (newImages[index] ==
                                          types![a]['img']) {
                                        map = types![a];
                                        break;
                                      }
                                    }
                                    sizeAndPriceList = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SelectTypesPage(
                                            imgFILE: newImages[index],
                                            types: map,
                                          ),
                                        ));

                                    if (sizeAndPriceList.isNotEmpty) {
                                      for (var i = 0; types!.length > i; i++) {
                                        if (types![i]['img'] ==
                                            newImages[index]) {
                                          types![i]['types'] = sizeAndPriceList;
                                          print("Yangilandi");
                                        } else {
                                          types![i]["types"] = sizeAndPriceList;
                                          print("Yangi qo'shildi");
                                        }
                                      }
                                    }
                                  } else {
                                    for (var a = 0; types!.length > a; a++) {
                                      if (newImages[index] ==
                                          types![a]["img"]) {
                                        map = types![a];
                                      }
                                    }

                                    List<Map<String, dynamic>> response = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SelectTypesPage(
                                                imgURL: newImages[index],
                                                types: map,
                                              ),
                                            ));

                                    if (response.isNotEmpty) {
                                      for (var i = 0; types!.length > i; i++) {
                                        if (types![i]['img'] ==
                                            newImages[index]) {
                                          types![i]['types'] = response;
                                        } else {
                                          types?.add({
                                            "img": newImages[index],
                                            "types": response,
                                          });
                                        }
                                      }
                                    }
                                  }
                                },
                                child: (newImages[index]) is File
                                    ? Stack(
                                        children: [
                                          Image(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            fit: BoxFit.cover,
                                            image: FileImage(newImages[index]),
                                          ),
                                          loadingImage
                                              ? const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                )
                                              : const SizedBox()
                                        ],
                                      )
                                    : CachedNetworkImage(
                                      height:
                                          MediaQuery.of(context).size.width,
                                      width:
                                          MediaQuery.of(context).size.width,
                                      imageUrl: newImages[index],
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Center(
                                        child: Icon(
                                          Icons.highlight_remove,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: CircleAvatar(
                                    backgroundColor:
                                        Colors.white.withOpacity(.6),
                                    radius: 20,
                                    child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          deleteImages.add(newImages[index]);
                                          imgUrls.remove(newImages[index]);
                                          newImages.remove(newImages[index]);
                                        });
                                      },
                                      icon: const Icon(
                                        CupertinoIcons.delete,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 30),
                                  child: CircleAvatar(
                                    backgroundColor:
                                        Colors.white.withOpacity(.6),
                                    radius: 20,
                                    child: Text(
                                        "$currentImageIndex/${newImages.length}"),
                                  ),
                                ),
                              ),
                            ]
                            );
                          }
                        )
                      : Stack(
                          children: [
                            const Center(
                              child: Image(
                                fit: BoxFit.cover,
                                image:
                                AssetImage("assets/images/placeholder.png"),
                              ),
                            ),
                            loadingImage
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : const SizedBox()
                          ],
                        ),
                ),
                //bottom
                Container(
                  decoration:  BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                          topLeft: Radius.circular(30)),
                    boxShadow: [
                      BoxShadow(color: Colors.grey,offset: Offset(0, -1),blurRadius: 2,)
                    ]
                  ),
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.width - 90),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      // product info
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            //open images
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          const BoxShadow(
                                            offset: Offset(0, 1),
                                            blurRadius: 1.6,
                                            color: Colors.grey,
                                          )
                                        ]),
                                    child: ListTile(
                                      onTap: () {
                                        openGallery();
                                      },
                                      title: Text(
                                        "Open Gallery",
                                        style: TextStyle(
                                            color: Colors.grey.shade700),
                                      ),
                                      leading: const Icon(Icons.image_outlined),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 17,
                            ),
                            // product launch
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              width: double.infinity,
                              height: 45,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  border: Border.all(
                                      color: Colors.lightBlueAccent,
                                      width: 1.3)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    isAvailable
                                        ? "Sotuvda"
                                        : "Sotuvdan chiqarilgan",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  Switch(
                                    value: isAvailable,
                                    onChanged: (value) {
                                      setState(() {
                                        isAvailable = value;
                                      });
                                    },
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            //product name
                            TextField(
                              controller: _name,
                              maxLines: 3,
                              minLines: 2,
                              decoration: const InputDecoration(label: Text("Name")),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            //product content,
                            TextField(
                              controller: _content,
                              maxLines: 4,
                              minLines: 2,
                              decoration:
                                  const InputDecoration(label: Text("Description")),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            //product price
                          ],
                        ),
                      ),
                      //category
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(width: 1, color: Colors.blue)),
                        child: Center(
                          child: PopupMenuButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                            ),
                            elevation: 3,
                            child: Text(
                              _category,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            itemBuilder: (context) {
                              return popupMenuItem;
                            },
                          ),
                        ),
                      ),
                      MaterialButton(
                        color: Colors.blue,
                        minWidth: MediaQuery.of(context).size.width - 20,
                        height: 38,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        onPressed: () => updateProductInfo(),
                        child: const Text("Yangilash",style: TextStyle(color: Colors.white),),
                      ),
                      const SizedBox(
                        height: 30,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        isLoading
            ? const Scaffold(
                backgroundColor: Colors.transparent,
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : const SizedBox()
      ],
    );
  }

  Future<void> getCategory() async {
    await RTDBService.getCategory().then((value) => {
          setState(() {
            categories = value;
            createPopupMenu();
          })
        });
  }

  void updateProductInfo() async {
    print("Update boshlandi");

    setState(() {
      isLoading = true;
    });

    await StoreService.removeImage(deleteImages);

    for (var i = 0; types!.length > i; i++) {
      if (!(types![i]['img'].toString().startsWith("https:"))) {
        String path = types![i]['img'].toString().split('File: ').last;
        path = path.split("'")[1];
        await StoreService.uploadImage(File(path)).then((value) {
          types![i]['img'] = value;
          imgUrls.add(value);
        });
      }
    }

    Product product = Product(
        date: widget.product!.date,
        isAvailable: isAvailable,
        imgUrls: imgUrls,
        content: _content.text,
        name: _name.text,
        id: widget.product!.id,
        types: types,
        category: widget.product!.category,
        productOwner: AuthService.currentUserId(),
        buyCount: 1);

    await DataService.updateProduct(product);
    Utils.fToast("Malumotlar o'zgartirildi");
    setState(() {
      isLoading = false;
    });
    Admin? admin = await DataService.loadAdmin();
    List myProducts = admin!.placedProduct;
    MyWork myWork = MyWork(
        id: product.id, date: DateTime.now().toString(), status: "update");
    myProducts.add(myWork.toJson());
    await DataService.updateAdmin(admin);

    print("Update tugadi");
  }

  void createPopupMenu() {
    popupMenuItem = [];
    for (var item in categories) {
      popupMenuItem.add(PopupMenuItem(
        onTap: () {
          setState(() {
            _category = item;
          });
        },
        child: Text(item),
      ));
    }
  }

  void openGallery() async {

    XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery, imageQuality: 30);
    setState(() {
      newImages.add(File(image!.path));
      types!.add({
        "img": File(image.path),
        "types": [
          {"size": "", "price": ""}
        ]
      });
    });

    fileImages.add(File(image!.path));


  }
}
