import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zarashopadmin/pages/searchinfo_page.dart';

import '../service/data_service.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {

  List<String> category=[];

  @override
  void initState() {
    getCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: category.map((e) {
          return itemOfCategory(e);
        }).toList(),
      ),
    );
  }

  Widget itemOfCategory(String categoryName) {
    return InkWell(
      onTap: () async {
        await Navigator.push(context, CupertinoPageRoute(builder: (context) => SearchInfoPage(categoryName: categoryName),));
        getCategory();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10,right: 10,left: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: MediaQuery.of(context).size.width/6.5,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(width: .7,color: Colors.grey.withOpacity(.5))
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(categoryName,maxLines: 3,overflow: TextOverflow.ellipsis,),
            ),
            const Icon(CupertinoIcons.right_chevron)
          ],
        ),
      ),
    );
  }

  void getCategory() async {
    await RTDBService.getCategory().then((value) => {
      setState((){
        category=value;
      })
    });
  }
}
