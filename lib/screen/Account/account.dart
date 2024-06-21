// ignore_for_file: prefer_const_constructors, import_of_legacy_library_into_null_safe, prefer_const_literals_to_create_immutables, deprecated_member_use, must_be_immutable, use_build_context_synchronously, non_constant_identifier_names, unused_field, unused_local_variable, prefer_typing_uninitialized_variables, unnecessary_string_interpolations, unused_import

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:getwidget/getwidget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kfa_mobilenu/helper/build_context_helper.dart';
import 'package:kfa_mobilenu/models/user_model.dart';
import 'package:kfa_mobilenu/providers/auth_provider.dart';
import 'package:kfa_mobilenu/providers/cache_provider.dart';
import 'package:kfa_mobilenu/widgets/auth_wrapper_widget.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Memory_local/Local_data.dart';
import '../../afa/components/contants.dart';
import '../../afa/screens/Auth/login_page.dart';
import '../../api/api_service.dart';
import '../../contants.dart';
import '../../models/register_model.dart';
import '../Profile/components/FieldBox.dart';
import '../Profile/components/TwinBox.dart';
import '../Profile/components/singleBox.dart';

class Account extends ConsumerStatefulWidget {
  const Account({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<Account> createState() => _AccountState();
}

class _AccountState extends ConsumerState<Account> {
//update data from api
  String url =
      "https://www.oneclickonedollar.com/laravel_kfa_2023/public/api/users";

//get image and crop
  String? _imagepath;
  File? _imagefile;
  bool _isObscure = true;
  final ImagePicker _picker = ImagePicker();
  final ImageCropper _cropper = ImageCropper();
  var bank = [
    'Bank',
    'Private',
    'Other',
  ];
  Random random = Random();
  Future<void> uploadImage() async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(
        'https://www.oneclickonedollar.com/laravel_kfa_2023/public/api/set_profile_user',
      ),
    );
    request.fields['id_user'] = set_id_user ?? '';
    request.files.add(
      http.MultipartFile.fromBytes(
        'image',
        imagebytes!,
        filename: 'User ID :$set_id_user photo ${random.nextInt(999)}.jpg',
      ),
    );

    final res = await request.send();
  }

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

  List list_User_by_id = [];
  var set_id_user;
  void get_control_user_image(String id) async {
    final rs = await http.get(
      Uri.parse(
        'https://www.oneclickonedollar.com/laravel_kfa_2023/public/api/user/$id',
      ),
    );
    if (rs.statusCode == 200) {
      setState(() {
        final jsonData = jsonDecode(rs.body);
        list_User_by_id = jsonData;
        if (list_User_by_id[0]['control_user'] != null) {
          url;
          set_id_user = list_User_by_id[0]['control_user'].toString();
          get_image(list_User_by_id[0]['control_user'].toString());
        }
      });
    }
  }

  void get_image(String id) async {
    setState(() {});
    final rs = await http.get(
      Uri.parse(
        'https://www.oneclickonedollar.com/laravel_kfa_2023/public/api/user_profile/$id',
      ),
    );
    if (rs.statusCode == 200) {
      final jsonData = jsonDecode(rs.body);
      setState(() {
        url = jsonData[0]['url'];
      });
    }
  }

  Future logOut() async {
    final prefs = ref.read(sharePrefProvider);
    prefs.clear();
    await ref.read(authProvider.notifier).logout();
    Fluttertoast.showToast(
      msg: 'Log Out',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      textColor: Colors.blue,
      fontSize: 20,
    );

    context.pushReplace((context) => Login(openAsPage: true));
  }

  static List<PeopleModel> list = [];
  RegisterRequestModel_update? requestModel;
  TextEditingController? Password;

  @override
  void initState() {
    super.initState();
    setState(() {
      // get_control_user_image;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider.select((value) => value?.user));

    final controller = TextEditingController(text: user?.username);
    return AuthWrapperWidget(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 245, 250, 246),
        appBar: AppBar(
          backgroundColor: kwhite_new,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.chevron_left,
              size: 35,
            ),
          ),
          title: Text(
            'Account',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          toolbarHeight: 70,
        ),
        body: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: double.infinity,
              maxHeight: 750,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        color: kwhite_new,
                        borderRadius: kBottomBorderRadius,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 50,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () async {
                                  await openImage();
                                  setState(() {
                                    _file;
                                  });
                                },
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    if (_file == null)
                                      GFAvatar(
                                        size: 65,
                                        backgroundImage: NetworkImage('$url'),
                                      ),
                                    if (_file != null)
                                      GFAvatar(
                                        size: 65,
                                        backgroundImage:
                                            MemoryImage(imagebytes!),
                                      ),
                                    Container(
                                      height: 20,
                                      width: 50,
                                      alignment: Alignment.bottomCenter,
                                      decoration: BoxDecoration(
                                        color: Color.fromARGB(95, 67, 67, 67),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Icon(
                                        // ignore: unnecessary_null_comparison
                                        (url != null) ? Icons.edit : Icons.crop,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    // controller: controller,
                                    'Name : ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    // controller: controller,
                                    'Name : ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  // if (list_User_by_id.isNotEmpty)
                                  //   Text(
                                  //     'ID : ${list_User_by_id[0]['control_user'] ?? ''}',
                                  //     style: TextStyle(
                                  //         color: Colors.white,
                                  //         fontSize: 18,
                                  //         fontWeight: FontWeight.bold),
                                  //   )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        TwinBox(
                          labelText1: 'Firstname',
                          labelText2: 'Lastname',
                          fname: '',
                          lname: '',
                          get_fname: (value) {
                            setState(() {
                              requestModel!.first_name = value;
                            });
                          },
                          get_lname: (value) {
                            setState(() {
                              requestModel!.last_name = value;
                            });
                          },
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        //
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     Dropdown(
                        //       gender: widget.gender,
                        //       get_gender: (value) {
                        //         setState(() {
                        //           requestModel!.gender = value;
                        //         });
                        //       },
                        //     ),
                        //     SizedBox(
                        //       width: 6,
                        //     ),
                        //     // បិទសឹនបើមានការUpdate ដោយអនុញ្ញាតិអោយគេអាចធ្វើការកែប្រែបានចាំបើក​ SizedBoxខាងក្រោម ។
                        //     SizedBox(
                        //       height: 59,
                        //       width: 140,
                        //       child: DropdownButtonFormField<String>(
                        //         onChanged: (String? newValue) {
                        //           setState(() {
                        //             requestModel!.known_from = newValue!;
                        //           });
                        //         },
                        //         // validator: (String? value) {
                        //         //   if (value?.isEmpty ?? true) {
                        //         //     return 'Please select bank';
                        //         //   }
                        //         //   return null;
                        //         // },
                        //         value: widget.from,
                        //         items: bank
                        //             .map<DropdownMenuItem<String>>(
                        //               (String value) =>
                        //                   DropdownMenuItem<String>(
                        //                 value: value,
                        //                 child: Text(value),
                        //               ),
                        //             )
                        //             .toList(),
                        //         // add extra sugar..
                        //         icon: Icon(
                        //           Icons.arrow_drop_down,
                        //           color: kwhite_new,
                        //         ),

                        //         decoration: InputDecoration(
                        //           fillColor: Colors.white,
                        //           filled: true,
                        //           labelText: 'Bank',
                        //           hintText: 'Select',
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        SizedBox(
                          height: 2,
                        ),
                        SingleBox(
                          phone: '',
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Field_box(
                          name: 'email',
                          email: '',
                          get_email: (value) {
                            setState(() {
                              requestModel!.email = value;
                            });
                          },
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        if (Password != null)
                          SizedBox(
                            height: 60,
                            width: 280,
                            child: TextFormField(
                              controller: Password,
                              // initialValue: "list[0].password",
                              onChanged: (input) {
                                setState(() {
                                  requestModel!.password = input;
                                });
                              },
                              obscureText: _isObscure,
                              decoration: InputDecoration(
                                fillColor: Color.fromARGB(255, 255, 255, 255),
                                filled: true,
                                labelText: 'Your Password',
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    color: Color.fromRGBO(169, 203, 56, 1),
                                    _isObscure
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isObscure = !_isObscure;
                                    });
                                  },
                                ),
                              ),
                              validator: (input) {
                                if (input == null || input.isEmpty) {
                                  return 'require *';
                                }
                                return null;
                              },
                            ),
                          ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(60.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            child: Text('Save Change'),
                            onPressed: () async {
                              if (_file != null) {
                                await uploadImage();
                              }
                              final APIservice apIservice = APIservice();
                              await apIservice.update_user(
                                requestModel!,
                                user!.id ?? 0,
                              );
                              logOut();
                            },
                          ),
                          SizedBox(width: 15),
                          ElevatedButton(
                            child: Text('Log Out'),
                            onPressed: () {
                              logOut();
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),

                // Column(
                //   children: [

                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EditPicture extends StatelessWidget {
  final String title;
  final icon;
  final press;
  const EditPicture({
    Key? key,
    required this.title,
    required this.icon,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListBody(
      children: [
        InkWell(
          onTap: press,
          splashColor: Colors.lightBlue,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Icon(
                  icon,
                  color: kwhite_new,
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

// UpdateUserInfo()async{
//   var username =
// }
