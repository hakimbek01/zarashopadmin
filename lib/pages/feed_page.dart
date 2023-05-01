import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:zarashopadmin/pages/profile_page.dart';
import 'package:zarashopadmin/pages/reklama_belgilash_page.dart';
import 'package:zarashopadmin/pages/search_page.dart';
import 'package:zarashopadmin/pages/statistik_infos.dart';

import '../model/product_model.dart';
import '../model/reklama.dart';
import '../service/data_service.dart';
import '../service/utils_service.dart';


class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  List<Product> list=[];
  bool isLoading=true;
  // bool isVisiable = true;
  String name="";
  bool productVisiableType = false;
  List<VisiableProductMoreBuy> statistikaList=[];
  List<VisiableProductMoreBuy> productInfo = [];
  late TooltipBehavior tooltipBehavior;
  Reklama reklama = Reklama(reklama: []);


  @override
  void initState() {
    tooltipBehavior=TooltipBehavior(enable: true,);
    loadAdmin();
    getReklama();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await getReklama();
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //appBar
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  height: MediaQuery.of(context).size.width/5,
                  width: double.infinity,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //profile
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: GestureDetector(
                            onTap: () async {
                              await Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage(),));
                              loadAdmin();
                            },
                            child: CircleAvatar(
                              radius: 19,
                              backgroundColor: Colors.grey.shade200,
                              child: const Center(
                                child: Icon(Icons.person,color: Colors.grey,),
                              ),
                            ),
                          ),
                        ),
                      ),
                      //username
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Salom! Admin",style: TextStyle(color: Colors.grey,fontSize: 11),),
                            Text(name,style: const TextStyle(color: Colors.black,fontSize: 14,fontStyle: FontStyle.italic,overflow: TextOverflow.ellipsis,),maxLines: 3,)
                          ],
                        ),
                      ),
                      //statistka
                      Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.purpleAccent.withOpacity(.5),
                          gradient: const LinearGradient(
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              colors: [
                                Color.fromRGBO(255, 104, 175, 1),
                                Color.fromRGBO(255, 104, 175, 1)
                              ]
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const StatistikInfoPage(),));
                          },
                          child: const Center(
                            //chart pie
                            child: Icon(CupertinoIcons.chart_bar,color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20,),
                //search
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, CupertinoPageRoute(builder: (context) => const SearchPage(types: true),));
                  },
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    height: 45,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(color: Colors.grey.withOpacity(.25),offset: const Offset(0,1),blurRadius: 4)
                        ]
                    ),
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Icon(CupertinoIcons.search,color: Colors.grey,),
                    ),
                  ),
                ),
                const SizedBox(height: 30,),
                //reklama
                GestureDetector(
                  onTap: () async {
                    await Navigator.push(context, MaterialPageRoute(builder: (context) => const ReklamaBelgilashPage()));
                    getReklama();
                  },
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    clipBehavior: Clip.hardEdge,
                    height: 170,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(color: Colors.grey.withOpacity(.3),offset: const Offset(0,2),blurRadius: 2),
                        BoxShadow(color: Colors.grey.withOpacity(.3),offset: const Offset(0,-0.67),blurRadius: 1),
                      ]
                    ),
                    child: reklama.reklama!.isEmpty?
                    const Center(
                      child: Icon(CupertinoIcons.arrow_2_circlepath_circle,size: 35,),
                    ):
                    Swiper(
                      itemCount: reklama.reklama!.length,
                      itemBuilder: (context, index) {
                        return CachedNetworkImage(
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
                          fit: BoxFit.cover,
                          imageUrl: reklama.reklama![index]['img'],
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20,),
              ],
            ),
          ),
        ),
      ),
    );
  }



  void loadAdmin() async {
    await DataService.loadAdmin().then((value) => {
      setState((){
        name=value!.fullName!;
      })
    });
  }

  Future<void> getReklama() async {
    String id = await DataService.getCurrentAdvertisingId();
    await DataService.getCurrentAdvertising(id).then((value) {
      setState(() {
        reklama = value;
      });
    });
  }


}


