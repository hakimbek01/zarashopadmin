import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zarashopadmin/pages/products_page.dart';

import 'feed_page.dart';
import 'orders_view_page.dart';



class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  PageController _pageController=PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: (value) {
          setState(() {
            _selectedIndex=value;
          });
        },
        children: [
          FeedPage(),
          ProductsPage(),
          OrdersPage(),
        ],
      ),

      bottomNavigationBar: SafeArea(
        child: Container(
          height: 50,
          margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          padding: EdgeInsets.all(7),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: Colors.blueGrey.shade900
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Column(
                  children: [
                    _selectedIndex==0?
                    Container(
                      height: 4,
                      width: 18,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10)
                      ),
                    )
                        :SizedBox(),
                    SizedBox(height: 3,),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          _selectedIndex=0;
                          _pageController.animateToPage(_selectedIndex, duration: Duration(milliseconds: 100), curve: Curves.easeIn);
                        });
                      },
                      child: Icon(Icons.home,color: Colors.white,),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    _selectedIndex==1?
                    Container(
                      height: 4,
                      width: 18,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10)
                      ),
                    )
                        :SizedBox(),
                    SizedBox(height: 3,),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          _selectedIndex=1;
                          _pageController.animateToPage(_selectedIndex, duration: Duration(milliseconds: 100), curve: Curves.easeIn);
                        });
                      },
                      child: Icon(Icons.card_travel,color: Colors.white,),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    _selectedIndex==2?
                    Container(
                      height: 4,
                      width: 18,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10)
                      ),
                    )
                        :SizedBox(),
                    SizedBox(height: 3,),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          _selectedIndex=2;
                          _pageController.animateToPage(_selectedIndex, duration: Duration(milliseconds: 100), curve: Curves.easeIn);
                        });
                      },
                      child: Icon(CupertinoIcons.arrow_down_right_square_fill,color: Colors.white,),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



}