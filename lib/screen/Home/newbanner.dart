// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';

// final imgList = [
// 'assets/images/banners/BannerKFA.jpg',
// 'assets/images/banners/Service.jpg',
// 'assets/images/banners/Awards2020.jpg',
// ];


// final List<Widget> imageSliders = imgList
//     .map((item) => ClipRRect(
//         borderRadius: BorderRadius.all(Radius.circular(5.0)),
//         child: Stack(
//           children: <Widget>[
//             Image.asset(item, fit: BoxFit.cover, width: 1000.0),
//             Positioned(
//               bottom: 0.0,
//               left: 0.0,
//               right: 0.0,
//               child: Container(
//                 decoration: const BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [
//                       Color.fromARGB(200, 0, 0, 0),
//                       Color.fromARGB(0, 0, 0, 0)
//                     ],
//                     begin: Alignment.bottomCenter,
//                     end: Alignment.topCenter,
//                   ),
//                 ),
//                 padding: const EdgeInsets.symmetric(
//                     vertical: 10.0, horizontal: 20.0),
//               ),
//             ),
//           ],
//         )))
//     .toList();
// class Newbanner extends StatefulWidget {
//   const Newbanner({super.key});

//   @override
//   State<StatefulWidget> createState() {
//     return _NewbannerState();
//   }
// }

// class _NewbannerState extends State<Newbanner> {
//   int _current = 0;
//   final CarouselController _controller = CarouselController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Carousel with indicator controller demo')),
//       body: SizedBox(
//         height: 300,
//         child: Column(
//           children: [
//             SizedBox(height: 5,),
//           CarouselSlider(
//             items: imageSliders,
//             carouselController: _controller,
//             options: CarouselOptions(
//                 autoPlay: true,
//                 enlargeCenterPage: true,
//                 aspectRatio: 2.0,
//                 onPageChanged: (index, reason) {
//                   setState(() {
//                     _current = index;
//                   });
//                 }),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: imgList.asMap().entries.map((entry) {
//               return GestureDetector(
//                 onTap: () => _controller.animateToPage(entry.key),
//                 child: Container(
//                   width: 12.0,
//                   height: 12.0,
//                   margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
//                   decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: (Theme.of(context).brightness == Brightness.dark
//                               ? Colors.white
//                               : Colors.black)
//                           .withOpacity(_current == entry.key ? 0.9 : 0.4)),
//                 ),
//               );
//             }).toList(),
//           ),
//         ]),
//       ),
//     );
//   }
// }

