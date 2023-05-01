import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zarashopadmin/pages/products_page.dart';
import 'package:zarashopadmin/pages/search_page.dart';



import 'create_page.dart';
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
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        backgroundColor: Colors.white.withOpacity(.3),
        items: const [
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.home),label: "Home"),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.search),label: "Search"),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.add_circled),label: "",),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.shopping_cart),label: "Products"),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.arrow_down_right_square),label: "Orders"),
        ],
      ),
      tabBuilder: (context, index) {
        switch(index) {
          case 0:
            return const FeedPage();
          case 1:
            return const SearchPage(types: false,);
          case 2:
            return const CreatePage();
          case 3:
            return const ProductsPage();
          case 4:
            return const OrdersPage();
        }
        return const SizedBox();
      },
    );
  }

  Widget a(context,) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: (value) {
          setState(() {
            _selectedIndex=value;
          });
        },
        children: const [
          FeedPage(),
          ProductsPage(),
          OrdersPage(),
        ],
      ),

      bottomNavigationBar: SafeArea(
        child: Container(
          height: 50,
          margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
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
                        :const SizedBox(),
                    const SizedBox(height: 3,),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          _selectedIndex=0;
                          _pageController.animateToPage(_selectedIndex, duration: const Duration(milliseconds: 100), curve: Curves.easeIn);
                        });
                      },
                      child: const Icon(Icons.home,color: Colors.white,),
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
                        :const SizedBox(),
                    const SizedBox(height: 3,),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          _selectedIndex=1;
                          _pageController.animateToPage(_selectedIndex, duration: const Duration(milliseconds: 100), curve: Curves.easeIn);
                        });
                      },
                      child: const Icon(Icons.card_travel,color: Colors.white,),
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
                        :const SizedBox(),
                    const SizedBox(height: 3,),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          _selectedIndex=2;
                          _pageController.animateToPage(_selectedIndex, duration: const Duration(milliseconds: 100), curve: Curves.easeIn);
                        });
                      },
                      child: const Icon(CupertinoIcons.arrow_down_right_square_fill,color: Colors.white,),
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