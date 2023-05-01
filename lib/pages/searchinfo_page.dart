import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zarashopadmin/pages/update_page.dart';
import '../model/product_model.dart';
import '../service/data_service.dart';

class SearchInfoPage extends StatefulWidget {
  final String? categoryName;
  const SearchInfoPage({Key? key, this.categoryName}) : super(key: key);

  @override
  State<SearchInfoPage> createState() => _SearchInfoPageState();
}

class _SearchInfoPageState extends State<SearchInfoPage> {

  List<Product> productList=[];
  List<String> categories = [];
  bool isRemoveCategory = false;
  bool isLoading = false;

  void getProductCategoryName() async {
    setState(() {
      isLoading = true;
    });

    await DataService.getCategoryProducts(widget.categoryName!).then((value) => {
      setState((){
        productList = value;
        isLoading = false;
      })
    });

    if (productList.isEmpty) {
      setState(() {
        isRemoveCategory = true;
      });
    } else {
      setState(() {
        isRemoveCategory = false;
      });
    }
  }


  @override
  void initState() {
    getProductCategoryName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: AppBar(
            iconTheme: const IconThemeData(
                color: Colors.black
            ),
            backgroundColor: Colors.white,
            title: Text(widget.categoryName!,style: const TextStyle(fontFamily: "Aladin",color: Colors.black,fontSize: 20),),
            actions: [
              IconButton(
                onPressed: () async {
                  if (isRemoveCategory) {
                    await RTDBService.deleteCategory(widget.categoryName!).then((value) {
                      Navigator.pop(context,true);
                    });
                  } else {
                    AwesomeDialog(
                        context: context,
                        title: "Ogohlantirish",
                        desc: "Oldin barcha mahsulotlarni o'chiring",
                        dialogType: DialogType.warning,
                        btnCancelOnPress:() {},
                        btnOkOnPress: () async {

                          setState(() {
                            isLoading = true;
                          });

                          await DataService.clearCategory(widget.categoryName!).then((value) {
                            setState(() {
                              productList.clear();
                              isRemoveCategory = true;
                            });
                          });

                          setState(() {
                            isLoading = false;
                          });
                        }
                    ).show();
                  }
                },
                icon: const Icon(Icons.delete,color: Colors.red,),
              )
            ],
          ),
          body: ListView(
            children: productList.map((e) {
              return itemOfCategoryProduct(e);
            }).toList(),
          ),
        ),
        isLoading?
        const Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ):
        const SizedBox()
      ],
    );
  }

  Widget itemOfCategoryProduct(Product product) {
    return widget.categoryName==product.category?
    GestureDetector(
      onTap: () async {
       await Navigator.push(context, MaterialPageRoute(builder: (context) => UpdatePage(product: product),)) ;
       setState(() {
         productList=[];
       });
       getProductCategoryName();
       },
      child: Container(
        height: MediaQuery.of(context).size.width/5,
        width: double.infinity,
        margin: const EdgeInsets.only(right: 10,left: 10,bottom: 10),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(color: Colors.grey,blurRadius: 2.5,offset: Offset(0,1)),
              BoxShadow(color: Colors.grey,blurRadius: 1,offset: Offset(0,-.51)),
            ]
        ),
        child: Row(
          children: [
            product.imgUrls!.isNotEmpty?
            CachedNetworkImage(
              width: 80,
              height: MediaQuery.of(context).size.width/5,
              fit: BoxFit.cover,
              imageUrl: product.imgUrls![0],
              placeholder: (context, url) => const Center(child: CircularProgressIndicator(),),
              errorWidget: (context, url, error) => const Center(child: Icon(Icons.highlight_remove,color: Colors.red,),),
              ):
            Image(
              height: MediaQuery.of(context).size.width/5,
              width: 80,
              fit: BoxFit.cover,
              image: const AssetImage("assets/images/placeholder.png"),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name!,style: const TextStyle(fontSize: 15,fontStyle: FontStyle.italic),overflow: TextOverflow.ellipsis,),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ):
    const SizedBox();
  }


}
