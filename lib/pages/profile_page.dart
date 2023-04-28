import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zarashopadmin/pages/signin_page.dart';
import '../model/admin_model.dart';
import '../service/auth_service.dart';
import '../service/data_service.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  Admin? admin;
  bool isLoading=false;
  bool isLoadingImg=false;
  String name="";
  int currentIndex=0;
  String description="";
  String phoneNumber="";
  List myProducts=[];
  List myUpdateP=[];
  List myCreateP=[];
  bool visi=false;
  List<Admin> adminList=[];
  TextEditingController _nameController = TextEditingController();

  void loadAdmin() async {
    setState(() {
      isLoading=true;
    });
    DataService.loadAdmin().then((value) => {
      setState((){
        admin=value;
        name=value!.fullName!;
        _nameController.text = name;
        myProducts=value.placedProduct;
        sortMyWork();
      })
    });
  }

  void sortMyWork() async {
    for (var a in myProducts) {
      if (a["status"]=="update") {
        setState(() {
          myUpdateP.add(a);
        });
      }
      else if (a["status"]=="create") {
        setState(() {
          myCreateP.add(a);
        });
      }
    }

    setState(() {
      isLoading=false;
    });
  }

  void logout() async {
    await AuthService.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInPage(),));
  }

  @override
  void initState() {
    loadAdmin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Colors.black
            ),
            elevation: 0,
            backgroundColor: Colors.white,
            title: Text("Profile",style: TextStyle(fontSize: 25,fontFamily: "Aladin",color: Colors.black),),
            actions: [
              IconButton(
                onPressed: () {
                  AwesomeDialog(
                    context: context,
                    animType: AnimType.bottomSlide,
                    dialogType: DialogType.noHeader,
                    btnOkOnPress: () async {
                      admin!.fullName = _nameController.text;
                      setState(() {
                        isLoading = true;
                      });
                      await DataService.updateAdmin(admin!).then((value) {
                        setState(() {
                          name = value!.fullName!;
                          isLoading = false;
                        });
                      });
                    },
                    btnCancelOnPress: () {},
                    body: Column(
                      children: [
                        TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                              hintStyle: TextStyle(color: Colors.grey),
                              hintText: "Tahrirlash"
                          ),
                        )
                      ],
                    ),
                  ).show();
                },
                icon: Icon(Icons.edit),
              ),
              IconButton(
                onPressed: () {
                  logout();
                },
                icon: Icon(Icons.logout),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Text(name,style: TextStyle(color: Colors.black54,fontSize: 18,fontWeight: FontWeight.w500),),
                    ),
                    SizedBox(height: 7,),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(7),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.shade100,
                                gradient: LinearGradient(
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.topRight,
                                    colors: [
                                      Color.fromRGBO(255, 209, 249, 1.0),
                                      Color.fromRGBO(243, 171, 241, 1.0)
                                    ]
                                )
                            ),
                            child: Text("Joylashtirgan mahsulotlarim: ${myCreateP.length}",style: TextStyle(color: Colors.black54),),
                          ),
                        ),
                        SizedBox(width: 10,),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(7),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.shade100,
                                gradient: LinearGradient(
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.topRight,
                                    colors: [
                                      Color.fromRGBO(255, 209, 249, 1.0),
                                      Color.fromRGBO(243, 171, 241, 1.0)
                                    ]
                                )
                            ),
                            child: Text("Tahrirlagan mahsulotlarim: ${myUpdateP.length}",style: TextStyle(color: Colors.black54),),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
          ),
        ),
        isLoading?
        Scaffold(
          backgroundColor: Colors.grey.withOpacity(.2),
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ):
        SizedBox()
      ],
    );
  }


}
