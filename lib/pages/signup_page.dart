import 'dart:async';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:zarashopadmin/pages/signin_page.dart';
import '../model/admin_model.dart';
import '../service/auth_service.dart';
import '../service/data_service.dart';
import 'home_page.dart';


class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController _email=TextEditingController();
  TextEditingController _password=TextEditingController();
  TextEditingController _confirmPassword=TextEditingController();
  TextEditingController _name=TextEditingController();
  Timer? timer;
  FlipCardController? _flipController;
  bool isLoading=false;
  @override
  void initState() {
    _flipController=FlipCardController();
    super.initState();
  }

  void doSignUp() async {
    String email=_email.text.trim();
    String password=_password.text.trim();
    String name=_name.text.trim();
    String confirmPassword=_confirmPassword.text.trim();

    if (email.isEmpty || password.isEmpty || name.isEmpty) return;
    if (confirmPassword!=password) return;

    try {
      setState(() {
        isLoading=true;
      });
      await AuthService.signUp(email, password).then((value) => {
        if (value!=null) {
          register(value.uid),
          _flipController!.toggleCard(),
          timer=Timer.periodic(const Duration(milliseconds: 900), (timer) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(),));
            timer.cancel();
          }),
          setState((){
            isLoading=false;
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


  void register(String uid) async {
    String name=_name.text.trim();
    Admin admin=Admin(fullName: name);
    admin.uid=uid;
    DataService.storeAdmin(admin);
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
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height-30,
                    child: Column(
                      children: [
                        FlipCard(
                          controller: _flipController,
                          flipOnTouch: false,
                          front: Image(
                            height: MediaQuery.of(context).size.width-130,
                            image: const AssetImage("assets/images/signup.png"),
                          ),
                          back: Image(
                            height: MediaQuery.of(context).size.width-200,
                            image: const AssetImage("assets/images/ok.png"),
                          ),
                        ),
                        const SizedBox(height: 20,),
                        //name
                        Container(
                          height: 45,
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              border: Border.all(width: .5,color: Colors.purpleAccent)
                          ),
                          child: TextField(
                            controller: _name,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Name",
                                hintStyle: TextStyle(color: Colors.grey.withOpacity(.7))
                            ),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        //email
                        Container(
                          height: 45,
                          padding: const EdgeInsets.symmetric(horizontal: 5),
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
                        const SizedBox(height: 10,),
                        //password
                        Container(
                          height: 45,
                          padding: const EdgeInsets.symmetric(horizontal: 5),
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
                        const SizedBox(height: 10,),
                        //confirm password
                        Container(
                          height: 45,
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              border: Border.all(width: .5,color: Colors.purpleAccent)
                          ),
                          child: TextField(
                            controller: _confirmPassword,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Confirm Password",
                                hintStyle: TextStyle(color: Colors.grey.withOpacity(.7))
                            ),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        MaterialButton(
                          height: 45,
                          minWidth: double.infinity,
                          onPressed: (){
                            doSignUp();
                          },
                          shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(10),side: const BorderSide(color: Colors.purpleAccent,width: 1)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Text("Sign Up",style: TextStyle(fontSize: 18,fontFamily: "Aladin"),),
                              const Icon(Icons.chevron_right)
                            ],
                          ),
                        ),
                        const SizedBox(height: 30,),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Huquqlar himoya qilingan"),
                        const SizedBox(width: 10,),
                        TextButton(
                          onPressed: (){
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignInPage(),));
                          },
                          child: const Text("Sign In",style: TextStyle(color: Colors.black,fontFamily: "Aladin",fontSize: 17),),
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
}
