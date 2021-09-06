

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class DetailScreenHome extends StatefulWidget {
  final String ImgFile;
  const DetailScreenHome(this.ImgFile);
  @override
  _DetailScreenHomeState createState() => new _DetailScreenHomeState(
      getImgFile: this.ImgFile);
}



class _DetailScreenHomeState extends State<DetailScreenHome> {
  String getImgFile;
  _DetailScreenHomeState({this.getImgFile});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
              tag: 'imagehero',
              child:
              PhotoView(
                imageProvider: NetworkImage(widget.ImgFile),
              )
            /* Image (
                    image: NetworkImage("https://duakata-dev.com/miracle/media/imgchat/"+widget.ImgFile),
                  )*/
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}