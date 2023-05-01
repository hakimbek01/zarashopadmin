
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../service/utils_service.dart';


class SelectTypesPage extends StatefulWidget {
  final File? imgFILE;
  final String? imgURL;

  final Map<String, dynamic>? types;
  const SelectTypesPage({Key? key, this.imgFILE, this.types, this.imgURL,}) : super(key: key);

  @override
  State<SelectTypesPage> createState() => _SelectTypesPageState();
}

class _SelectTypesPageState extends State<SelectTypesPage> {

  @override
  void initState() {
    initAddItem();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            onPressed: () {
              types.clear();
              int count = priceControllers.length;
              for (int i = 0; i <  count; i++) {

                if (priceControllers[i].text.isEmpty || sizeControllers[i].text.isEmpty) {
                  sizeControllers.removeAt(i);
                  priceControllers.removeAt(i);
                }
              }
              if (sizeControllers.length != priceControllers.length) {
                Utils.fToast("Ma'lumot to'liq emas!");
                return;
              }
              for (int i = 0; i < sizeControllers.length; i++) {
                types.add(
                    {
                      "size" : sizeControllers[i].text.trim(),
                      "price" : priceControllers[i].text.trim(),
                    }
                );
              }
              Navigator.pop(context, types);
            },
            icon: const Icon(Icons.done,color: Colors.green,size: 30,),
          ),
        ],
        leading: IconButton(
          onPressed: (){
              Navigator.pop(context, widget.types!["types"]);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            widget.imgFILE!=null?
            Image.file(widget.imgFILE!, height: 400, width: double.infinity, fit: BoxFit.cover):
            CachedNetworkImage(
              height: 400,
              width: double.infinity,
              fit: BoxFit.cover,
              imageUrl: widget.imgURL!
            ),
            ListView.builder(
              itemCount: sizeControllers.length,
              shrinkWrap: true,
              primary: false,
              itemBuilder: (context, index) {
                return itemOfSizeAndPrice(index,sizeControllers[index], priceControllers[index]);
              },
            ),
            const SizedBox(height: 10,),
            Center(
              child: FloatingActionButton(
                  onPressed: addItem,
                  child: const Icon(Icons.add)
              ),
            ),
            const SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> types = [];
  List<TextEditingController> sizeControllers = List.generate(0, (index) => TextEditingController());
  List<TextEditingController> priceControllers = List.generate(0, (index) => TextEditingController());

  void initAddItem() {
    if (widget.imgURL != null) {

      if (widget.types!.isNotEmpty) {
        for (var j in widget.types!["types"]) {
          setState(() {
            sizeControllers.add(TextEditingController(text: j["size"]));
            priceControllers.add(TextEditingController(text: j["price"]));
          });
        }
      } else {
        addItem();
      }
    }

    else if (((widget.imgFILE != null))) {
      if (widget.types!.isNotEmpty) {
        for (var j in widget.types!["types"]) {
          setState(() {
            sizeControllers.add(TextEditingController(text: j["size"]));
            priceControllers.add(TextEditingController(text: j["price"]));
          });
        }
      } else {
        addItem();
      }
    }

  }

  void addItem() {
    setState(() {
      sizeControllers.add(TextEditingController());
      priceControllers.add(TextEditingController());
    });
  }

  Widget itemOfSizeAndPrice(int index, sizeController, priceController) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: TextField(
                controller: sizeController,
                decoration:  InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13),
                      borderSide: BorderSide.none
                  ),
                  focusedBorder:  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: const BorderSide(color: Colors.blue,width: 1),
                  ),
                  border: InputBorder.none,
                  filled: true,
                  label: const Text("Size"),
                ),
              ),
            ),
          ),
          const SizedBox(width: 5,),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: TextField(
                keyboardType: const TextInputType.numberWithOptions(),
                controller: priceController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: BorderSide.none
                  ),
                  focusedBorder:  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: const BorderSide(color: Colors.blue,width: 1),
                  ),
                  border: InputBorder.none,
                  filled: true,
                  label: const Text("Price"),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: (){
              setState(() {
                sizeControllers.removeAt(index);
                priceControllers.removeAt(index);
              });
            },
            icon: const Icon(Icons.delete, color: Colors.red,),
          ),
        ],
      ),
    );
  }

}
