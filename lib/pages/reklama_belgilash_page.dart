import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/reklama.dart';
import '../service/data_service.dart';
import '../service/utils_service.dart';
import 'new_reklama_page.dart';

class ReklamaBelgilashPage extends StatefulWidget {
  const ReklamaBelgilashPage({Key? key}) : super(key: key);

  @override
  State<ReklamaBelgilashPage> createState() => _ReklamaBelgilashPageState();
}

class _ReklamaBelgilashPageState extends State<ReklamaBelgilashPage> {
  bool isLoading = false;
  List items = [];
  String hozirgiId = "";
  @override
  void initState() {
    getListAdvertising();
    getCurrentAdvertising();
    super.initState();
  }

  @override
  void dispose() {
    updateCurrentAdvertising(hozirgiId);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: const IconThemeData(
                color: Colors.black
            ),
            title: Row(
              children: const [
                Text("E'lonlar",style: TextStyle(color: Colors.black),),
                SizedBox(width: 10,),
                Padding(
                  padding: EdgeInsets.zero,
                  child: Image(
                    width: 30,
                    image: AssetImage("assets/buttons/reklama.png"),
                  ),
                )
              ],
            ),
            actions: [
              InkWell(
                onTap: () async {
                  await Navigator.push(context, CupertinoPageRoute(builder: (context) => const NewReklamaPage(),));
                  getListAdvertising();
                },
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Image(
                    image: AssetImage("assets/buttons/addreklama.png"),
                  ),
                ),
              )
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: items.map((e) {
                  return itemOfAdvertising(e);
                }).toList(),
              ),
            ),
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


  Widget itemOfAdvertising(Reklama reklama) {
    return Container(
      height: 90,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 3),
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(.3),blurRadius: 3,offset: const Offset(0,2),)
        ]
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3)
            ),
            clipBehavior: Clip.hardEdge,
            child: CachedNetworkImage(
              imageUrl: reklama.reklama![0]['img'],
            ),
          ),
          const SizedBox(width: 10,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(reklama.reklama![0]['link'],maxLines: 3,overflow: TextOverflow.ellipsis)
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      hozirgiId = reklama.id!;
                    });
                  },
                  child: hozirgiId==reklama.id?
                  const Icon(CupertinoIcons.checkmark,color: Colors.green,):
                  Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                        border: Border.all(width: 2,color: Colors.grey)
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    bool isRemove = await Utils.commonDialog(context, "Reklamani o'chirish", "Bu reklamani haqiqatdan ham o'chirasizmi", "Ha", "Yo'q");

                    if (isRemove) {
                      removeAdvertising(reklama);
                    }

                  },
                  child: const Icon(Icons.delete,color: Colors.grey,),
                )
              ],
            )
          ),
        ],
      ),
    );
  }

  void getListAdvertising() async {
    setState(() {
      isLoading = true;
    });

    await DataService.getAdvertisingList().then((value) {
      setState(() {
        items = value;
      });
    });

    setState(() {
      isLoading = false;
    });
  }

  void getCurrentAdvertising() async {
    await DataService.getCurrentAdvertisingId().then((value) {
      setState(() {
        hozirgiId = value;
      });
    });

    setState(() {
      isLoading = false;
    });
  }

  void updateCurrentAdvertising(String id) async {
    await DataService.updateCurrentAdvertising(id);
  }

  void removeAdvertising(Reklama reklama) async {
    List items = [];

    setState(() {
      isLoading = true;
    });

    for (var a in reklama.reklama!) {
      items.add(a['img']);
    }

    await DataService.removeAdvertising(reklama.id!, items);

    setState(() {
      isLoading = false;
    });
    getListAdvertising();
    // getCurrentAdvertising();
  }
}
