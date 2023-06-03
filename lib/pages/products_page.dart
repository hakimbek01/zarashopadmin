import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zarashopadmin/pages/search_page.dart';
import 'package:zarashopadmin/pages/update_page.dart';
import '../model/admin_model.dart';
import '../model/my_work.dart';
import '../model/product_model.dart';
import '../service/data_service.dart';
import '../service/utils_service.dart';
import 'category_page.dart';


class ProductsPage extends StatefulWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {

  List<Product> items=[];

  String appBarTitle="Mahsulotlar";
  bool isSeries=true;
  bool visiableProduct=true;
  bool remove=false;
  bool removeVisiable = false;
  bool delCategory = false;
  bool delVisiable=false;
  int delProductCount=0;
  List delProductsId=[];
  bool isLoading=false;
  List<dynamic> delUrlList=[];

  @override
  void initState() {
    getProducts(false);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            iconTheme: const IconThemeData(
                color: Colors.black54
            ),
            backgroundColor: delVisiable? Colors.grey.shade300: Colors.white,
            title: delVisiable?
            Text(delProductCount.toString(),style: const TextStyle(color: Colors.black54),):
            PopupMenuButton(
              child: Row(
                children: [
                  Text(appBarTitle,style: const TextStyle(color: Colors.black),),
                  const SizedBox(width: 5,),
                  const Icon(CupertinoIcons.chevron_down,)
                ],
              ),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    child: const Text("Mahsulotlar"),
                    onTap: (){
                      setState(() {
                        appBarTitle="Mahsulotlar";
                        visiableProduct=true;
                        isSeries=true;
                      });
                      getProducts(false);
                    },
                  ),
                  PopupMenuItem(
                    child: const Text("Category"),
                    onTap: (){
                      setState(() {
                        appBarTitle="Category";
                        visiableProduct=false;
                        isSeries=false;
                      });
                    },
                  )
                ];
              },
            ),
            actions: [
              visiableProduct && !delVisiable?
              GestureDetector(
                onTap: (){
                  setState(() {
                    isSeries=!isSeries;
                  });
                },
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchPage(),));
                      },
                      icon: const Icon(Icons.search),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: isSeries?
                      const Icon(CupertinoIcons.decrease_indent,size: 30,):
                      const Icon(CupertinoIcons.doc_append,size: 30,),
                    )
                  ],
                ),
              ):
              const SizedBox(),

              delVisiable?
              Row(
                children: [
                  IconButton(
                    onPressed: (){
                      setState(() {
                        delVisiable=false;
                        delProductCount=0;
                        delProductsId=[];
                        delUrlList=[];
                      });
                    },
                    icon: const Icon(Icons.close,color: Colors.red,),
                  ),
                  IconButton(
                    onPressed: () async {
                      if (delProductCount!=0) {
                        bool yes= await Utils.commonDialog(context, "Mahsulotlarni o'chirish", "Haqiqatdan bu mahsulotlarni o'chirasizmi?", "HA", "Yo'q");
                        if (yes) {
                          setState(() {
                            isLoading=true;
                          });
                          delMoreProducts(delProductsId,delUrlList);
                        }
                      }
                    },
                    icon: const Icon(Icons.check,color: Colors.green,),
                  )
                ],
              ):
              const SizedBox()
            ],
          ),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                await getProducts(true);
              },
              child: Column(
                children: [
                  delCategory?
                  Container(
                    width: double.infinity,
                    height: 30,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    color: Colors.black.withOpacity(.8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Iltimos ma'lumotlarni yangilang",style: TextStyle(color: Colors.white),),
                        InkWell(
                          onTap: () {
                            getProducts(true);
                            setState(() {
                              delCategory = false;
                            });
                          },
                          child: Text("Yangilash",style: TextStyle(color: Colors.blue),),
                        )
                      ],
                    ),
                  ):
                  SizedBox(),
                  const SizedBox(height: 10,),
                  //data
                  Expanded(
                    child: visiableProduct?
                    //products
                    ListView(
                      children: [
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: isSeries?2:1,
                          childAspectRatio: isSeries?2/2.7:5.5/1.8,
                          mainAxisSpacing: 10,
                          children: items.map((e) {
                            /*delVisiable==false?
                            e.removeVisible=false:true;
                            return delVisiable?
                            itemDelProduct(e):
                            itemOfProduct2(e);*/
                            return isSeries?
                            itemOfProduct2(e):
                            itemOfProduct1(e);
                          }).toList(),
                        ),
                        !delVisiable?
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: MaterialButton(
                            onPressed: () {
                              getProducts(false);
                            },
                            height: 40,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            color: Colors.blue,
                            child: const Text("Yana", style: TextStyle(color: Colors.white,fontSize: 16),),
                          ),
                        ):
                        SizedBox()
                      ],
                    ):
                    //categories
                    CategoryPage(),
                  ),

                ],
              ),
            ),
          ),
        ),
        isLoading?
        Scaffold(
          backgroundColor: Colors.grey.withOpacity(.4),
          body: const Center(
            child: CircularProgressIndicator(),
          ),
        ):
        const SizedBox()
      ],
    );
  }


  Widget itemOfProduct2(Product product) {
    // removeVisiable==false?
    // product.removeVisible=false:true;
    // return removeVisiable?
    // //o'chirishi hohlanganproductla
    // InkWell(
    //   onTap: () async {
    //
    //     product.removeVisible = !(product.removeVisible);
    //
    //
    //     if (product.removeVisible) {
    //       setState(() {
    //         removeProductCount++;
    //       });
    //
    //       for (var a in product.imgUrls!) {
    //
    //         removeImgUrlList.add(a);
    //       }
    //       removeProductsId.add(product.id);
    //
    //     } else {
    //       setState(() {
    //         removeProductCount--;
    //         for(var a in product.imgUrls!) {
    //           removeImgUrlList.remove(a);
    //         }
    //         removeProductsId.remove(product.id);
    //       });
    //     }
    //
    //   },
    //   child: isSeries?
    //   Container(
    //     margin: const EdgeInsets.symmetric(horizontal: 10),
    //     clipBehavior: Clip.hardEdge,
    //     width: double.infinity,
    //     decoration: BoxDecoration(
    //         border: Border.all(width: 1.3,color: Colors.red),
    //         borderRadius: BorderRadius.circular(20)
    //     ),
    //     child: Stack(
    //       children: [
    //         Column(
    //           children: [
    //             Expanded(
    //               child: product.imgUrls!.isNotEmpty?
    //               Swiper(
    //                 itemCount: product.imgUrls!.length,
    //                 itemBuilder: (context, index) {
    //                   return CachedNetworkImage(
    //                     imageUrl: product.imgUrls![index],
    //                     fit: BoxFit.cover,
    //                     placeholder: (context, url) => Center(
    //                       child: Column(
    //                         mainAxisAlignment: MainAxisAlignment.center,
    //                         children: const [
    //                           CircularProgressIndicator(),
    //                           Text("Yuklnamoqda...",style: TextStyle(fontSize: 12),)
    //                         ],
    //                       ),
    //                     ),
    //                     errorWidget: (context, url, error) => Center(
    //                       child: Column(
    //                         mainAxisAlignment: MainAxisAlignment.center,
    //                         children: const [
    //                           Icon(Icons.highlight_remove,color: Colors.red,),
    //                           Text("Xatolik yuz berdi!",style: TextStyle(fontSize: 12),)
    //                         ],
    //                       ),
    //                     ),
    //                   );
    //                 },
    //               ):
    //               const Image(
    //                 image: AssetImage("assets/images/placeholder.png"),
    //               ),
    //             ),
    //             const SizedBox(height: 5,),
    //             Padding(
    //               padding: const EdgeInsets.all(8),
    //               child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                     children: [
    //                       Expanded(child: Text(product.name!,maxLines: 1,style: const TextStyle(overflow: TextOverflow.ellipsis,color: Colors.red,fontWeight: FontWeight.bold),)),
    //                     ],
    //                   ),
    //                   Text(product.content!,maxLines: 3,textAlign: TextAlign.left,overflow: TextOverflow.ellipsis)
    //                 ],
    //               ),
    //             )
    //           ],
    //         ),
    //         product.removeVisible?
    //         Align(
    //           alignment: Alignment.topRight,
    //           child: Container(
    //             padding: const EdgeInsets.all(1),
    //             decoration: const BoxDecoration(
    //                 color: Colors.green,
    //                 borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),topRight: Radius.circular(19))
    //             ),
    //             child: Icon(Icons.delete,color: Colors.white.withOpacity(.9),),
    //           ),
    //         )
    //             :const SizedBox(),
    //       ],
    //     ),
    //   ):
    //   Container(
    //     margin: const EdgeInsets.symmetric(horizontal: 10),
    //     clipBehavior: Clip.hardEdge,
    //     width: double.infinity,
    //     decoration: BoxDecoration(
    //         color: Colors.grey.shade100,
    //         border: Border.all(width: 1,color: Colors.red),
    //         borderRadius: BorderRadius.circular(10)
    //     ),
    //     child: Row(
    //       children: [
    //         Expanded(
    //           child: Container(
    //             width: 100,
    //             child: product.imgUrls!.isNotEmpty?
    //             Swiper(
    //               itemCount: product.imgUrls!.length,
    //               itemBuilder: (context, index) {
    //                 return CachedNetworkImage(
    //                   imageUrl: product.imgUrls![index],
    //                   fit: BoxFit.cover,
    //                   placeholder: (context, url) => Center(
    //                     child: Column(
    //                       mainAxisAlignment: MainAxisAlignment.center,
    //                       children: const [
    //                         CircularProgressIndicator(),
    //                         Text("Yuklnamoqda...",style: TextStyle(fontSize: 12),)
    //                       ],
    //                     ),
    //                   ),
    //                   errorWidget: (context, url, error) => Center(
    //                     child: Column(
    //                       mainAxisAlignment: MainAxisAlignment.center,
    //                       children: const [
    //                         Icon(Icons.highlight_remove,color: Colors.red,),
    //                         Text("Xatolik yuz berdi!",style: TextStyle(fontSize: 12),)
    //                       ],
    //                     ),
    //                   ),
    //                 );
    //               },
    //             ):
    //             const Image(
    //               fit: BoxFit.cover,
    //               image: AssetImage("assets/images/placeholder.png"),
    //             ),
    //           ),
    //         ),
    //         Expanded(
    //           child: Padding(
    //             padding: const EdgeInsets.all(8),
    //             child: Column(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Text(product.name!,maxLines: 1,style: const TextStyle(overflow: TextOverflow.ellipsis,color: Colors.red,fontWeight: FontWeight.bold),),
    //               ],
    //             ),
    //           ),
    //         ),
    //         Expanded(
    //           child: Padding(
    //             padding: const EdgeInsets.all(8),
    //             child: Align(
    //                 alignment: Alignment.topLeft,
    //                 child: Text(product.content!,maxLines: 3,style: const TextStyle(color: Colors.black54,overflow: TextOverflow.ellipsis),)),
    //           ),
    //         ),
    //         product.removeVisible?
    //         Align(
    //           alignment: Alignment.topRight,
    //           child: Container(
    //             padding: const EdgeInsets.all(1),
    //             decoration: const BoxDecoration(
    //                 color: Colors.green,
    //                 borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),topRight: Radius.circular(10))
    //             ),
    //             child: Icon(Icons.delete,color: Colors.white.withOpacity(.9),),
    //           ),
    //         )
    //             :const SizedBox(),
    //       ],
    //     ),
    //   ),
    // ):
    delVisiable == false?product.removeVisible = false:true;
    return InkWell(
      onLongPress: () {
        setState(() {
          delVisiable=true;
        });
      },
      onTap: () async{

        if (!delVisiable) {
          delCategory = await Navigator.push(context, CupertinoPageRoute(builder: (context) => UpdatePage(product: product),));
        }

        product.removeVisible = !(product.removeVisible);

        if (delVisiable) {
          if (product.removeVisible) {
            for (var a in product.imgUrls!) {
              delUrlList.add(a);
            }
            delProductsId.add(product.id);
            setState(() {
              delProductCount=delProductsId.length;
            });
          } else {
            setState(() {
              for(var a in product.imgUrls!) {
                delUrlList.remove(a);
              }
              delProductsId.remove(product.id);
              delProductCount=delProductsId.length;
            });
          }
        }

        print(delProductsId);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: product.removeVisible?Border.all(color: Colors.red,width: 2):Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(20)
        ),
        margin: const EdgeInsets.only(left: 10,right: 10,bottom: 5),
        width: double.infinity,
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child:  product.imgUrls!.isNotEmpty?
                      FadeInImage(
                        width: double.infinity,
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(product.imgUrls![0]),
                        placeholder: const AssetImage("assets/images/img_1.png"),
                        fadeInDuration: const Duration(milliseconds: 100),
                        fadeOutDuration: const Duration(milliseconds: 100),
                      ):
                      const Image(
                        image: AssetImage("assets/images/placeholder.png"),
                      ),
                    )
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                          alignment: Alignment.topLeft,
                          child: Text(product.name!,maxLines: 1,style: const TextStyle(overflow: TextOverflow.ellipsis,color: Colors.black,fontWeight: FontWeight.bold))
                      ),
                      Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(product.content!,maxLines: 1,textAlign: TextAlign.left,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.grey.shade600),)
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      )
    );
  }

  Widget itemOfProduct1(Product product) {
    return const SizedBox()/*InkWell(
      onLongPress: () {
        setState(() {
          delVisiable=true;
        });
      },
      onTap: () async{
        delCategory = await Navigator.push(context, CupertinoPageRoute(builder: (context) => UpdatePage(product: product),));
      },
      child: // 1 qator bo'lib chiqishi
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        clipBehavior: Clip.hardEdge,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(color: Colors.grey.withOpacity(.2),offset: const Offset(0,0),blurRadius: 3),
              BoxShadow(color: Colors.grey.withOpacity(.4),offset: const Offset(0,2),blurRadius: 3),
            ]
        ),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              width: 100,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: product.imgUrls!.isNotEmpty?
              Swiper(
                itemCount: product.imgUrls!.length,
                itemBuilder: (context, index) {
                  return CachedNetworkImage(
                    imageUrl: product.imgUrls![index],
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CircularProgressIndicator(),
                          Text("Yuklnamoqda...",style: TextStyle(fontSize: 12),)
                        ],
                      ),
                    ),
                    errorWidget: (context, url, error) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.highlight_remove,color: Colors.red,),
                          Text("Xatolik yuz berdi!",style: TextStyle(fontSize: 12),)
                        ],
                      ),
                    ),
                  );
                },
              ):
              const Image(
                fit: BoxFit.cover,
                image: AssetImage("assets/images/placeholder.png"),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  const SizedBox(height: 10,),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(product.name!,maxLines: 1,style: const TextStyle(overflow: TextOverflow.ellipsis,color: Colors.black,fontWeight: FontWeight.bold),),
                  ),
                  const SizedBox(height: 5,),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(product.content!,maxLines: 4,style: const TextStyle(color: Colors.black54,overflow: TextOverflow.ellipsis),)),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () async {
                  cautionDialog(product.id!,product.imgUrls!);
                },
                icon: const Icon(Icons.delete,color: Colors.pinkAccent,),
              ),
            )
          ],
        ),
      ),
    )*/;
  }

  Widget itemDelProduct(Product product) {
    return const SizedBox()/*InkWell(
      onTap: () async {

        product.removeVisible = !(product.removeVisible);


        if (product.removeVisible) {
          setState(() {
            delProductCount++;
          });
          for (var a in product.imgUrls!) {
            delUrlList.add(a);
          }
          delProductsId.add(product.id);

        } else {
          setState(() {
            delProductCount--;
            for(var a in product.imgUrls!) {
              delUrlList.remove(a);
            }
            delProductsId.remove(product.id);
          });
        }
      },
      child: isSeries?
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        clipBehavior: Clip.hardEdge,
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(width: 1.3,color: Colors.red),
            borderRadius: BorderRadius.circular(20)
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: product.imgUrls!.isNotEmpty?
                  Swiper(
                    itemCount: product.imgUrls!.length,
                    itemBuilder: (context, index) {
                      return CachedNetworkImage(
                        imageUrl: product.imgUrls![index],
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              CircularProgressIndicator(),
                              Text("Yuklnamoqda...",style: TextStyle(fontSize: 12),)
                            ],
                          ),
                        ),
                        errorWidget: (context, url, error) => Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.highlight_remove,color: Colors.red,),
                              Text("Xatolik yuz berdi!",style: TextStyle(fontSize: 12),)
                            ],
                          ),
                        ),
                      );
                    },
                  ):
                  const Image(
                    image: AssetImage("assets/images/placeholder.png"),
                  ),
                ),
                const SizedBox(height: 5,),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Text(product.name!,maxLines: 1,style: const TextStyle(overflow: TextOverflow.ellipsis,color: Colors.red,fontWeight: FontWeight.bold),)),
                        ],
                      ),
                      Text(product.content!,maxLines: 3,textAlign: TextAlign.left,overflow: TextOverflow.ellipsis)
                    ],
                  ),
                )
              ],
            ),
            product.removeVisible?
            Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: const EdgeInsets.all(1),
                decoration: const BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),topRight: Radius.circular(19))
                ),
                child: Icon(Icons.delete,color: Colors.white.withOpacity(.9),),
              ),
            )
                :const SizedBox(),
          ],
        ),
      ):
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        clipBehavior: Clip.hardEdge,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.grey.shade100,
            border: Border.all(width: 1,color: Colors.red),
            borderRadius: BorderRadius.circular(10)
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                width: 100,
                child: product.imgUrls!.isNotEmpty?
                Swiper(
                  itemCount: product.imgUrls!.length,
                  itemBuilder: (context, index) {
                    return CachedNetworkImage(
                      imageUrl: product.imgUrls![index],
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            CircularProgressIndicator(),
                            Text("Yuklnamoqda...",style: TextStyle(fontSize: 12),)
                          ],
                        ),
                      ),
                      errorWidget: (context, url, error) => Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.highlight_remove,color: Colors.red,),
                            Text("Xatolik yuz berdi!",style: TextStyle(fontSize: 12),)
                          ],
                        ),
                      ),
                    );
                  },
                ):
                const Image(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/images/placeholder.png"),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name!,maxLines: 1,style: const TextStyle(overflow: TextOverflow.ellipsis,color: Colors.red,fontWeight: FontWeight.bold),),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(product.content!,maxLines: 3,style: const TextStyle(color: Colors.black54,overflow: TextOverflow.ellipsis),)),
              ),
            ),
            product.removeVisible?
            Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: const EdgeInsets.all(1),
                decoration: const BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),topRight: Radius.circular(10))
                ),
                child: Icon(Icons.delete,color: Colors.white.withOpacity(.9),),
              ),
            )
                :const SizedBox(),
          ],
        ),
      ),
    )*/;
  }

  Future<void> getProducts(bool first) async {
    await DataService.getProduct(first: first).then((value) => {
      setState((){
        items = value;
      }),
    });
  }

  void cautionDialog(String id,List<dynamic> imgUrl) async {
    setState(() {
      remove=true;
    });
    remove = await Utils.commonDialog(context, "Mahsulotni o'chirish", "Haqiqatdan bu mahsulotni o'chirasizmi?", "HA", "Yo'q");
    await Future.delayed(const Duration(seconds: 3));
    if (remove) {
      delProduct(id,imgUrl,);
    }
  }

  void delProduct(String id,List imgUrl,) async {
    await DataService.removeProduct([id],imgUrl);
    print("Successfully removed");
    Utils.fToast("Muvofiqiyatli o'chirildi");
    getProducts(true);
  }

  void delMoreProducts(List productsId,List imgUrl) async {
    await DataService.removeProduct(productsId,imgUrl).then((value) {
      if (value != null) {
        addMyProduct(productsId);
      }
    });
    delVisiable=false;
    delProductCount=0;
    setState(() {
      isLoading=false;
    });
    print("Successfully removed");
    Utils.fToast("Muvofiqiyatli o'chirildi");
    getProducts(true);
  }

  void addMyProduct(List id) async {
    Admin? admin=await DataService.loadAdmin();
    List myProducts=admin!.placedProduct;
    for (var a in id) {
      MyWork myWork = MyWork(id: "Delete Products IDs",date: DateTime.now().toString(),status: "delete");
      myProducts.add(myWork.toJson());
      await DataService.updateAdmin(admin);
    }
  }
}
