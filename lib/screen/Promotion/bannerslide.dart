// ignore_for_file: prefer_const_constructors, camel_case_types, unused_import, depend_on_referenced_packages, non_constant_identifier_names, unused_local_variable, deprecated_member_use

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
// import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class BannerSlide extends StatefulWidget {
  const BannerSlide({super.key});

  @override
  State<BannerSlide> createState() => _BannerSlideState();
}

class _BannerSlideState extends State<BannerSlide> {
  int a = 0;

  final imageListbanner = [
    'assets/images/banners/BannerKFA.jpg',
    'assets/images/banners/Service.jpg',
  ];

  final url_list = [
    'https://web.facebook.com/APD.Bank/?_rdc=1&_rdr',
    'https://www.ababank.com/?gclid=Cj0KCQjw2qKmBhCfARIsAFy8buJq0nU7_GqAtMTDJQWDdaI0O1hUWh3qe1QW2rbJ0If425UEqinbvBAaApeNEALw_wcB',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Container(
        color: Color.fromARGB(255, 80, 82, 200),
          height: 300,
          width: double.infinity,
          child: Column(
            children: [
              CarouselSlider.builder(
                  itemCount: imageListbanner.length,
                  itemBuilder: (context, index, realIndex) {
                    final imageList = imageListbanner[index];
      
                    return buildImage(imageList, index);
                  },
                  options: CarouselOptions(
                    aspectRatio : 16 / 9,
                    height: 300,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 10),
                    viewportFraction: 0.8,
                    autoPlayAnimationDuration: const Duration(milliseconds: 800),
                    enlargeCenterPage: true,
                    enlargeStrategy: CenterPageEnlargeStrategy.height,
                    onPageChanged: (index, reason) {
                      setState(() {
                        a = index;
                      });
                    },
                    // reverse: true,
                  ),
                  ),
      
              // buildIndicator(),
            ],
          ),),
    );
  }
  Widget buildImage(String imageList, int index) => BannersCard(
        img: imageList,
        press: () async {
          final url = url_list;
          await launch(
            url.elementAt(index),
            forceSafariVC: false,
            forceWebView: false,
          );
        },
      );
}

class BannersCard extends StatelessWidget {
  final String img;
  final press;
  const BannersCard({
    Key? key,
    required this.img,
    // required this.icon,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width*2,
        height: MediaQuery.of(context).size.height*1.8,
        decoration: BoxDecoration(
        ),
        child: InkWell(
          onTap: press,
          child: ClipRRect(
           // borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              img,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}