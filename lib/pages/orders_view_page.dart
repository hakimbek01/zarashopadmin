import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/orders_model.dart';
import '../service/auth_service.dart';
import 'orders_data.dart';


class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("orders").snapshots(),
          builder: (context, snapshot) {
            return (snapshot.connectionState == ConnectionState.waiting)?
            Center(
              child: CircularProgressIndicator(),
            ):
            itemOfOrders(snapshot);
          },
        ),
      ),
    );
  }

  Widget itemOfOrders(snapshot) {
    return ListView.builder(
      itemCount: snapshot.data!.docs.length,
      itemBuilder: (context, index) {
        if (snapshot.data!.docs[index]["adminUID"] == AuthService.currentUserId()) {
          var malumot = snapshot.data!.docs[index];
          var a = snapshot.data!.docs[index].data();
          Orders orders = Orders.fromJson(a);
          return Column(
            children: [
              malumot['isVisiable']?
              Container(
                height: 70,
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          foregroundImage: AssetImage("assets/images/user.png"),
                        ),
                        SizedBox(width: 10,),
                        Text(malumot['totalPrice']+" UZS",style: TextStyle(fontWeight: FontWeight.bold),),
                      ],
                    ),
                    MaterialButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      color: Colors.blue,
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => OrdersDataPage(orders: orders),));
                      },
                      child: Text("Ko'rish",style: TextStyle(color: Colors.white),),
                    ),
                    Text(malumot['products'][0]['count']+" ta"),
                  ],
                ),
              )
              :ClipRect(
                child: Banner(
                  location: BannerLocation.topEnd,
                  message: "Yangi",
                  color: Colors.green,
                  child: Container(
                    height: 70,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              foregroundImage: AssetImage("assets/images/user.png"),
                            ),
                            SizedBox(width: 10,),
                            Text(malumot['totalPrice']+" UZS",style: TextStyle(fontWeight: FontWeight.bold),),
                          ],
                        ),
                        MaterialButton(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          color: Colors.blue,
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => OrdersDataPage(orders: orders),));
                          },
                          child: Text("Ko'rish",style: TextStyle(color: Colors.white),),
                        ),
                        Text(malumot['products'][0]['count']+" ta"),
                      ],
                    ),
                  ),
                ),
              ),
              Container(height: 1,width: double.infinity,color: Colors.grey.shade300,)
            ],
          );
        }
        return Center(
          child: Text("Hozircha burtmalar yo'q."),
        );
      },
    );
  }

}
