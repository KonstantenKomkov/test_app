// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:carousel_slider/carousel_slider.dart';

// Project imports:
import 'package:test_app/classes.dart';
import 'package:test_app/constants.dart';
import 'package:test_app/prefs.dart';

class AlbumPage extends StatefulWidget {
  static const routeName = '/album';
  const AlbumPage({Key? key, required this.album}) : super(key: key);
  final Album album;

  @override
  _AlbumPageState createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  bool isLoading = false;
  final sharedPrefs = SharedPrefs();
  List<Photo>? photos;

  @override
  void initState() {
    super.initState();
    initSharedPrefs();
  }

  Future<void> initSharedPrefs() async {
    setState(() {
      isLoading = true;
    });
    await sharedPrefs.init();
    final _data = await sharedPrefs.getPhotos(widget.album.id);
    setState(() {
      photos = _data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.album.title),
        ),
        body: carouselSlider(context, photos),
      ),
    );
  }

  Widget carouselSlider(BuildContext context, List<Photo>? photos) {
    if (photos == null) {
      return SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.black,
          child: const Center(
            child: Text(
              'Loading...',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    } else {
      return Builder(
        builder: (context) {
          final double height = MediaQuery.of(context).size.height;
          return CarouselSlider(
            options: CarouselOptions(
              height: height,
              viewportFraction: 1.0,
              // autoPlay: false,
            ),
            items: photos
                .map((photo) => Stack(children: [
                      Center(
                          child: Image.network(
                        photo.url,
                        fit: BoxFit.cover,
                        height: height,
                      )),
                      Positioned(
                        child: Padding(
                          padding: const EdgeInsets.all(kDefaultPadding * 2),
                          child: Text(
                            photo.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ]))
                .toList(),
          );
        },
      );
    }
  }
}
