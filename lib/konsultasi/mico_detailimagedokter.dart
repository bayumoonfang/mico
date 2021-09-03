

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class DetailImageDokter extends StatefulWidget {
  final String ImgFile;
  const DetailImageDokter(this.ImgFile);
  @override
  _DetailImageDokterState createState() => new _DetailImageDokterState(
      getImgFile: this.ImgFile);
}



class _DetailImageDokterState extends State<DetailImageDokter> {
  String getImgFile;
  _DetailImageDokterState({this.getImgFile});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
              tag: 'imagehero',
              child:
              PhotoView(
                imageProvider: NetworkImage("http://duakata-dev.com/miracle/media/photo/"+widget.ImgFile),
              )
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}