import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImagePage extends StatefulWidget {
  final String? url;
  final File? file;
  const ImagePage({Key? key, this.url, this.file}) : super(key: key);

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  bool fullScreen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(
          color: Colors.white
        ),
        title: const Text("Rasmni ko'rish",style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                fullScreen = !fullScreen;
              });
            },
            icon: fullScreen?const Icon(CupertinoIcons.fullscreen_exit):const Icon(CupertinoIcons.fullscreen,),
          )
        ],
      ),
      body: Center(
        child: widget.file == null?
        fullScreen?
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: CachedNetworkImage(
            fit: BoxFit.cover,
            progressIndicatorBuilder: (context, url, progress) => const Center(child: CircularProgressIndicator(color: Colors.white,),),
            imageUrl: widget.url!,
          ),
        ):
        CachedNetworkImage(
          progressIndicatorBuilder: (context, url, progress) => const Center(child: CircularProgressIndicator(color: Colors.white,),),
          imageUrl: widget.url!,
        ):
        fullScreen?
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Image(
            fit: BoxFit.cover,
            image: FileImage(widget.file!),
          ),
        ):
        Image.file(widget.file!),
      )
    );
  }
}
