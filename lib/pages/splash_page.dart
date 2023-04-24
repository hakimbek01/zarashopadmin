import 'package:flutter/material.dart';
import 'package:zarashopadmin/pages/signin_page.dart';
import '../service/auth_service.dart';
import 'home_page.dart';


class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {


  void isSignUser() async {
    await Future.delayed(Duration(seconds: 3));
    bool isLogged=AuthService.currentUser();
    if (!isLogged || isLogged==null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInPage(),));
    }
    else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(),));
    }
  }

  @override
  void initState() {
    isSignUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [
              Color.fromRGBO(248, 94, 225, 1.0),
              Color.fromRGBO(69, 162, 243, 1.0)
            ]
          )
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: Text("Zara Shop",style: TextStyle(color: Colors.white,fontFamily: "Billabong",fontSize: 45),)
                )
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Text("Loading...",style: TextStyle(color: Colors.white),)
              )
            ],
          )
        ),
      ),
    );
  }
}
