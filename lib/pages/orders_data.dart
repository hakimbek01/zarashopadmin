import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import '../model/orders_model.dart';
import '../service/data_service.dart';
import 'check_image_page.dart';

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
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text("Hammasi o'z qo'lingda",style: TextStyle(color: Colors.black),),
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
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30))
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(orders!.phoneNumber!,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
                              TextButton(
                                onPressed: () {
                                  callNumber(orders!.phoneNumber!);
                                },
                                child: Text("Aloqaga chiqish",style: TextStyle(color: Colors.green)),
                              )
                            ],
                          ),
                          MaterialButton(
                            minWidth: MediaQuery.of(context).size.width,
                            color: Colors.blue,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => CheckImagePage(url: orders!.checkImage),));
                            },
                            child: Text("Chekni ko'rish",style: TextStyle(color: Colors.white),),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  SizedBox(height: 10,),
                                  Text("O'lcham",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                  SizedBox(height: 10,),
                                  Container(
                                    height: 50,
                                    width: 90,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(color: Colors.grey.withOpacity(.6),blurRadius: 2,offset: Offset(0,0))
                                        ]
                                    ),
                                    child: Center(
                                      child:Text(orders!.products![index]['size'],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  SizedBox(height: 10,),
                                  Text("Soni",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                  SizedBox(height: 10,),
                                  Container(
                                    height: 50,
                                    width: 90,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(color: Colors.grey.withOpacity(.6),blurRadius: 2,offset: Offset(0,0))
                                        ]
                                    ),
                                    child: Center(
                                      child:Text(orders!.products![index]['count'],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Text(orders!.comment!),
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              Text("Joylashuv: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                              Text(orders!.location!,style: TextStyle(fontStyle: FontStyle.italic,fontSize: 15),)
                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("Narx: ",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                              Text(orders!.totalPrice!)
                            ],
                          ),
                          SizedBox(height: 20,),
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
                                Text("Buyurtma yo'lda",style: TextStyle(color: Colors.white),),
                                SizedBox(width: 10,),
                                loadingAccept?
                                CupertinoActivityIndicator(color: Colors.white,):
                                SizedBox()
                              ],
                            ):
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Buyurtmani qabul qilish",style: TextStyle(color: Colors.white),),
                                SizedBox(width: 10,),
                                loadingAccept?
                                CupertinoActivityIndicator(color: Colors.white,):
                                SizedBox()
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
