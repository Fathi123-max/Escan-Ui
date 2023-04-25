/*

import 'dart:async';
import 'dart:io';

import 'package:escan_ui/groups/helpers/app.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../bloc/groups_bloc/groups_bloc.dart';
import '../../bloc/groups_bloc/groups_event.dart';
import '../../data/models/groups.dart';
import '../../helpers/button_widget.dart';
import '../../helpers/customTextField.dart';

class AddGroupForm extends StatefulWidget {
  @override
  _AddGroupFormState createState() => _AddGroupFormState();
}

class _AddGroupFormState extends State<AddGroupForm> {
  final _formKeyGroup = GlobalKey<FormState>();
  final _groupNameController = TextEditingController();
  final _groupLinkController = TextEditingController();
  final _groupImageController = TextEditingController();
  final _groupMembersController = TextEditingController();
  List<GroupMember> _members = [];

  Future<File> loadAssetAsFile(String assetPath) async {
    final completer = Completer<File>();
    final fileStream =
        File('${(await getTemporaryDirectory()).path}/$assetPath');

    try {
      final bytes = await rootBundle.load(assetPath);
      final buffer = bytes.buffer;
      await fileStream.create(recursive: true);
      await fileStream.writeAsBytes(
          buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
      completer.complete(fileStream);
    } catch (error) {
      completer.completeError(error);
    }

    return completer.future;
  }

  @override
  void initState() {
    super.initState();
    groupImage = File("");
    storage = FirebaseStorage.instance;
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    _groupLinkController.dispose();
    _groupImageController.dispose();
    _groupMembersController.dispose();
    super.dispose();
  }

//! image frpm gallery
  File? groupImage;
  final picker = ImagePicker();
  String? imageUrl;
  FirebaseStorage? storage;

// Initialize the image picker
  final ImagePicker _picker = ImagePicker();

  /*

  
  void _copyGroupLink() async {
    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse(
          "https://firebasedynamiclinks.googleapis.com/v1/shortLinks?key=AIzaSyAZ9B_jnmkYC-HmcNAPZ8OxeiRsltBTof4"),
      uriPrefix: "https://jeras.page.link",
      androidParameters: const AndroidParameters(
        packageName: "com.app.jerasgroups",
        minimumVersion: 30,
      ),
      iosParameters: const IOSParameters(
        bundleId: "com.app.jerasgroups",
        appStoreId: "123456789",
        minimumVersion: "1.0.1",
      ),
      // googleAnalyticsParameters: const GoogleAnalyticsParameters(
      //   source: "twitter",
      //   medium: "social",
      //   campaign: "example-promo",
      // ),
      // socialMetaTagParameters: SocialMetaTagParameters(
      //   title: "Example of a Dynamic Link",
      //   imageUrl: Uri.parse("https://example.com/image.png"),
      // ),
    );
    final dynamicLink =
        await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);

    try {
      // Build a short dynamic link
      final dynamicLinkString = await dynamicLink.toString();
      // Copy the dynamic link to the clipboard
      await Clipboard.setData(ClipboardData(text: dynamicLinkString));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Link copied to clipboard.'),
        ),
      );
    } catch (e) {
      print('Error: $e');
    }
  }
void _copyGroupLink() async {
  // Create a dynamic link with the group ID
  final DynamicLinkParameters parameters = DynamicLinkParameters(
    uriPrefix: 'https://yourproject.page.link',
    link: Uri.parse('https://yourproject.com/group/${_groupNameController.text}'),
    androidParameters: AndroidParameters(
      packageName: 'yourproject.package.name',
      minimumVersion: 125,
    ),
  );

  try {
    // Build a short dynamic link
    final Uri dynamicLink = await parameters.buildShortLink();
    final String dynamicLinkString = dynamicLink.toString();

    // Copy the dynamic link to the clipboard
    await Clipboard.setData(ClipboardData(text: dynamicLinkString));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Link copied to clipboard.'),
      ),
    );
  } catch (e) {
    print('Error: $e');
  }
}
*/
  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        groupImage = File(pickedFile.path);
        print(pickedFile.path);
        imageUrl = pickedFile.path;
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Widget photo = const Icon(Icons.camera_alt);

    return IconButton(
      color: AppColors.pink,
      icon: const Icon(Icons.add_circle_outline),
      iconSize: 30,
      onPressed: () {
        showModalBottomSheet(
            barrierColor: const Color(0xff202020),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50))),
            isScrollControlled: true,
            enableDrag: true,
            useSafeArea: true,
            context: context,
            builder: (context) => Container(
                  decoration: const BoxDecoration(
                      color: Color(0xffffffff),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50))),
                  height: 700,
                  width: size.width,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 25, 30, 0),
                    child: Form(
                      key: _formKeyGroup,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              width: 78,
                              height: 7,
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(3.5)),
                                  color: Color(0xfff7f7f7))),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            // crossAxisAlignment:
                            //     CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Expanded(
                                  child: Text("addGroup",
                                      style: TextStyle(
                                          color: Color(0xff202020),
                                          fontWeight: FontWeight.w300,
                                          fontFamily: "Ithra",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 20),
                                      textAlign: TextAlign.right)),
                              const SizedBox(
                                width: 100,
                              ),
                              IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(Icons.close)),
                            ],
                          ),
                          const SizedBox(
                            height: 13,
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  imgFromGallery();
                                  setState(() {
                                    photo = ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Image.file(groupImage!,
                                            fit: BoxFit.cover,
                                            width: 70,
                                            height: 70));
                                  });
                                },
                                child: CircleAvatar(
                                    radius: 35,
                                    backgroundColor: const Color(0xffd3d3d3),
                                    child: photo),
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      top: 20, left: 15, right: 15),
                                  height: 120,
                                  width: size.width,
                                  child: TextFormField(
                                    validator: (val) {
                                      if (val!.isEmpty) {
                                        return 'required';
                                      }
                                      return null;
                                    },
                                    controller: _groupNameController,
                                    cursorColor: AppColors.pink,
                                    maxLength: 14,
                                    keyboardType: TextInputType.name,
                                    decoration: const InputDecoration(
                                        hintText: "enter group name",
                                        hintStyle: TextStyle(
                                            color: Color(0xffb8b4b4),
                                            fontWeight: FontWeight.w300,
                                            fontFamily: "Ithra",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 14.0),
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: AppColors.lightGrey))),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Text("addMembers",
                                  style: TextStyle(
                                      color: Color(0xff202020),
                                      fontWeight: FontWeight.w300,
                                      fontFamily: "Ithra",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 15.0),
                                  textAlign: TextAlign.right),
                            ],
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 100,
                            width: size.width,
                            child: PhoneInputGridView(
                              backGroundColor: const Color(0xfff7f7f7),
                              borderColor: Colors.transparent,
                              hint: "addNumber",
                              hintStyle: const TextStyle(
                                  color: Color(0xffb8b4b4),
                                  fontWeight: FontWeight.w300,
                                  fontFamily: "Ithra",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14.0),
                              prefixIcon: Icons.phone,
                            ),
                          ),
                          const SizedBox(height: 27),
                          CustomTextFieldWidget(
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'Link ';
                              }
                              return null;
                            },
                            controller: _groupLinkController,
                            suffixIcon: IconButton(
                              onPressed: () {
                                // _copyGroupLink();
                              },
                              icon: const Icon(Icons.copy,
                                  color: Color(0xff7b6c96)),
                            ),
                            backGroundColor: const Color(0xfff7f7f7),
                            borderColor: Colors.transparent,
                            hint: "copyLink",
                            hintStyle: const TextStyle(
                                color: Color(0xff7b6c96),
                                fontWeight: FontWeight.w300,
                                fontFamily: "Ithra",
                                fontStyle: FontStyle.normal,
                                fontSize: 14.0),
                            insidePadding:
                                const EdgeInsets.only(right: 5, left: 5),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          SizedBox(
                              width: 150,
                              child: CustomButton(
                                  backgroundColor: const Color(0xff7b6c96),
                                  radius: 50,
                                  title: "save",
                                  onTap: () async {
                                    // ScaffoldMessenger.of(context).showSnackBar(
                                    //     const SnackBar(
                                    //         content: Text("Watting")));

                                    if (_formKeyGroup.currentState!
                                        .validate()) {
                                      var groupName = _groupNameController.text;
                                      var groupLink = _groupLinkController.text;
                                      var consoltId = _groupNameController.text;
                                      var groupImageRef = storage!
                                          .ref()
                                          .child('path/to/groupImage');
                                      var groupImageUploadTask =
                                          groupImageRef.putFile(groupImage!);

                                      await groupImageUploadTask
                                          .whenComplete(() async {
                                        var groupImageURL = await groupImageRef
                                            .getDownloadURL();

                                        context.read<GroupBloc>().add(AddGroup(
                                              groupName: groupName,
                                              groupLink: groupLink,
                                              groupImage: groupImageURL,
                                              groupMembers: _members,
                                              consultId: consoltId,
                                            ));
                                        Navigator.of(context).pop();
                                        _groupLinkController.clear();
                                        _groupImageController.clear();
                                        _groupMembersController.clear();
                                        _groupNameController.clear();
                                      });
                                    }
                                  }))
                        ],
                      ),
                    ),
                  ),
                ));
      },
    );
  }
}

/*


                          CustomTextFieldWidget(
                            validator: (val) {
                              if (val!.isEmpty) {
                                return  (context, 'addMembers');
                              }
                              return null;
                            },
                            controller: _groupMembersController,
                            onEditingComplete: () {
                              setState(() {
                                var members = _groupMembersController.text
                                    .replaceAll(' ', '')
                                    .split(',');
                                _members = members
                                    .map((member) => GroupMember(
                                        name: member, profileImage: ''))
                                    .toList();
                              });
                            },
                            prefixIcon: Icon(
                              Icons.phone,
                              color: const Color(0xff202020),
                            ),
                            backGroundColor: const Color(0xfff7f7f7),
                            borderColor: Colors.transparent,
                            hint: getTranslated(context, "addNumber"),
                            hintStyle: const TextStyle(
                                color: const Color(0xffb8b4b4),
                                fontWeight: FontWeight.w300,
                                fontFamily: "Ithra",
                                fontStyle: FontStyle.normal,
                                fontSize: 14.0),
                            insidePadding:
                                EdgeInsets.only(right: 5.h, left: 5.h),
                          ),
                      

 */
class PhoneInputGridView extends StatefulWidget {
  final String hint;
  final TextStyle hintStyle;
  final IconData prefixIcon;
  final Color backGroundColor;
  final Color borderColor;
  final Function(List<String>)? onMembersAdded;

  PhoneInputGridView({
    required this.hint,
    required this.hintStyle,
    required this.prefixIcon,
    required this.backGroundColor,
    required this.borderColor,
    this.onMembersAdded,
  });

  @override
  _PhoneInputGridViewState createState() => _PhoneInputGridViewState();
}

class _PhoneInputGridViewState extends State<PhoneInputGridView> {
  final List<String> _validNumbers = [];

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _controller,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: widget.hintStyle,
            prefixIcon: Icon(
              widget.prefixIcon,
              color: const Color(0xff202020),
            ),
            filled: true,
            fillColor: widget.backGroundColor,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 16.0,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: widget.borderColor),
              borderRadius: BorderRadius.circular(10.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: widget.borderColor),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          onFieldSubmitted: (value) {
            value = _controller.text.trim();
            final regex = RegExp(
              r"^(?:(?:\+|\b)[0-9]{1,3}\s*[\-\.\)\(\s]*\d{1,3}[\-\.\)\(\s]*|[0-9]{1,3}[\-\.\s]*)?\d{2,3}[\-\.\s]*\d{3,4}[\-\.\s]*\d{4}",
              caseSensitive: false,
              multiLine: false,
            );
            if (regex.hasMatch(value)) {
              _validNumbers.add(value);
              _controller.clear();
              if (widget.onMembersAdded != null) {
                widget.onMembersAdded!(_validNumbers);
              }
              setState(() {});
            }
          },
        ),
        Expanded(
          child: GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3),
            scrollDirection: Axis.vertical,
            children: _validNumbers.map((phoneNumber) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _validNumbers.remove(phoneNumber);
                    });
                    if (widget.onMembersAdded != null) {
                      widget.onMembersAdded!(_validNumbers);
                    }
                  },
                  child: Container(
                      height: 1,
                      width: 20,
                      color: Colors.amber,
                      child: Text(phoneNumber, textAlign: TextAlign.center)),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}































// class GroupBottomSheet extends StatefulWidget {
//   // const GroupBottomSheet(
//   //     {Key? key,
//   //     required this.iconButton,
//   //     required this.consultId,
//   //     required this.context})
//   //     : super(key: key);

//   // final Icon iconButton;
//   // final String consultId;
//   // final BuildContext context;
//   @override
//   State<GroupBottomSheet> createState() => _GroupBottomSheetState();
// }

// class _GroupBottomSheetState extends State<GroupBottomSheet> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   late Groups groups;
//   GroupsBloc? groupsBloc;
//   String? groupUid;
//   final _groupNameController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     groupsBloc = BlocProvider.of<GroupsBloc>(context);
//     groupsBloc!.stream.listen((state) {
//       if (state is LoadGroupsState) {
//         groups = state.groups;
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {}
// }












/*
AlertDialog(
      title: Text('Add Group'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _groupNameController,
              decoration: InputDecoration(labelText: 'Group Name'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a group name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _groupLinkController,
              decoration: InputDecoration(labelText: 'Group Link'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a group link';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _groupImageController,
              decoration: InputDecoration(labelText: 'Group Image URL'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a group image URL';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _groupMembersController,
              decoration: InputDecoration(labelText: 'Group Members'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter group members';
                }
                return null;
              },
              onEditingComplete: () {
                setState(() {
                  var members = _groupMembersController.text
                      .replaceAll(' ', '')
                      .split(',');
                  _members = members
                      .map((member) =>
                          GroupMember(name: member, profileImage: ''))
                      .toList();
                });
              },
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      var groupName = _groupNameController.text;
                      var groupLink = _groupLinkController.text;
                      var groupImage = _groupImageController.text;

                      context.read<GroupBloc>().add(AddGroup(
                            groupName: groupName,
                            groupLink: groupLink,
                            groupImage: groupImage,
                            groupMembers: _members,
                          ));

                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('Add'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
 
 */

 */
