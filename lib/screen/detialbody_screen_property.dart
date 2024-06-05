import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kfa_mobilenu/screen/propertype/Ppopertys/naviga_menu.dart/For_Rent.dart';
import 'package:readmore/readmore.dart';

import '../afa/components/contants.dart';

// ignore: camel_case_types, must_be_immutable
class Detialbody_screen extends ConsumerStatefulWidget {
  Detialbody_screen({super.key, required this.list});
  var list;
  @override
  HomeViewState createState() => HomeViewState();
}

var textstyleblackbold = const TextStyle(
    color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold);
var textstyleblack = const TextStyle(
  color: Colors.black,
  fontSize: 18,
);

class HomeViewState extends ConsumerState<Detialbody_screen> {
  @override
  void initState() {
    super.initState();
    setState(() {
      print('dsddssd${list}');
    });
    // "ref" can be used in all life-cycles of a StatefulWidget.
  }

  @override
  Widget build(BuildContext context) {
    // // We can also use "ref" to listen to a provider inside the build method
    // final counter = ref.watch(counterProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kwhite_new,
        centerTitle: true,
        title: const Text("Properties"),
      ),
      body: Stack(
        children: [
          Container(
            color: kwhite_new,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CachedNetworkImage(
                            imageUrl: widget.list['url'].toString(),
                            fit: BoxFit.cover,
                            progressIndicatorBuilder: (
                              context,
                              url,
                              downloadProgress,
                            ) =>
                                Center(
                              child: CircularProgressIndicator(
                                value: downloadProgress.progress,
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CachedNetworkImage(
                            imageUrl: widget.list['url'].toString(),
                            fit: BoxFit.cover,
                            progressIndicatorBuilder: (
                              context,
                              url,
                              downloadProgress,
                            ) =>
                                Center(
                              child: CircularProgressIndicator(
                                value: downloadProgress.progress,
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: SingleChildScrollView(
                    child: Container(
                      //height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30.0),
                          topLeft: Radius.circular(30.0),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.list['type'].toString(),
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                            widget.list['hometype'].toString()),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              //icon
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 20, left: 20),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 167, 164, 164),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  height:
                                      MediaQuery.of(context).size.height * 0.09,
                                  //width: MediaQuery.of(context).size.width * 0.9,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      Column(
                                        children: [
                                          SizedBox(
                                            height: 45,
                                            width: 60,
                                            //color: Colors.amber,
                                            child: Row(
                                              children: [
                                                Text(
                                                  '${widget.list['bed']}',
                                                  style: textstyleblackbold,
                                                ),
                                                const Icon(
                                                  Icons.bed,
                                                  size: 45,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            'Bed',
                                            style: textstyleblackbold,
                                          )
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          SizedBox(
                                            height: 45,
                                            width: 60,
                                            //color: Colors.amber,
                                            child: Row(
                                              children: [
                                                Text(
                                                  '${widget.list['bed']}',
                                                  style: textstyleblackbold,
                                                ),
                                                const Icon(
                                                  Icons.bed,
                                                  size: 45,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            'Bed',
                                            style: textstyleblackbold,
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        children: [
                                          SizedBox(
                                            height: 45,
                                            width: 60,
                                            //color: Colors.amber,
                                            child: Row(
                                              children: [
                                                Text(
                                                  '${widget.list['bed']}',
                                                  style: textstyleblackbold,
                                                ),
                                                const Icon(
                                                  Icons.bed,
                                                  size: 45,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            'Bed',
                                            style: textstyleblackbold,
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        children: [
                                          SizedBox(
                                            height: 45,
                                            width: 60,
                                            //color: Colors.amber,
                                            child: Row(
                                              children: [
                                                Text(
                                                  '${widget.list['bed']}',
                                                  style: textstyleblackbold,
                                                ),
                                                const Icon(
                                                  Icons.bed,
                                                  size: 45,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            'Bed',
                                            style: textstyleblackbold,
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        children: [
                                          SizedBox(
                                            height: 45,
                                            width: 60,
                                            //color: Colors.amber,
                                            child: Row(
                                              children: [
                                                Text(
                                                  '${widget.list['bath']}',
                                                  style: textstyleblackbold,
                                                ),
                                                const Icon(
                                                  Icons.bathtub,
                                                  size: 45,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            'Bath',
                                            style: textstyleblackbold,
                                          )
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          SizedBox(
                                            height: 45,
                                            width: 60,
                                            child: Row(
                                              children: [
                                                Text(
                                                  '${widget.list['Livingroom']}',
                                                  style: textstyleblackbold,
                                                ),
                                                const Icon(
                                                  Icons.living_rounded,
                                                  size: 45,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            'Living Room',
                                            style: textstyleblackbold,
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(
                                  // height: MediaQuery.of(context).size.height * 0.09,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Description',
                                        style: textstyleblackbold,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                      255,
                                      133,
                                      169,
                                      201,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: const SingleChildScrollView(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: ReadMoreText(
                                        'This may seem like a no-brainer, but your real estate listing description should be accurate. If the house is barely 900 square feet, writing that the space is “sprawling” is dishonest. When you say a home is in “excellent condition” and there is water damage throughout the house and the back deck is rotting, a potential buyer will be turned off by seeing this on arrival. Setting unrealistic expectations helps no one.',
                                        trimMode: TrimMode.Line,
                                        trimLines: 2,
                                        colorClickableText: Colors.pink,
                                        trimCollapsedText: 'Show more',
                                        trimExpandedText: 'Show less',
                                        moreStyle: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Pleas contact us",
                                        style: textstyleblackbold,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: Container(
                                    height: 100,
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    decoration: const BoxDecoration(
                                      //color: Colors.amber,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child: const Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Icon(Icons.phone),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text("096 670 5117")
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Icon(Icons.phone),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text("092 677 5111")
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            top: 15,
            right: 5,
            child: Container(
              height: 30,
              width: 100,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 116, 4, 36),
                borderRadius: BorderRadius.all(Radius.elliptical(10, 10)),
              ),
              child: Center(
                child: Text(
                  "${widget.list['price'].toString()} \$",
                  style: const TextStyle(
                    color: Color.fromARGB(255, 216, 221, 226),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
