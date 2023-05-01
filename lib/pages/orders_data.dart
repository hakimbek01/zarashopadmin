import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import '../model/orders_model.dart';
import '../service/data_service.dart';
import 'image_visiable_page.dart';

class OrdersDataPage extends StatefulWidget {
  final Orders? orders;
  const OrdersDataPage({Key? key, this.orders}) : super(key: key);

  @override
  State<OrdersDataPage> createState() => _OrdersDataPageState();
}

class _OrdersDataPageState extends State<OrdersDataPage> {
  Orders? orders;
  int index = 0;
  bool loadingAccept = false;

  @override
  void initState() {
    setState(() {
      orders = widget.orders;
    });
    orderViewed();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: const Text("Hammasi o'z qo'lingda",style: TextStyle(color: Colors.black),),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                        height: MediaQuery.of(context).size.width-50,
                        width: double.infinity,
                        child: Swiper(
                          onIndexChanged: (value) {
                            setState(() {
                              index = value;
                            });
                          },
                          itemCount: orders!.products!.length,
                          itemBuilder: (context, index) {
                            return CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: orders!.products![index]['imgUrl'],
                            );
                          },
                        )
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.only(top: MediaQuery.of(context).size.width-80,),
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          boxShadow: [
                            BoxShadow(color: Colors.grey.withOpacity(.4),offset: Offset(0, -2),blurRadius: 1)
                          ],
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30))
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(orders!.phoneNumber!,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
                              TextButton(
                                onPressed: () {
                                  callNumber(orders!.phoneNumber!);
                                },
                                child: const Text("Aloqaga chiqish",style: TextStyle(color: Colors.green)),
                              )
                            ],
                          ),
                          MaterialButton(
                            minWidth: MediaQuery.of(context).size.width,
                            color: Colors.blue,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ImagePage(url: orders!.checkImage),));
                            },
                            child: const Text("Chekni ko'rish",style: TextStyle(color: Colors.white),),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  const SizedBox(height: 10,),
                                  const Text("O'lcham",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                  const SizedBox(height: 10,),
                                  Container(
                                    height: 50,
                                    width: 90,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(color: Colors.grey.withOpacity(.6),blurRadius: 2,offset: const Offset(0,0))
                                        ]
                                    ),
                                    child: Center(
                                      child:Text(orders!.products![index]['size'],style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  const SizedBox(height: 10,),
                                  const Text("Soni",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                  const SizedBox(height: 10,),
                                  Container(
                                    height: 50,
                                    width: 90,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(color: Colors.grey.withOpacity(.6),blurRadius: 2,offset: const Offset(0,0))
                                        ]
                                    ),
                                    child: Center(
                                      child:Text(orders!.products![index]['count'],style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10,),
                          Text(orders!.comment!),
                          const SizedBox(height: 10,),
                          Row(
                            children: [
                              const Text("Joylashuv: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                              Text(orders!.location!,style: const TextStyle(fontStyle: FontStyle.italic,fontSize: 15),)
                            ],
                          ),
                          const SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text("Narx: ",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                              Text(orders!.totalPrice!)
                            ],
                          ),
                          const SizedBox(height: 20,),
                          MaterialButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            minWidth: double.infinity,
                            color: orders!.accept!?Colors.red:Colors.green,
                            onPressed: () {
                              if (orders!.accept!) {
                                bekorQilish();
                              } else {
                                qabulQilish();
                              }
                            },
                            child: orders!.accept!?
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Buyurtma yo'lda",style: TextStyle(color: Colors.white),),
                                const SizedBox(width: 10,),
                                loadingAccept?
                                const CupertinoActivityIndicator(color: Colors.white,):
                                const SizedBox()
                              ],
                            ):
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Buyurtmani qabul qilish",style: TextStyle(color: Colors.white),),
                                const SizedBox(width: 10,),
                                loadingAccept?
                                const CupertinoActivityIndicator(color: Colors.white,):
                                const SizedBox()
                              ],
                            )
                          ),
                        ],
                      ),
                    ),
                  ),
                ]
            ),
          ),
        ),
      ),
    );
  }


  void qabulQilish() async {
    setState(() {
      loadingAccept = true;
    });

    await DataService.orderAcceptance(orders!).then((value) {
      setState(() {
        orders = value;
        loadingAccept = false;
      });
    });
  }

  void bekorQilish() async {
    setState(() {
      loadingAccept = true;
    });

    await DataService.orderCancellation(orders!).then((value) {
      setState(() {
        orders = value;
        loadingAccept = false;
      });
    });
  }

  void orderViewed() async {
    await DataService.orderViewed(orders!);
  }

  void callNumber(String number) async{
    bool? res = await FlutterPhoneDirectCaller.callNumber(number);
  }
}
