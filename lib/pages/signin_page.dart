import 'dart:async';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:zarashopadmin/pages/signup_page.dart';
import '../service/auth_service.dart';
import 'home_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController _email=TextEditingController();
  TextEditingController _password=TextEditingController();
  Timer? timer;
  FlipCardController? _flipController;
  bool isLoading=false;
  @override
  void initState() {
    _flipController=FlipCardController();
    super.initState();
  }

  void doSignIn() async {
    String email=_email.text.trim();
    String password=_password.text.trim();

    if (email.isEmpty || password.isEmpty ) return;

    try {
      setState(() {
        isLoading=true;
      });
      await AuthService.signIn(email, password).then((value) => {
        if (value!=null) {
          setState((){
            isLoading=false;
          }),
          _flipController!.toggleCard(),
          timer=Timer.periodic(Duration(milliseconds: 900), (timer) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(),));
            timer.cancel();
          }),
        }
      });
    } catch (e){
      setState(() {
        isLoading=false;
      });
    } finally {
      setState(() {
        isLoading=false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height-50,
                    child: Column(
                      children: [
                        FlipCard(
                          controller: _flipController,
                          flipOnTouch: false,
                          front: Image(
                            height: MediaQuery.of(context).size.width-130,
                            image: AssetImage("assets/images/signin.png"),
                          ),
                          back: Image(
                            height: MediaQuery.of(context).size.width-200,
                            image: AssetImage("assets/images/ok.png"),
                          ),
                        ),
                        SizedBox(height: 10,),
                        //email
                        Container(
                          height: 45,
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              border: Border.all(width: .5,color: Colors.purpleAccent)
                          ),
                          child: TextField(
                            controller: _email,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Email",
                                hintStyle: TextStyle(color: Colors.grey.withOpacity(.7))
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        //password
                        Container(
                          height: 45,
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              border: Border.all(width: .5,color: Colors.purpleAccent)
                          ),
                          child: TextField(
                            controller: _password,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Password",
                                hintStyle: TextStyle(color: Colors.grey.withOpacity(.7))
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        MaterialButton(
                          height: 45,
                          minWidth: double.infinity,
                          onPressed: (){
                            doSignIn();
                          },
                          shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(10),side: BorderSide(color: Colors.purpleAccent,width: 1)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text("Sign In",style: TextStyle(fontSize: 18,fontFamily: "Aladin"),),
                              Icon(Icons.chevron_right)
                            ],
                          ),
                        ),
                        SizedBox(height: 30,),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Huquqlar himoya qilingan"),
                        SizedBox(width: 10,),
                        TextButton(
                          onPressed: (){
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignUpPage()));
                          },
                          child: Text("Sign Up",style: TextStyle(color: Colors.black,fontFamily: "Aladin",fontSize: 17),),
                        )
                      ],
                    ),
                  ),
                ],
              ),
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
}
