import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CheckImagePage extends StatefulWidget {
  final String? url;
  const CheckImagePage({Key? key, this.url}) : super(key: key);

  @override
  State<CheckImagePage> createState() => _CheckImagePageState();
}

class _CheckImagePageState extends State<CheckImagePage> {
  bool fullScreen = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        title: Text("Checkning rasmi",style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                fullScreen = !fullScreen;
              });
            },
            icon: fullScreen?Icon(CupertinoIcons.fullscreen_exit):Icon(CupertinoIcons.fullscreen,),
          )
        ],
      ),
      body: fullScreen?
      Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: CachedNetworkImage(
          fit: BoxFit.cover,
          progressIndicatorBuilder: (context, url, progress) => Center(child: CircularProgressIndicator(color: Colors.white,),),
          imageUrl: widget.url!,
        ),
      ):
      CachedNetworkImage(
        progressIndicatorBuilder: (context, url, progress) => Center(child: CircularProgressIndicator(color: Colors.white,),),
        imageUrl: widget.url!,
      ),
    );
  }
}
