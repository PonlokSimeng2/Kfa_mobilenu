// ignore_for_file: file_names, prefer_const_constructors, non_constant_identifier_names, avoid_print, prefer_interpolation_to_compose_strings, prefer_const_literals_to_create_immutables, unnecessary_new, unused_local_variable, unnecessary_brace_in_string_interps, prefer_typing_uninitialized_variables, no_leading_underscores_for_local_identifiers, await_only_futures, unnecessary_null_comparison, empty_catches, unused_field, unrelated_type_equality_checks, sized_box_for_whitespace, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geolocator/geolocator.dart';
import 'package:getwidget/components/animation/gf_animation.dart';
import 'package:getwidget/types/gf_animation_type.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kfa_mobilenu/Memory_local/database.dart';
import 'package:kfa_mobilenu/afa/screens/AutoVerbal/printer/save_image_for_Autoverbal.dart';
import 'package:kfa_mobilenu/providers/auth_provider.dart';
import 'package:kfa_mobilenu/providers/v_point_provider.dart';
import 'package:kfa_mobilenu/screen/components/LandBuilding.dart';
import 'package:kfa_mobilenu/screen/payment/top_up.dart';
import 'package:kfa_mobilenu/widgets/auth_wrapper_widget.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../contants.dart';
import '../../../api/api_service.dart';
import '../../../models/autoVerbal.dart';
import '../../../models/model_bl_new.dart';
import '../../../models/user_model.dart';
import '../../../screen/Customs/form.dart';
import '../../../screen/Customs/formTwinN.dart';
import '../../../screen/Profile/components/Drop.dart';
import '../../../screen/components/code.dart';
import '../../../screen/components/comment.dart';
import '../../../screen/components/map_all/map_in_add_verbal.dart';
import '../../../screen/components/property.dart';

class AddAutoVerbalPage extends ConsumerWidget {
  const AddAutoVerbalPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AuthWrapperWidget(child: _AddAutoVerbalPage());
  }
}

// ===========================          Add_Auto       =====================
class _AddAutoVerbalPage extends ConsumerStatefulWidget {
  const _AddAutoVerbalPage();

  @override
  ConsumerState<_AddAutoVerbalPage> createState() => __AddAutoVerbalPageState();
}

class __AddAutoVerbalPageState extends ConsumerState<_AddAutoVerbalPage>
    with SingleTickerProviderStateMixin {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  String fromValue = 'Bank';
  String genderValue = 'Female';
  int? opt;
  var verbal_id;
  double asking_price = 1;
  Uint8List? get_image_byte;
  String address = '';
  String propertyType = '', propertyTypeValue = '';
  var code = 0;
  TextEditingController dateinput = TextEditingController();
  late AutoVerbalRequestModel requestModelAuto;
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.elasticOut,
  );
  var from = [
    'Bank',
    'Private',
    'Other',
  ];
  var gender = [
    'Female',
    'Male',
    'Other',
  ];
  var district;

  late List<dynamic> list_Khan;
  MyDb mydb_lb = new MyDb();
  MyDb mydb_vb = new MyDb();
  int id_khan = 0;
  double? lat1;
  double? log2;
  var a;
  String? filePath;
  String? control_user;
  var opt_type_id = '0';
  var list;
  List<L_B> lb = [L_B('null', 'null', 'null', 'null', '', 0, 0, 0, 0, 0)];
  void deleteItemToList(int Id) {
    setState(() {
      lb.removeAt(Id);
    });
  }

  Future<void> payment_done(BuildContext context) async {
    final Data = {
      "id_user_control": control_user.toString(),
      "count_autoverbal": "-1",
    };
    final response = await http.post(
      Uri.parse(
        'https://www.oneclickonedollar.com/laravel_kfa_2023/public/api/updart_count_verbal/0',
      ),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(Data),
    );
    if (response.statusCode == 200) {
      AwesomeDialog(
        context: context,
        animType: AnimType.leftSlide,
        headerAnimationLoop: false,
        dialogType: DialogType.success,
        showCloseIcon: false,
        // title: value.message,
        autoHide: Duration(seconds: 10),
        body: Center(
          child: Text("Do you want to save photo"),
        ),
        btnOkOnPress: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => save_image_after_add_verbal(
                set_data_verbal: code.toString(),
              ),
            ),
          );
        },
        btnCancelOnPress: () {
          Navigator.pop(context);
        },
        onDismissCallback: (type) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return AddAutoVerbalPage();
              },
            ),
          );
        },
      ).show();
    }
  }

  var chars = "abcdefghijklmnopqrstuvwxyz0123456789";
  String RandomString(int strlen) {
    Random rnd = new Random(new DateTime.now().millisecondsSinceEpoch);
    String result = "";
    for (var i = 0; i < strlen; i++) {
      result += chars[rnd.nextInt(chars.length)];
    }
    return result;
  }

  File? file;
  Uint8List? get_bytes;

  late AnimationController controller;
  late Animation<double> animation;
  late Animation<Offset> offsetAnimation;
  var id_verbal;
  var formatter = NumberFormat("##,###,###,###", "en_US");

  late final UserModel user;

  @override
  void initState() {
    user = ref.read(authProvider)!.user;
    verbal_id = user.controlUser + RandomString(9);
    _getCurrentPosition();
    addVerbal(context);
    lat1;
    log2;
    controller =
        AnimationController(duration: Duration(milliseconds: 645), vsync: this);
    animation = new CurvedAnimation(parent: controller, curve: Curves.linear);
    controller.repeat();
    offsetAnimation = Tween<Offset>(
      begin: Offset(0, 0),
      end: const Offset(0, -0.3),
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeIn,
      ),
    );
    lb;

    super.initState();

    requestModelAuto = AutoVerbalRequestModel(
      property_type_id: "",
      lat: "",
      lng: "",
      address: '',
      approve_id: "",
      agent: "",
      bank_branch_id: "",
      bank_contact: "",
      bank_id: "",
      bank_officer: "",
      code: "",
      comment: "",
      contact: "",
      date: "",
      image: "",
      option: "",
      owner: "",
      user: "",
      verbal_com: '',
      verbal_con: "30",
      verbal: [],
      verbal_id: '0',
      verbal_khan: '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthWrapperWidget(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(235, 7, 9, 145),
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
          actions: <Widget>[
            InkWell(
              onTap: () async {
                final number = await ref.read(vPointProvider.future);
                setState(() {
                  requestModelAuto.user = user.id.toString();
                  requestModelAuto.verbal_id = code.toString();
                  requestModelAuto.verbal_khan = '${commune}.${district}';
                });
                List<Map<String, dynamic>> jsonList =
                    lb.map((item) => item.toJson()).toList();
                if (number! >= 1) {
                  Uint8List? imagebytes =
                      await FlutterImageCompress.compressWithFile(
                    _image!.absolute.path,
                    minHeight: 1280,
                    minWidth: 720,
                    quality: 80,
                  );
                  String base64string = base64.encode(imagebytes!);
                  requestModelAuto.image = base64string;
                  requestModelAuto.verbal = jsonList;
                  APIservice apIservice = APIservice();
                  apIservice.saveAutoVerbal(requestModelAuto).then(
                    (value) async {
                      if (requestModelAuto.verbal.isEmpty) {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          headerAnimationLoop: false,
                          title: 'Error',
                          desc: "Please add Land/Building at least 1!",
                          btnOkOnPress: () {},
                          btnOkIcon: Icons.cancel,
                          btnOkColor: Colors.red,
                        ).show();
                      } else {
                        if (value.message == "Save Successfully") {
                          if (_file != null) {
                            uploadt_image(_file!);
                          }
                          uploadt_image_map();
                          const snackBar = SnackBar(
                            content: Text('processing payment...'),
                            duration: Duration(seconds: 7),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          payment_done(context);
                        } else {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.rightSlide,
                            headerAnimationLoop: false,
                            title: 'Error',
                            desc: value.message,
                            btnOkOnPress: () {},
                            btnOkIcon: Icons.cancel,
                            btnOkColor: Colors.red,
                          ).show();
                        }
                      }
                    },
                  );
                } else {
                  if (jsonList.length <= 1) {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.error,
                      animType: AnimType.rightSlide,
                      headerAnimationLoop: false,
                      title: 'Error',
                      desc: "Please add Land/Building at least 1!",
                      btnOkOnPress: () {},
                      btnOkIcon: Icons.cancel,
                      btnOkColor: Colors.red,
                    ).show();
                  } else {
                    int lb = 0, vb = 0;
                    for (int i = 1; i < jsonList.length; i++) {
                      lb = await mydb_lb.db.rawInsert(
                          "INSERT INTO comverbal_land_models (verbal_landid, verbal_land_dp, verbal_land_type, verbal_land_des, verbal_land_area, verbal_land_minsqm, verbal_land_maxsqm, verbal_land_minvalue, verbal_land_maxvalue, address) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?);",
                          [
                            verbal_id.toString(),
                            int.parse(jsonList[i]['verbal_land_dp']),
                            (jsonList[i]['verbal_land_type'].toString() ?? "0"),
                            (jsonList[i]['verbal_land_des'].toString() ?? "0"),
                            double.parse(
                              jsonList[i]['verbal_land_area'].toString(),
                            ),
                            double.parse(
                              jsonList[i]['verbal_land_minsqm'].toString(),
                            ),
                            double.parse(
                              jsonList[i]['verbal_land_maxsqm'].toString(),
                            ),
                            double.parse(
                              jsonList[i]['verbal_land_minvalue'].toString(),
                            ),
                            double.parse(
                              jsonList[i]['verbal_land_maxvalue'].toString(),
                            ),
                            (jsonList[i]['address'].toString() ?? "0")
                          ]);
                    }
                    if (_image != null) {
                      Uint8List? imagebytes =
                          await FlutterImageCompress.compressWithFile(
                        _image!.absolute.path,
                        minHeight: 1280,
                        minWidth: 720,
                        quality: 80,
                      );
                      String base64string = base64.encode(imagebytes!);
                      vb = await mydb_vb.db.rawInsert(
                          "INSERT INTO verbal_models (verbal_id, verbal_khan, verbal_property_id, verbal_bank_id, verbal_bank_branch_id, verbal_bank_contact, verbal_owner, verbal_contact, verbal_date, verbal_bank_officer,verbal_address,verbal_approve_id,VerifyAgent,verbal_comment,latlong_log,latlong_la,verbal_image,verbal_com,verbal_con,verbal_property_code,verbal_user,verbal_option) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?,?);",
                          [
                            verbal_id ?? "No",
                            requestModelAuto.verbal_khan,
                            requestModelAuto.property_type_id,
                            requestModelAuto.bank_id,
                            requestModelAuto.bank_branch_id,
                            requestModelAuto.bank_contact,
                            requestModelAuto.owner,
                            requestModelAuto.contact,
                            requestModelAuto.date,
                            requestModelAuto.bank_officer,
                            requestModelAuto.address,
                            requestModelAuto.approve_id,
                            requestModelAuto.agent,
                            requestModelAuto.comment,
                            requestModelAuto.lat,
                            requestModelAuto.lng,
                            base64string,
                            requestModelAuto.verbal_com,
                            requestModelAuto.verbal_con,
                            "No",
                            user.controlUser,
                            requestModelAuto.option
                          ]);
                    } else {
                      vb = await mydb_vb.db.rawInsert(
                          "INSERT INTO verbal_models (verbal_id, verbal_khan, verbal_property_id, verbal_bank_id, verbal_bank_branch_id, verbal_bank_contact, verbal_owner, verbal_contact, verbal_date, verbal_bank_officer,verbal_address,verbal_approve_id,VerifyAgent,verbal_comment,latlong_log,latlong_la,verbal_image ,verbal_com,verbal_con,verbal_property_code,verbal_user,verbal_option) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?, ?, ?, ?, ?, ?, ?, ?, ?,?,?);",
                          [
                            verbal_id,
                            requestModelAuto.verbal_khan,
                            requestModelAuto.property_type_id,
                            requestModelAuto.bank_id,
                            requestModelAuto.bank_branch_id,
                            requestModelAuto.bank_contact,
                            requestModelAuto.owner,
                            requestModelAuto.contact,
                            requestModelAuto.date,
                            requestModelAuto.bank_officer,
                            requestModelAuto.address,
                            requestModelAuto.approve_id,
                            requestModelAuto.agent,
                            requestModelAuto.comment,
                            requestModelAuto.lat,
                            requestModelAuto.lng,
                            "null",
                            requestModelAuto.verbal_com,
                            requestModelAuto.verbal_con,
                            "No",
                            user.controlUser,
                            requestModelAuto.option
                          ]);
                    }
                    setState(() {
                      if (lb == 1 && vb == 1) {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.success,
                          animType: AnimType.rightSlide,
                          headerAnimationLoop: false,
                          title: 'Success',
                          desc: "Please go to payment for processing this Data",
                          autoHide: Duration(seconds: 3),
                          onDismissCallback: (type) {
                            // debugPrint('Dialog Dissmiss from callback $type');

                            // Navigator.pushReplacement(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => ProtectDataCrossCheck(
                            //       id_user: user.controlUser,
                            //     ),
                            //   ),
                            // );
                          },
                        ).show();
                      } else if (lb == 0 && vb == 1) {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          headerAnimationLoop: false,
                          title: 'Error',
                          desc: "Please add Land/Building at least 1!",
                          btnOkOnPress: () {},
                          btnOkIcon: Icons.cancel,
                          btnOkColor: Colors.red,
                        ).show();
                      } else if (lb == 1 && vb == 0) {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          headerAnimationLoop: false,
                          title: 'Error',
                          desc: "Please check find that your input",
                          btnOkOnPress: () {},
                          btnOkIcon: Icons.cancel,
                          btnOkColor: Colors.red,
                        ).show();
                      } else {}
                    });
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TopUpPage(
                        set_phone: "",
                        id_user: user.id?.toString(),
                        set_id_user: user.controlUser,
                      ),
                    ),
                  );
                }
              },
              child: Container(
                margin: EdgeInsets.only(left: 5, top: 15, bottom: 15, right: 4),
                decoration: BoxDecoration(
                  color: Colors.lightGreen[700],
                  boxShadow: [BoxShadow(color: Colors.green, blurRadius: 5)],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(80),
                    bottomLeft: Radius.circular(80),
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Text("Submit"),
                    Icon(Icons.save_alt_outlined),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      width: 10,
                      height: 25,
                      decoration: BoxDecoration(
                        color: Colors.red[700],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          bottomLeft: Radius.circular(5),
                        ),
                      ),
                      alignment: Alignment.topRight,
                    )
                  ],
                ),
              ),
            ),
          ],
          title: DefaultTextStyle(
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            ),
            child: AnimatedTextKit(
              animatedTexts: [
                WavyAnimatedText(
                  'Auto Verbal',
                  textAlign: TextAlign.center,
                  textStyle: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 20,
                  ),
                ),
              ],
              pause: const Duration(milliseconds: 900),
              isRepeatingAnimation: true,
              repeatForever: true,
              onTap: () {},
            ),
          ),
          toolbarHeight: 80,
        ),
        backgroundColor: Color.fromARGB(235, 7, 9, 145),
        body: RefreshIndicator(
          onRefresh: () => ref.refresh(vPointProvider.future),
          child: Container(
            height: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: SingleChildScrollView(
              child: addVerbal(context),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.small(
          backgroundColor: Colors.white,
          onPressed: () {
            setState(() {
              _controller.dispose();
            });
          },
          child: ref.watch(vPointProvider).maybeWhen(
                orElse: () => SizedBox(
                  width: 15,
                  height: 15,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                data: (number) {
                  return Row(
                    children: [
                      Text(
                        '${number}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.amber[800],
                        ),
                      ),
                      Container(
                        height: 13,
                        width: 13,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/v.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
        ),
      ),
    );
  }

  Widget addVerbal(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10),
        Code(
          cd: verbal_id,
          code: (value) {
            setState(() {
              // code = value;
            });
          },
          check_property: 1,
        ),
        if (lat != null && lat1 == null)
          InkWell(
            onTap: () async {
              await SlideUp(context);
            },
            child: Container(
              height: 180,
              width: MediaQuery.of(context).size.width * 1,
              margin: EdgeInsets.only(top: 15, right: 13, left: 15),
              child: FadeInImage.assetNetwork(
                placeholderCacheHeight: 120,
                placeholderCacheWidth: 120,
                fit: BoxFit.cover,
                placeholderFit: BoxFit.contain,
                placeholder: 'assets/earth.gif',
                image:
                    'https://maps.googleapis.com/maps/api/staticmap?center=${lat},${log}&zoom=20&size=1080x920&maptype=hybrid&markers=color:red%7C%7C${lat},${log}&key=AIzaSyAJt0Zghbk3qm_ZClIQOYeUT0AaV5TeOsI',
              ),
            ),
          )
        else if (lat1 != null)
          InkWell(
            onTap: () async {
              await SlideUp(context);
            },
            child: Container(
              height: 180,
              width: MediaQuery.of(context).size.width * 1,
              margin: EdgeInsets.only(top: 15, right: 13, left: 15),
              child: FadeInImage.assetNetwork(
                placeholderCacheHeight: 50,
                placeholderCacheWidth: 50,
                fit: BoxFit.cover,
                placeholderFit: BoxFit.fill,
                placeholder: 'assets/earth.gif',
                image:
                    'https://maps.googleapis.com/maps/api/staticmap?center=${lat1},${log2}&zoom=20&size=1080x920&maptype=hybrid&markers=color:red%7C%7C${lat1},${log2}&key=AIzaSyAJt0Zghbk3qm_ZClIQOYeUT0AaV5TeOsI',
              ),
            ),
          )
        else
          SizedBox(height: 12),
        SizedBox(height: 12),
        CommentAndOption(
          value: (value) {
            setState(() {
              opt = int.parse(value);
            });
          },
          comment1: (opt != null) ? opt.toString() : null,
          id: (value) {
            setState(() {
              requestModelAuto.option = value.toString();
            });
          },
          comment: (newValue) {
            setState(() {
              requestModelAuto.comment = newValue!.toString();
            });
          },
          opt_type_id: (value) {
            setState(() {
              opt_type_id = value.toString();
            });
          },
        ),
        if (id_khan != 0)
          InkWell(
            onTap: () {
              _asyncInputDialog(context);
              ++i;
            },
            child: Container(
              height: 37,
              margin: EdgeInsets.fromLTRB(30, 5, 30, 0),
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent[700],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Text("land~Building"),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: DefaultTextStyle(
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontFamily: 'Horizon',
                        fontWeight: FontWeight.bold,
                      ),
                      child: AnimatedTextKit(
                        animatedTexts: [
                          RotateAnimatedText('land'),
                          RotateAnimatedText('Building'),
                        ],
                        pause: const Duration(milliseconds: 100),
                        repeatForever: true,
                      ),
                    ),
                  ),
                  GFAnimation(
                    controller: controller,
                    slidePosition: offsetAnimation,
                    type: GFAnimationType.slideTransition,
                    child: Icon(
                      Icons.add_circle_outline,
                      color: Colors.white,
                      size: 30,
                      shadows: [Shadow(blurRadius: 5, color: Colors.black)],
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (i >= 0)
          Container(
            width: 500,
            height: (lb.length > 1) ? 280 : 0,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (int i = 1; i < lb.length; i++)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Container(
                        width: 290,
                        //height: 210,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: kPrimaryColor),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        '${lb[i].verbal_land_type} ',
                                        style: NameProperty(),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                            size: 30,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              deleteItemToList(i);
                                            });
                                          },
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 3.0,
                            ),
                            Divider(
                              height: 1,
                              thickness: 1,
                              color: kPrimaryColor,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              '${lb[i].address} ',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Depreciation",
                                      style: Label(),
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      "Floor",
                                      style: Label(),
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      "Area",
                                      style: Label(),
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      'Min Value/Sqm',
                                      style: Label(),
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      'Max Value/Sqm',
                                      style: Label(),
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      'Min Value',
                                      style: Label(),
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      'Man Value',
                                      style: Label(),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 15),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 4),
                                    Text(
                                      ':   ' + lb[i].verbal_land_dp,
                                      style: Name(),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      ':   ' + lb[i].verbal_land_des,
                                      style: Name(),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      ':   ' +
                                          (formatter.format(
                                            lb[i].verbal_land_area.toInt(),
                                          )).toString() +
                                          'm' +
                                          '\u00B2',
                                      style: Name(),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      ':   ' +
                                          (lb[i].verbal_land_minsqm)
                                              .toString() +
                                          '\$',
                                      style: Name(),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      ':   ' +
                                          (lb[i].verbal_land_maxsqm)
                                              .toString() +
                                          '\$',
                                      style: Name(),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      ':   ' +
                                          (formatter.format(
                                            lb[i].verbal_land_minvalue,
                                          )).toString() +
                                          '\$',
                                      style: Name(),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      ':   ' +
                                          (formatter
                                                  .format(
                                                    lb[i].verbal_land_maxvalue,
                                                  )
                                                  .toString() +
                                              '\$'),
                                      style: Name(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        SizedBox(
          height: 10.0,
        ),
        Column(
          children: [
            if (_file != null)
              Container(
                height: 200,
                width: 400,
                // child: Image.file(File(_file!.path)),
                child: Image.memory(imagebytes!),
              ),
            // if (_file == null)
            TextButton(
              onPressed: () async {
                await openImage();
                setState(() {
                  _file;
                });
              },
              child: FractionallySizedBox(
                widthFactor: 1,
                child: Padding(
                  padding: const EdgeInsets.only(left: 22, right: 22),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: kPrimaryColor,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    // padding: EdgeInsets.only(left: 30, right: 30),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          SizedBox(width: 10),
                          Icon(
                            Icons.map_sharp,
                            color: kImageColor,
                          ),
                          SizedBox(width: 10),
                          Text(
                            (imagepath == "")
                                ? 'Choose Photo'
                                : 'choosed Photo',
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 5.0,
        ),
        PropertyDropdown(
          name: (value) {
            propertyType = value;
          },
          id: (value) {
            requestModelAuto.property_type_id = value;
          },
          // pro: list[0]['property_type_name'],
        ),

        BankDropdown(
          bank: (value) {
            requestModelAuto.bank_id = value;
          },
          bankbranch: (value) {
            requestModelAuto.bank_branch_id = value;
          },
        ),
        SizedBox(
          height: 5.0,
        ),
        FormTwinN(
          Label1: 'Owner',
          Label2: 'Contact',
          onSaved1: (input) {
            requestModelAuto.owner = input!;
          },
          onSaved2: (input) {
            requestModelAuto.contact = input!;
          },
          icon1: Icon(
            Icons.person,
            color: kImageColor,
          ),
          icon2: Icon(
            Icons.phone,
            color: kImageColor,
          ),
        ),
        SizedBox(
          height: 5.0,
        ),
        // DateComponents(
        //   date: (value) {
        //     requestModelAuto.date = value;
        //   },
        // ),

        FormTwinN(
          Label1: 'Bank Officer',
          Label2: 'Contact',
          onSaved1: (input) {
            requestModelAuto.bank_officer = input!;
          },
          onSaved2: (input) {
            setState(() {
              requestModelAuto.bank_contact = input!;
            });
          },
          icon1: Icon(
            Icons.work,
            color: kImageColor,
          ),
          icon2: Icon(
            Icons.phone,
            color: kImageColor,
          ),
        ),

        SizedBox(
          height: 5,
        ),
        // ForceSaleAndValuation(
        //   value: (value) {
        //     requestModelAuto.verbal_con = value;
        //   },
        //   // fsl: list[0]['verbal_con'],
        // ),

        // ApprovebyAndVerifyby(
        //   approve: (value) {
        //     setState(() {
        //       requestModelAuto.approve_id = value.toString();
        //     });
        //   },
        //   verify: (value) {
        //     setState(() {
        //       requestModelAuto.agent = value.toString();
        //     });
        //   },
        //   // appro: list[0]['approve_name'],
        //   // vfy: list[0]['VerifyAgent'],
        // ),

        FormS(
          label: 'Phum optional',
          onSaved: (input) {
            requestModelAuto.address = input!.toString();
          },
          iconname: Icon(
            Icons.location_on_rounded,
            color: kImageColor,
          ),
        ),
        SizedBox(
          height: 3.0,
        ),
      ],
    );
  }

  var dropdown;
  String? options;
  String? commune;

  //MAP
  Future<void> SlideUp(BuildContext context) async {
//=============================================================
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Map_verbal_add(
          get_commune: (value) {
            setState(() {
              commune = value;
              Load_sangkat(value);
            });
          },
          get_district: (value) {
            setState(() {
              district = value;
              Load_khan(district);
            });
          },
          get_lat: (value) {
            setState(() {
              lat1 = double.parse(value);
              requestModelAuto.lat = value;
            });
          },
          get_log: (value) {
            setState(() {
              log2 = double.parse(value);
              requestModelAuto.lng = value;
            });
          },
          get_province: (value) {},
        ),
      ),
    );

    setState(() {
      requestModelAuto.image = code.toString();
    });
    if (!mounted) return;
  }

  Future<File> convertImageByteToFile(
    Uint8List imageBytes,
    String fileName,
  ) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final File file = File('$path/$fileName');
    await file.writeAsBytes(imageBytes);
    return file;
  }

  Random random = new Random();
  Future<dynamic> uploadt_image_map() async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(
        'https://www.oneclickonedollar.com/laravel_kfa_2023/public/api/set_image_map',
      ),
    );
    request.fields['cid'] = code.toString();
    if (lat1 == null) {
      final response1 = await http.get(
        Uri.parse(
          'https://maps.googleapis.com/maps/api/staticmap?center=${lat},${log}&zoom=20&size=720x720&maptype=hybrid&markers=color:red%7C%7C${lat},${log}&key=AIzaSyAJt0Zghbk3qm_ZClIQOYeUT0AaV5TeOsI',
        ),
      );
      final byte = response1.bodyBytes;
      final Uint8List get_image_byte1 = Uint8List.fromList(byte);
      request.files.add(
        await http.MultipartFile.fromBytes(
          'image',
          get_image_byte1,
          filename: 'k${random.nextInt(999)}f${random.nextInt(99)}a.png',
        ),
      );
    } else {
      final response2 = await http.get(
        Uri.parse(
          'https://maps.googleapis.com/maps/api/staticmap?center=${lat1},${log2}&zoom=20&size=720x720&maptype=hybrid&markers=color:red%7C%7C${lat1},${log2}&key=AIzaSyAJt0Zghbk3qm_ZClIQOYeUT0AaV5TeOsI',
        ),
      );
      final byte = response2.bodyBytes;
      final Uint8List get_image_byte2 = Uint8List.fromList(byte);
      request.files.add(
        await http.MultipartFile.fromBytes(
          'image',
          get_image_byte2,
          filename: 'k${random.nextInt(999)}f${random.nextInt(99)}a.png',
        ),
      );
    }

    final res = await request.send();
  }

//===================== Upload Image to MySql Server
  late File _image;
  final picker = ImagePicker();
  late String base64string;
  XFile? _file;
  Uint8List? imagebytes;
  final ImagePicker imgpicker = ImagePicker();
  String imagepath = "";
  Future openImage() async {
    try {
      XFile? pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      //you can use ImageCourse.camera for Camera capture
      if (pickedFile != null) {
        imagepath = pickedFile.path;
        CroppedFile? cropFile = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          uiSettings: [
            AndroidUiSettings(
              lockAspectRatio: false,
              backgroundColor: Colors.blue,
              initAspectRatio: CropAspectRatioPreset.original,
            )
          ],
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio16x9,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio5x3,
            CropAspectRatioPreset.ratio5x4,
            CropAspectRatioPreset.ratio7x5,
            CropAspectRatioPreset.square,
          ],
        );
        _file = XFile(cropFile!.path);
        // imagebytes = _file.path;
        // imagepath = pickedFile.path;
        File? imagefile = File(cropFile.path); //convert Path to File
        imagebytes = await imagefile.readAsBytes(); //convert to bytes
        final String base64string =
            base64.encode(imagebytes!); //convert bytes to base64 string
        final Uint8List decodedbytes = base64.decode(base64string);
        //decode base64 stirng to bytes
        setState(() {
          _file = imagefile as XFile;
        });
      } else {
        print("No image is selected.");
      }
    } catch (e) {
      print("error while picking file.");
    }
  }

  Future<dynamic> uploadt_image(XFile _image) async {
    final request = await http.MultipartRequest(
      "POST",
      Uri.parse(
        "https://www.oneclickonedollar.com/laravel_kfa_2023/public/api/set_image",
      ),
    );
    Map<String, String> headers = {
      "content-type": "application/json",
      "Connection": "keep-alive",
      "Accept-Encoding": " gzip"
    };
    request.headers.addAll(headers);
    // request.files.add(picture);
    request.fields['cid'] = code.toString();
    request.files.add(
      await http.MultipartFile.fromPath(
        "image",
        _image.path,
      ),
    );
    final response = await request.send();
    final responseData = await response.stream.toBytes();
    final result = String.fromCharCodes(responseData);
  }

  //get khan
  void Load_khan(String district) async {
    setState(() {});
    final rs = await http.get(
      Uri.parse(
        'https://www.oneclickonedollar.com/laravel_kfa_2023/public/api/khan?Khan_Name=${district}',
      ),
    );
    if (rs.statusCode == 200) {
      final jsonData = jsonDecode(rs.body);
      setState(() {
        list_Khan = jsonData;
        id_khan = int.parse(list_Khan[0]['Khan_ID'].toString());
      });
    }
  }

  var id_Sangkat;
  List<dynamic> list_sangkat = [];
  void Load_sangkat(String id) async {
    setState(() {});
    final rs = await http.get(
      Uri.parse(
        'https://www.oneclickonedollar.com/laravel_kfa_2023/public/api/sangkat?Sangkat_Name=${id}',
      ),
    );
    if (rs.statusCode == 200) {
      final jsonData = jsonDecode(rs.body);
      setState(() {
        list_sangkat = jsonData;
        id_Sangkat = int.parse(list_sangkat[0]['Sangkat_ID'].toString());
      });
    }
  }

  int i = 0;
  Future _asyncInputDialog(BuildContext context) async {
    return showDialog(
      context: context,
      useSafeArea: false,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          insetPadding:
              EdgeInsets.only(top: 30, left: 10, right: 15, bottom: 40),
          content: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width * 1,
              child: LandBuilding(
                ID_khan: id_khan.toString(),
                // asking_price: asking_price,
                opt: (opt != null) ? opt! : 0,
                address: '${commune} / ${district}',
                list: (value) {
                  setState(() {
                    requestModelAuto.verbal = value;
                  });
                },
                landId: code.toString(),
                Avt: (value) {
                  a = value;
                  setState(() {});
                },
                opt_type_id: opt_type_id.toString(),
                check_property: 1,
                list_lb: (value) {
                  setState(() {
                    lb.addAll(value!);
                  });
                },
                ID_sangkat: id_Sangkat.toString(),
              ),
            ),
          ),
        );
      },
    );
  }

  TextStyle Label() {
    return TextStyle(color: kPrimaryColor, fontSize: 13);
  }

  TextStyle Name() {
    return TextStyle(
      color: kImageColor,
      fontSize: 14,
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle NameProperty() {
    return TextStyle(
      color: kImageColor,
      fontSize: 11,
      fontWeight: FontWeight.bold,
    );
  }

  double? lat;
  double? log;
  String? _currentAddress;
  Position? _currentPosition;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Location services are disabled. Please enable the services',
          ),
        ),
      );
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied')),
        );
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Location permissions are permanently denied, we cannot request permissions.',
          ),
        ),
      );
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      lat = position.latitude;
      log = position.longitude;
      requestModelAuto.lat = lat.toString();
      requestModelAuto.lng = log.toString();
    });
    final response = await http.get(
      Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${lat},${log}&key=AIzaSyAJt0Zghbk3qm_ZClIQOYeUT0AaV5TeOsI',
      ),
    );

    if (response.statusCode == 200) {
      // Successful response
      final jsonResponse = json.decode(response.body);

      final List ls = jsonResponse['results'];
      List ac;
      bool check_sk = false, check_kn = false;
      for (int j = 0; j < ls.length; j++) {
        ac = jsonResponse['results'][j]['address_components'];
        for (int i = 0; i < ac.length; i++) {
          if (check_kn == false || check_sk == false) {
            if (jsonResponse['results'][j]['address_components'][i]['types']
                    [0] ==
                "political") {
              setState(() {
                check_kn = true;
                district = (jsonResponse['results'][j]['address_components'][i]
                    ['short_name']);
                Load_khan(district.toString());
              });
            }
            if (jsonResponse['results'][j]['address_components'][i]['types']
                    [0] ==
                "administrative_area_level_3") {
              setState(() {
                check_sk = true;
                commune = (jsonResponse['results'][j]['address_components'][i]
                    ['short_name']);
                Load_sangkat(commune.toString());
              });
            }
          }
        }
      }
    }
  }
}
