import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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

class CreatePage extends StatefulWidget {
  const CreatePage({Key? key}) : super(key: key);

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final TextEditingController _name=TextEditingController();

  final TextEditingController _content=TextEditingController();
  final TextEditingController _createCategory=TextEditingController();

  String _category="Category tanlash";
  final List<Map<String, dynamic>> _imagesList=[];
  bool isLoading=false;
  List _imgURL = [];
  final ImagePicker _imagePicker=ImagePicker();
  bool typePrice=true;

  List<PopupMenuEntry<dynamic>> popupMenuItem = [];
  List categories = [];


  @override
  void dispose() {
    _name.dispose();
    _content.dispose();
    _createCategory.dispose();

    super.dispose();
  }

  void createPopupMenu() {
    popupMenuItem = [];
    for (var item in categories) {
      popupMenuItem.add(PopupMenuItem(
        onTap: () {
          setState(() {
            _category=item;
          });
        },
        child: Text(item),
      ));
    }
      popupMenuItem.add(
          PopupMenuItem(
            onTap: () async {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                AwesomeDialog(
                  context: context,
                  animType: AnimType.bottomSlide,
                  dialogType: DialogType.noHeader,
                  btnOkOnPress: () async {
                    setState(() {
                      if (_createCategory.text.isEmpty) return;
                      _category=_createCategory.text;
                      categories.add(_category);
                      createPopupMenu();
                      addCategory();
                    });
                  },
                  btnCancelOnPress: () {},
                  body: Column(
                    children: [
                      TextField(
                        controller: _createCategory,
                        decoration: const InputDecoration(
                          hintStyle: TextStyle(color: Colors.grey),
                          hintText: "Categoriya Yaratish"
                        ),
                      )
                    ],
                  ),
                ).show();
              });
            },
            child: Column(
              children: [
                Container(color: Colors.blue, width: double.infinity, height: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Category qo'shish",style: TextStyle(fontWeight: FontWeight.w700),),
                    const Icon(Icons.add)
                  ],
                )
              ],
            ),
          )
      );
  }

  @override
  void initState() {
    getCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            iconTheme:const IconThemeData(
              color: Colors.black,
            ),
            backgroundColor: Colors.white,
            title: const Text("Add Product",style: TextStyle(color: Colors.black),),
            actions: [
              IconButton(
                onPressed: () {
                  openGallery();
                },
                icon: const Icon(Icons.add),

              )
            ],
          ),
          body: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //images
                  _imagesList.isEmpty?
                  Container(
                    height: MediaQuery.of(context).size.width-70,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.grey,blurRadius: 3,offset: Offset(0,0))
                        ]
                    ),
                    child: const Image(
                      image: AssetImage("assets/images/placeholder.png"),
                      fit: BoxFit.cover,
                    ),
                  ):
                  Container(
                    height: MediaQuery.of(context).size.width-70,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black,width: 1)
                    ),
                    child: ListView(
                      physics: const PageScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      children: _imagesList.map((e) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(color: Colors.grey,blurRadius: 3,offset: Offset(0,0))
                              ]
                          ),
                          child: Stack(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  bool tekshir= false;

                                  List<Map<String,dynamic>> list = [
                                    {
                                      "img": e["img"],
                                      "types":[
                                        {
                                          "size":"",
                                          "price":""
                                        }
                                      ]
                                    }
                                  ];

                                  for (var i in e['types']) {
                                    for (var c in i.values) {
                                      if (c=="") {
                                        tekshir = true;
                                      }
                                    }
                                  }

                                  List? a;
                                  if (!tekshir) {
                                    List<Map<String, dynamic>> response = [];
                                    a = await Navigator.push(context, MaterialPageRoute(builder: (context) => SelectTypesPage(imgFILE: e['img'],types: e,)));
                                  } else {
                                    a = await Navigator.push(context, MaterialPageRoute(builder: (context) => SelectTypesPage(imgFILE: e['img'],types: {},)));
                                  }

                                  if (a!=null) {
                                    _imagesList[_imagesList.indexOf(e)]["types"]=a;
                                  } else{
                                    _imagesList[_imagesList.indexOf(e)]["types"]=[{"size": "","price":""}];
                                  }
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height-70,
                                  padding: const EdgeInsets.symmetric(horizontal: 2),
                                  child:
                                  (e["img"] is File) ?
                                  Image(
                                    image: FileImage(e["img"]),
                                    fit: BoxFit.cover,
                                  ) :
                                  const Image(
                                    image: AssetImage("assets/images/placeholder.png"),
                                    fit: BoxFit.cover,
                                  )
                                ),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      _imagesList.remove(e);
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(7),
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(20)
                                    ),
                                    child: const Icon(Icons.highlight_remove,color: Colors.white,),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  // product data
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        //product name
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(color: Colors.grey.shade300,offset: Offset(1,-1),blurRadius: 1),
                                BoxShadow(color: Colors.grey.shade300,offset: Offset(1,.51),blurRadius: 1)
                            ]
                          ),
                          child: TextField(
                            controller: _name,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              label: const Text("Name")
                            ),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        //product content,
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(color: Colors.grey.shade300,offset: Offset(1,-1),blurRadius: 1),
                                BoxShadow(color: Colors.grey.shade300,offset: Offset(1,.51),blurRadius: 1)
                              ]
                          ),
                          child: TextField(
                            controller: _content,
                            maxLines: 10,
                            minLines: 1,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                                label: const Text("Description")
                            ),
                          ),
                        ),

                        const SizedBox(height: 10,),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20,),
                  //product category
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(width: 1,color: Colors.blue)
                    ),
                    child: Center(
                      child: PopupMenuButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7),),
                        elevation: 3,
                        child: Text(_category,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                        itemBuilder: (context) => popupMenuItem,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  //create
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: MaterialButton(
                      color: Colors.blue,
                      minWidth: MediaQuery.of(context).size.width-20,
                      height: 38,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      onPressed: () => addProduct(),
                      child: Icon(CupertinoIcons.rocket_fill,color: Colors.white,size: 30,),
                    ),
                  ),
                  SizedBox(height: 50,)
                ],
              ),
            ),
          ),
        ),
        isLoading?
        Scaffold(
          backgroundColor: Colors.grey.withOpacity(.2),
          body: const Center(
            child: CircularProgressIndicator(),
          ),
        ):
        const SizedBox()
      ],
    );
  }

  void addCategory() async {
    await RTDBService.addCategory(categories);
  }

  void getCategory() async {
    await RTDBService.getCategory().then((value) => {
      setState((){
        categories=value;
      })
    });
    createPopupMenu();
  }

  void addProduct() async {

    String date = formatData();
    String name=_name.text;
    String content=_content.text;

    if (name.isEmpty || content.isEmpty || _category=="Category tanlash" || _imagesList.isEmpty) {
     Utils.fToast("Malumotlar to'liq kiritilmagan!");
     return;
    }

    setState(() {
      isLoading=true;
    });




    for (var a in _imagesList) {
      a['img'] = await StoreService.uploadImage(a['img']);
      _imgURL.add(a['img']);
    }

    _imagesList.removeWhere((element) =>(element["types"][0]["price"]=="") && element["types"].length == 1);


    Product product = Product(
      buyCount: 1,
      date: date,
      category: _category,
      name: name,
      content: content,
      imgUrls: _imgURL,
      isAvailable: true,
      productOwner: AuthService.currentUserId(),
      types: _imagesList,
    );

    await DataService.addProduct(product).then((value) => {
      addMyProduct(value!),
      Utils.fToast("Yangi mahsulot qo'shildi😀"),
      setState(() {
        isLoading=false;
      }),
      Navigator.pop(context,true),
    });
  }

  void addMyProduct(String id) async {
    Admin? admin=await DataService.loadAdmin();
    List myProducts=admin!.placedProduct;
    MyWork myWork=MyWork(id: id,date: DateTime.now().toString(),status: "create");
    myProducts.add(myWork.toJson());
    await DataService.updateAdmin(admin);
  }

  void openGallery() async {
    XFile? image=await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 30
    );
    setState(() {
      _imagesList.add({
        "img":File(image!.path),
        "types":[
          {
          "size": "",
          "price": ""
          }
        ]
      });
    });
  }

  String formatData() {
    List list = ["","Jan","Feb","Mart","Apr","Mai","Jun","July","Aug","Sept","Oct","Nov","Dec"];
    String day = DateTime.now().day.toString();
    String month = list[DateTime.now().month];
    String year = DateTime.now().year.toString();
    String hour = DateTime.now().hour.toString();
    String min = DateTime.now().minute.toString();
    return "$day $month $year $hour:$min";
  }
}
