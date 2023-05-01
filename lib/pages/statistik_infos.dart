import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:zarashopadmin/pages/searchinfo_page.dart';
import '../service/data_service.dart';
import '../service/utils_service.dart';


class StatistikInfoPage extends StatefulWidget {
  const StatistikInfoPage({Key? key}) : super(key: key);

  @override
  State<StatistikInfoPage> createState() => _StatistikInfoPageState();
}

class _StatistikInfoPageState extends State<StatistikInfoPage> {
  Map<String, int> list = {};
  bool isLoading = true;
  bool sfChartType=true;
  late TooltipBehavior tooltipBehavior;



  //statistika jadvali uchun
  List<VisiableProductMoreBuy> statistikaList = [];
  // top mahsulotlar uchun
  List<VisiableProductMoreBuy> productInfo = [];



  @override
  void initState() {
    tooltipBehavior=TooltipBehavior(enable: true);
    getProduct();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              backgroundColor: Colors.white,
              iconTheme: const IconThemeData(color: Colors.black),
              title: const Text("Statistik ma'lumotlar",style: TextStyle(color: Colors.black,fontFamily: "Aladin",fontSize: 25),),
              actions: [
                InkWell(
                  onTap: () {
                    setState(() {
                      sfChartType=!sfChartType;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: sfChartType?
                    const Icon(CupertinoIcons.chart_bar,color: Colors.blue,):
                    const Icon(CupertinoIcons.chart_pie,color: Colors.blue,)
                  ),
                )
              ]
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: MediaQuery.of(context).size.width - 100,
                  width: double.infinity,
                  child: sfChartType?
                  SfCircularChart(
                    tooltipBehavior: tooltipBehavior,
                    legend: Legend(
                        isVisible: true,
                        overflowMode: LegendItemOverflowMode.wrap
                    ),
                    series: [
                      PieSeries(
                        dataSource: statistikaList,
                        xValueMapper: (datum, index) => statistikaList[index].category,
                        yValueMapper: (datum, index) => statistikaList[index].buyCount,
                        dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                        ),
                        enableTooltip: true,
                      )
                    ],
                  ):
                  SfCartesianChart(
                    primaryXAxis: CategoryAxis(),
                    series: [
                      StackedColumnSeries(
                          dataSource: statistikaList,
                          xValueMapper: (VisiableProductMoreBuy ch, _) => ch.category,
                          yValueMapper: (VisiableProductMoreBuy ch, index) => ch.buyCount,
                          gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topRight,
                              colors: [
                                Colors.deepPurple.withOpacity(.7),
                                CupertinoColors.activeBlue.withOpacity(.8)
                              ]
                          )
                      ),
                    ],
                  ),
                ),
                Container(
                    height: 2,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    color: Colors.blueAccent),
                const SizedBox(height: 10,),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    children: productInfo.map((e) {
                      return itemOfProducts(e);
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
        isLoading?
        const Scaffold(
          body: Center(
            child: CupertinoActivityIndicator(),
          ),
        ):
        const SizedBox()
      ],
    );
  }

  Widget itemOfProducts(VisiableProductMoreBuy visiableProductInfo) {
    return visiableProductInfo.isMoreBuy?
    Container(
      margin: const EdgeInsets.only(bottom: 7,right: 7,left: 7),
      child: MaterialButton(
        onPressed: (){
          Navigator.push(context, CupertinoPageRoute(builder: (context) => SearchInfoPage(categoryName: visiableProductInfo.category),));
        },
        padding: EdgeInsets.zero,
        minWidth: MediaQuery.of(context).size.width-9,
        height: MediaQuery.of(context).size.width / 6.5,
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          width: MediaQuery.of(context).size.width-9,
          height: MediaQuery.of(context).size.width / 6.5,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
                CupertinoColors.activeBlue.withOpacity(.65),
                // Color.fromRGBO(98, 213, 255, 1.0),
                Colors.red.withOpacity(.7),
              ]
            )
          ),
          child: Row(
            children: [
              Expanded(
                child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      visiableProductInfo.category!,
                      style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    )
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "${visiableProductInfo.buyCount} ta",
                    style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Image(
                      height: 25,
                      image: AssetImage("assets/images/popular.png"),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ):
    Container(
      margin: const EdgeInsets.only(bottom: 7,left: 7,right: 7),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(.5),offset: const Offset(0,0),blurRadius: 1)
        ]
      ),
      child: MaterialButton(
        onPressed: (){
          Navigator.push(context, CupertinoPageRoute(builder: (context) => SearchInfoPage(categoryName: visiableProductInfo.category),));
        },
        padding: const EdgeInsets.symmetric(horizontal: 10),
        minWidth: MediaQuery.of(context).size.width-9,
        height: MediaQuery.of(context).size.width / 6.5,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        child: Row(
          children: [
            Expanded(
              child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    visiableProductInfo.category!,
                    style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  )),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "${visiableProductInfo.buyCount} ta",
                  style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const Expanded(
              child: SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  void getProduct() async {
    setState(() {
      isLoading = true;
    });

    /// bazaviy malumotlarni yani productlarni chaqirish
    await DataService.getStatistic().then((value) => {
      // value.sort((a, b) => a.buyCount!.compareTo(b.buyCount!)),
      setState(() {
        list = value;
      })
    });

    // list.sort((a, b) => a.buyCount!.compareTo(b.buyCount!));
    list = Map.fromEntries(
        list.entries.toList()..sort((e1, e2) => e1.key.compareTo(e2.key)));
    List<String> categoryName = [];
    List<int> buy = [];
    int count = 0;

    // productlarning categoriya va uning ichidagi mahsulotlarini qancha sotib olinganini tekshirib categoriyaga uyg'unlashtirib alohida qilib olish
    for (var a in list.keys) {
      // for (var b in list) {
      //   if (a.category == b.category) {
      //     count += b.buyCount!;
      //   }
      // }

      buy.add(list[a]!);
      categoryName.add(a);
      // buy.add(count);
      // count = 0;
    }

    //malumotlar for da ortiqcha bo'lishi mumkin va ularni saralab bittadan qilib olish uchun setCategoryName va setBuy fieldlari
    Set<String> setCategoryName = categoryName.toSet();

    for (var a =0; setCategoryName.length > a; a++) {
      productInfo.add(VisiableProductMoreBuy(isMoreBuy: true,category: categoryName.toList()[a], buyCount: buy.toList()[a]));
    }

    productInfo.sort((a, b) => a.buyCount!.compareTo(b.buyCount!));

    for (var a =0;productInfo.length-1>=a;a++) {
      if (productInfo.length<=3) {
        if (a>(productInfo.length-1)-1) {
          statistikaList.add(VisiableProductMoreBuy(buyCount: productInfo[a].buyCount,category: productInfo[a].category,isMoreBuy: true));
        } else {
          productInfo[a].isMoreBuy=false;
        }
      }
      else if (productInfo.length>3 && 7>=productInfo.length) {
        if (a>(productInfo.length-1)-2) {
          statistikaList.add(VisiableProductMoreBuy(buyCount: productInfo[a].buyCount,category: productInfo[a].category,isMoreBuy: true));
        } else {
          productInfo[a].isMoreBuy=false;
        }
      }
      else if (productInfo.length>=7 && productInfo.length<12) {
        if (a>(productInfo.length-1)-3) {
          statistikaList.add(VisiableProductMoreBuy(buyCount: productInfo[a].buyCount,category: productInfo[a].category,isMoreBuy: true));
        } else {
          productInfo[a].isMoreBuy=false;
        }
      }
      else if (12<productInfo.length) {
        if (a>(productInfo.length-1)-5) {
          statistikaList.add(VisiableProductMoreBuy(buyCount: productInfo[a].buyCount,category: productInfo[a].category,isMoreBuy: true));
        } else {
          productInfo[a].isMoreBuy=false;
        }
      }
    }


    productInfo.reversed;
    var reverse=productInfo.reversed;
    productInfo=reverse.toList();

    setState(() {
      isLoading = false;
    });
  }
}



