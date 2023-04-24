import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


import '../model/reklama.dart';
import '../service/data_service.dart';
import '../service/store_service.dart';
import '../service/utils_service.dart';

class NewReklamaPage extends StatefulWidget {
  const NewReklamaPage({Key? key}) : super(key: key);

  @override
  State<NewReklamaPage> createState() => _NewReklamaPageState();
}

class _NewReklamaPageState extends State<NewReklamaPage> {
  TextEditingController _linkConrtoller = TextEditingController();
  final ImagePicker _imagePicker=ImagePicker();
  bool isLoading = false;
  String link = "";
  List images = [];
  int currentIndex = 0;

  @override

  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(
                color: Colors.black
            ),
            title: Text("Reklama"),
            actions: [
              IconButton(
                onPressed: openGallery,
                icon: Icon(CupertinoIcons.photo),
                color: Colors.black54,
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    height: MediaQuery.of(context).size.height/2.2,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(30),bottomLeft: Radius.circular(30)),
                        boxShadow: [
                          BoxShadow(color: Colors.grey.withOpacity(.4),offset: Offset(0,3),blurRadius: 5)
                        ]
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: images.length != 0?
                    Swiper(
                      onIndexChanged: (value) {
                        setState(() {
                          link = images[value]['link'];
                        });
                      },
                      itemCount: images.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            Image(
                              height: MediaQuery.of(context).size.height/2.2,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              image: FileImage(images[index]['img']),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white.withOpacity(.6),
                                  radius: 20,
                                  child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        images.remove(images[index]);
                                      });
                                    },
                                    icon: Icon(CupertinoIcons.delete,color: Colors.red,),
                                  ),
                                ),
                              ),
                            ),
                            images[index]['link'].toString().isNotEmpty?
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                  padding: EdgeInsets.all(15),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        images[index]['link'] = "";
                                      });
                                    },
                                    child: CircleAvatar(
                                      radius: 17,
                                      backgroundColor: Colors.white.withOpacity(.7),
                                      child: Icon(CupertinoIcons.checkmark_seal_fill,color: Colors.lightBlue,),
                                    ),
                                  )
                              ),
                            ):
                            Center(
                              child: InkWell(
                                onTap: () {
                                  AwesomeDialog(
                                    context: context,
                                    animType: AnimType.bottomSlide,
                                    dialogType: DialogType.noHeader,
                                    btnOkOnPress: () {
                                      setState(() {
                                        images[index]['link'] = _linkConrtoller.text;
                                        link = _linkConrtoller.text;
                                        _linkConrtoller.clear();
                                      });
                                    },
                                    btnCancelOnPress: () {},
                                    body: Column(
                                      children: [
                                        TextField(
                                          controller: _linkConrtoller,
                                          decoration: const InputDecoration(
                                              hintStyle: TextStyle(color: Colors.grey),
                                              hintText: "Linkni nusxasini tashlang"
                                          ),
                                        )
                                      ],
                                    ),
                                  ).show();
                                },
                                child: Container(
                                  height: 40,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  width: 180,
                                  decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.circular(15)
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(CupertinoIcons.link,color: Colors.white,),
                                      SizedBox(width: 10,),
                                      Text("Havola qo'shish",style: TextStyle(color: Colors.white),)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ):
                    Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                              height: 200,
                              image: AssetImage("assets/images/reklamabaner.png"),
                            ),
                            SizedBox(height: 15,),
                            Text("Hozircha bo'sh",style: TextStyle(fontWeight: FontWeight.bold),)
                          ],
                        )
                    )
                ),
                SizedBox(height: 30,),
                link.isNotEmpty?
                Container(
                  height: 50,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 7),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(color: Colors.grey.withOpacity(.5),blurRadius: 4,offset: Offset(0,3))
                      ]
                  ),
                  child: Text("Link: $link"),
                ):
                SizedBox.shrink(),
                SizedBox(height: 50,),
                MaterialButton(
                  height: 50,
                  minWidth: 150,
                  onPressed: () {
                    reklamaAdd();
                  },
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Icon(CupertinoIcons.rocket,color: Colors.white,size: 35,),
                )
              ],
            ),
          ),
        ),
        isLoading?
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ):
        SizedBox()
      ],
    );
  }

  void openGallery() async {
    XFile? image=await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 30
    );
    setState(() {
      images.add({
        "img":File(image!.path),
        "link": ""
      });
    });
  }

  void reklamaAdd() async {
    List list = List.from(images);
    if (list.isEmpty) {
      Utils.fToast("Ma'lmotlar to'liq emas!");
      return;
    }
    for (var i = 0; list.length>i;i++) {
      if (!(list[i]['img'].toString().startsWith("https:"))) {
        String path = list[i]['img'].toString().split('File: ').last;
        path = path.split("'")[1];
        await StoreService.uploadAdvertisingImage(File(path)).then((value) {
          list[i]['img'] = value;
        });
      }
    }

    Reklama reklama = Reklama(reklama: list);

    setState(() {
      isLoading = true;
    });

    await DataService.addAdvertising(reklama).then((value) {
      Utils.fToast("Reklama qo'shildi!😀");
      setState(() {
        isLoading = false;
      });
      Navigator.pop(context);
    });

  }

}
