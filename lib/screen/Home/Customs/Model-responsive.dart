// ignore_for_file: import_of_legacy_library_into_null_safe, camel_case_types, prefer_const_constructors, unused_import, non_constant_identifier_names, prefer_typing_uninitialized_variables, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../afa/components/contants.dart';
import '../../../afa/screens/AutoVerbal/Add.dart';
import '../../../afa/screens/AutoVerbal/List.dart';
import '../../Customs/responsive.dart';
import 'MenuCard.dart';
import 'MenuCard_dektop.dart';
import 'New_season.dart/page_add.dart';

class Menu extends StatefulWidget {
  final String user;
  final String first_name;
  final String last_name;
  final String email;
  final String gender;
  final String from;
  final String tel;
  final id;
  const Menu(
      {Key? key,
      required this.user,
      required this.first_name,
      required this.last_name,
      required this.email,
      required this.gender,
      required this.from,
      required this.tel,
      required this.id})
      : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Responsive(
        mobile: Mcard(
          username: widget.user,
          email: widget.email,
          first_name: widget.first_name,
          last_name: widget.last_name,
          gender: widget.gender,
          from: widget.from,
          tel: widget.tel,
          id: widget.id,
        ),
        tablet: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 715,
              child: card_Tab(
                username: widget.user,
                email: widget.email,
                first_name: widget.first_name,
                last_name: widget.last_name,
                gender: widget.gender,
                from: widget.from,
                tel: widget.tel,
                id: widget.id,
              ),
            ),
          ],
        ),
        phone: SizedBox(
          //color: Colors.red,
          width: 300,
          child: Scard(
            username: widget.user,
            email: widget.email,
            first_name: widget.first_name,
            last_name: widget.last_name,
            gender: widget.gender,
            from: widget.from,
            tel: widget.tel,
            id: widget.id,
          ),
        ),
        desktop: Mcard(
          username: widget.user,
          email: widget.email,
          first_name: widget.first_name,
          last_name: widget.last_name,
          gender: widget.gender,
          from: widget.from,
          tel: widget.tel,
          id: widget.id,
        ),
      ),
    );
  }
}

class Scard extends StatefulWidget {
  final String username;
  final String first_name;
  final String last_name;
  final String email;
  final String gender;
  final String from;
  final String tel;
  final String id;
  const Scard({
    Key? key,
    required this.id,
    required this.username,
    required this.first_name,
    required this.last_name,
    required this.email,
    required this.gender,
    required this.from,
    required this.tel,
  }) : super(key: key);

  @override
  State<Scard> createState() => _ScardState();
}

class _ScardState extends State<Scard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Wrap(
        spacing: 10.0,
        runSpacing: 10.0,
        children: <Widget>[
          SCard(
            svgPic: 'assets/icons/addverbal.svg',
            title: 'Auto Verbal',
            press: () {
              setState(() {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return Menu_Add_verbal(
                        id: widget.id,
                      );
                    },
                  ),
                );
              });
            },
          ),
          SCard(
            svgPic: 'assets/icons/verballist.svg',
            title: 'Verbal List',
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return Menu_of_Autoverval(
                      id: widget.id,
                    );
                  },
                ),
              );
            },
          ),
          // SCard(
          //   svgPic: 'assets/icons/property.svg',
          //   title: 'Property',
          //   press: () {
          //     Navigator.push(context, MaterialPageRoute(
          //       builder: (context) {
          //         return Home_Screen_property();
          //       },
          //     ));
          //   },
          // ),
          SCard(
            svgPic: 'assets/icons/list-property.svg',
            title: 'Comparible',
            press: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return Add_with_property(
                                id: widget.id,
                              );
                },
              ));
            },
            
          ),
        ],
      ),
    );
  }
}

class SCard extends StatelessWidget {
  final String svgPic;
  final String title;
  final press;
  const SCard({
    Key? key,
    required this.svgPic,
    required this.title,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 90,
          width: 92,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [kDefaultShadow],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: press,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 47,
                    width: 47,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SvgPicture.asset(
                        svgPic,
                        color: kImageColor,
                      ),
                    ),
                  ),
                  Text(
                    title,
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
