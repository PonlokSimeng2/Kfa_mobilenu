// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, import_of_legacy_library_into_null_safe, use_build_context_synchronously, non_constant_identifier_names, unused_import, deprecated_member_use

import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kfa_mobilenu/helper/build_context_helper.dart';
import 'package:kfa_mobilenu/providers/auth_provider.dart';
import 'package:kfa_mobilenu/providers/cache_provider.dart';
import 'package:passcode_screen/passcode_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../afa/screens/Auth/login_page.dart';
import '../../afa/screens/AutoVerbal/Add.dart';
import '../../afa/screens/AutoVerbal/List.dart';
import '../../afa/screens/paginatdatatable.dart';
import '../Abouts/Abouts.dart';
import '../Account/account.dart';
import '../Contacts/ContactUs_sidebar.dart';
import '../Contacts/ContactsUs.dart';
import '../propertype/Ppopertys/Getx_api/controller_api.dart';
import '../propertype/Ppopertys/Getx_api/for_rent.dart';
import '../propertype/Ppopertys/verval_property/Verbal_add.dart';
import 'Body.dart';
import 'Customs/Feed_back.dart';
import 'Customs/MyDrawerList.dart';

String? refresh_hometype;
bool isLoading = true;
String? property_type_id_province_0 = '0';
final controller_value = controller_api();
final controller_rent = controller_for_Rent();

class HomePage1 extends ConsumerStatefulWidget {
  const HomePage1({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<HomePage1> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage1> {
  late String id;

  Future logOut() async {
    ref.read(authProvider.notifier).logout();
    ref.read(sharePrefProvider).clear();
    Fluttertoast.showToast(
      msg: 'Log Out',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      textColor: Colors.blue,
      fontSize: 20,
    );
    context.pushReplace((context) => Login(openAsPage: true));
  }

  List? widget_Drawer;
  @override
  void initState() {
    super.initState();

    id = ref.read(authProvider)?.user.id.toString() ?? "";
  }

  // @override
  // Future<void> first_time() async {
  //   property_type_id_province_0;
  //   isLoading = true;
  //   await Future.wait([
  //     // controller_hometype.verbal_Hometype(),
  //     // controller_2.value_all_list_2(),
  //     controller_value.value_all_list(property_type_id_province_0),
  //     controller_rent.value_all_list_property_id(property_type_id_province_0),
  //   ]);
  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  final int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      Center(
        child: Body(),
      ),
      Center(child: Contacts()),
      Center(child: Abouts()),
      Center(child: Feed_back()),
    ];
    return Scaffold(
      body: tabs[_currentIndex],
      drawer: Drawer(
        width: 270,
        child: ListView(
          children: [
            //MyHeaderDrawer(),
            // for(int index=0;index<widget_Drawer!.length;index++)
            // widget_Drawer![index],
            Column(
              children: [
                MyDrawerList(
                  icon: Icons.account_box,
                  title: 'Account',
                  Press: () {
                    context.push((context) => Account());
                  },
                ),
                MyDrawerList(
                  icon: Icons.add_to_photos_sharp,
                  title: 'Add Auto Verbal',
                  Press: () {
                    context.push((context) => Add(id: id));
                  },
                ),
                MyDrawerList(
                  icon: Icons.compare_sharp,
                  title: 'Comparable',
                  Press: () {
                    context.push((context) => Add_with_property(id: id));
                  },
                ),
                MyDrawerList(
                  icon: Icons.compare_sharp,
                  title: 'Sale & Rent Property',
                  Press: () {
                    context.push((context) => Add_verbal_property(
                          refresh_homeScreen: (value) {
                            refresh_hometype = value;
                            setState(() {
                              refresh_hometype;
                              // print(refresh_hometype
                              //     .toString());
                              if (refresh_hometype!.isNotEmpty) {
                                // setState(() {
                                //   first_time();
                                //   // print(
                                //   //     'pov = ${refresh_hometype}');
                                // });
                              }
                            });
                          },
                        ));
                  },
                ),
                MyDrawerList(
                  icon: Icons.format_list_numbered_rtl_rounded,
                  title: 'Report',
                  Press: () {
                    context.push(
                      (context) => Detialbody_screen(
                        list: null,
                      ),
                    );
                  },
                ),
                MyDrawerList(
                  icon: Icons.search_rounded,
                  title: 'Search',
                  Press: () {
                    context.push(
                      (context) => Menu_of_Autoverval(
                        id: id,
                      ),
                    );
                  },
                ),
                MyDrawerList(
                  icon: Icons.contact_phone,
                  title: 'Contact Us',
                  Press: () {
                    context.push((context) => ContactsSidebar());
                    // showDialog(
                    //   context: context,
                    //   builder: (context) {
                    //     return PasscodeScreen(
                    //       passwordDigits: 4,
                    //       title: Text("data"),
                    //       isValidCallback: () {},
                    //       passwordEnteredCallback: (Val) {
                    //         setState(() {
                    //           password = int.parse(Val);
                    //           if (password == 1234) {
                    //             c = true;
                    //             number = 4;
                    //             Navigator.push(
                    //               context,
                    //               MaterialPageRoute(
                    //                 builder: (context) {
                    //                   return ContactsSidebar();
                    //                 },
                    //               ),
                    //             );
                    //           } else {
                    //             setState(() {
                    //               number = 0;
                    //               c = false;
                    //               Navigator.of(context).pop();
                    //               showDialog(
                    //                 context: context,
                    //                 builder: (context) {
                    //                   return AlertDialog(
                    //                     actions: [],
                    //                     title: Text("Error Password"),
                    //                     content:
                    //                         Text("Please try again later."),
                    //                   );
                    //                 },
                    //               );
                    //             });
                    //           }
                    //         });
                    //       },
                    //       cancelButton: Text('Cancel'),
                    //       cancelCallback: () {
                    //         setState(() {
                    //           number = 0;
                    //           c = false;
                    //           password = null;
                    //           Navigator.of(context).pop();
                    //         });
                    //       },
                    //       deleteButton: Text('Delete'),
                    //       shouldTriggerVerification:
                    //           (_verificationNotifier).stream,
                    //     );
                    //   },
                    // );
                  },
                ),
              ],
            ),

            SizedBox(
              height: 40,
            ),
            Divider(
              color: Colors.blueAccent,
            ),
            MyDrawerList(
              icon: Icons.lock_open_outlined,
              title: 'Log Out',
              Press: () {
                logOut();
              },
            ),
          ],
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   selectedItemColor: kwhite_new,
      //   currentIndex: _currentIndex,
      //   type: BottomNavigationBarType.fixed,
      //   iconSize: 25,
      //   items: [
      //     BottomNavigationBarItem(
      //       icon: Icon(
      //         Icons.home,
      //       ),
      //       label: "Home",
      //       backgroundColor: kwhite_new,
      //     ),
      // BottomNavigationBarItem(
      //   icon: Icon(Icons.question_answer),
      //   label: "FAQ",
      //   backgroundColor: kwhite_new,
      // ),
      // BottomNavigationBarItem(
      //   icon: Icon(Icons.contact_phone),
      //   label: "Contact",
      //   backgroundColor: kwhite_new,
      // ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.people),
      //       label: "About",
      //       backgroundColor: kwhite_new,
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.contact_phone),
      //       label: "FeedBack",
      //       backgroundColor: kwhite_new,
      //     ),
      //   ],
      //   onTap: (index) {
      //     setState(() {
      //       _currentIndex = index;
      //     });
      //   },
      // ),
    );
  }
}
