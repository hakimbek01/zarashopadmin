import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zarashopadmin/pages/update_page.dart';

import '../model/product_model.dart';


class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  List<String>?  itemCategory=[];

  String searchStart="";
  String searchEnd="";
  bool searchAnimation = false;


  @override
  void initState()  {
    start();
    super.initState();
  }

  void start() async {
    await Future.delayed(Duration(milliseconds: 10));
    setState(() {
      searchAnimation = true;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.close),
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    margin: EdgeInsets.only(right: 10),
                    height: 40,
                    width: searchAnimation?MediaQuery.of(context).size.width-60:10,
                    curve: Curves.easeIn,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(blurRadius: 2,color: Colors.grey,offset: Offset(0,0),)
                        ]
                    ),
                    child: Center(
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            searchStart=value;
                            searchEnd=value;
                          });
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search"
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection("products").snapshots(),
                builder: (context, snapshot) {
                  return (snapshot.connectionState == ConnectionState.waiting)?
                  Center(
                    child: CircularProgressIndicator(),
                  ):
                  ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                      if (searchStart.isEmpty) {
                        return SizedBox();
                      }
                      String name=data['name'];
                      if (
                        data['name'].toString().toLowerCase().startsWith(searchStart.toLowerCase())
                        || data['name'].toString().toLowerCase().endsWith(searchEnd.toLowerCase())
                        || data['name'].toString().toLowerCase().contains(searchStart.toLowerCase())
                      ) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(context, CupertinoPageRoute(builder: (context) => UpdatePage(product: Product.fromJson(data)),));
                          },
                          child: Container(
                            width: double.infinity,
                            height: 40,
                            margin: EdgeInsets.only(bottom: 15),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(color: Colors.grey,offset: Offset(0,2),blurRadius: 2),
                                        BoxShadow(color: Colors.grey,offset: Offset(0,-1),blurRadius: 1),
                                      ]
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                  child: Image(
                                    height: 60,
                                    width: 70,
                                    fit: BoxFit.cover,
                                    image: NetworkImage(data["imgUrls"][0]),
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Expanded(
                                  child: Text(name,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,),),
                                )
                              ],
                            ),
                          ),
                        );
                      }

                      return SizedBox();
                    },
                  );
                },
              )
            )
          ],
        ),
      ),
    );
  }

}
