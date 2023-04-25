import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

var image;
File? selectedProfileImage;

class BottomGroupController extends StatefulWidget {
  const BottomGroupController({super.key});

  @override
  State<BottomGroupController> createState() => _BottomGroupControllerState();
}

class _BottomGroupControllerState extends State<BottomGroupController> {
  //!var
  // PaginateRefreshedChangeListener refreshChangeListener =
  //     PaginateRefreshedChangeListener();
  // final GroceryUser user = GroceryUser(phoneNumber: "", photoUrl: "");

  // final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool loading = false;
  bool loadingCall = false;
  late String imageUrl;
  var stCollection = 'messages', theme = "light";
  ValueNotifier<String> text = ValueNotifier("");
  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  bool answered = false, done = true, endingCall = false, pending = false;
  bool checkAgora = false;
  final FocusNode focusNode = FocusNode();
  String mobileNumber = '..';
  bool isRTL = false, uploadVideo = false;
  late Size size = MediaQuery.of(context).size;

  @override
  Widget build(BuildContext context) {
    return buildInput(size);
  }

  Widget buildInput(Size size) {
    return Container(
      width: double.infinity,
      height: 50.0,
      decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
          color: Colors.white),
      child: Row(
        children: <Widget>[
          // Button send image
          Material(
            color: Colors.white,
            child: SizedBox(
              width: 35,
              height: 35,
              child: Image.asset("assets/icons/photos.png"),
            ),
          ),

          // Button send video
          uploadVideo
              ? const CircularProgressIndicator()
              : Material(
                  color: Colors.white,
                  child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 1.0),
                      child: GestureDetector(
                        onTap: () => onSendMessage(
                            textEditingController.text, "text", size),
                        child: // Path 6926
                            SizedBox(
                          width: 30,
                          height: 35,
                          child: Image.asset("assets/icons/mic.png"),
                        ),
                      )),
                ),
          //record b,utton
          // AudioRecorder(
          //   onSendMessage: onSendMessage,
          //   theme: theme,
          //   focusNode: focusNode,
          //   // loggedId: widget.user.uid!,
          // ),

          // Edit ,

          // Flexible(
          //   child: Row(
          //     children: [
          //       Container(
          //         child: ValueListenableBuilder<String>(
          //           valueListenable: text,
          //           builder: (context, value, child) => Directionality(
          //             textDirection: TextDirection.rtl
          //             /* intl.Bidi.detectRtlDirectionality(text.value) */

          //             ,
          //             child: TextField(
          //               enableInteractiveSelection: true,
          //               keyboardType: TextInputType.multiline,
          //               maxLines: null,
          //               style: TextStyle(
          //                   color: theme == "light"
          //                       ? Theme.of(context).primaryColor
          //                       : Colors.black,
          //                   fontSize: 15.0),
          //               controller: textEditingController,
          //               decoration: InputDecoration.collapsed(
          //                 hintText: getTranslated(context, "typeMessage"),
          //                 hintStyle: TextStyle(color: Colors.grey),
          //               ),
          //               focusNode: focusNode,
          //               onChanged: (str) {
          //                 text.value = str;
          //               },
          //             ),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // Button send message

          Material(
            color: Colors.white,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : Container(
                      height: 30,
                      width: 30,
                      alignment: Alignment.center,
                      child: Center(
                        child: SizedBox(
                          width: 27,
                          height: 27,
                          child: Image.asset("assets/icons/send.png"),
                        ),

                        //  new IconButton(
                        //   icon: new Icon(
                        //     Icons.send,
                        //     color: Colors.white,
                        //     size: 15,
                        //   ),

                        //   onPressed: () => onSendMessage(
                        //       textEditingController.text, "text", size),
                        //   color: Theme.of(context).primaryColor,
                        // ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> onSendMessage(String content, String type, Size size) async {
    // FocusScope.of(context).unfocus();
    // if ((content.trim() != '' && type == "text") || type != "text") {
    //   textEditingController.clear();
    //   if (widget.user.userType == "SUPPORT") {
    //     await FirebaseFirestore.instance
    //         .collection("SupportList")
    //         .doc(widget.item.supportListId)
    //         .set({
    //       'userMessageNum': FieldValue.increment(1),
    //       'messageTime': FieldValue.serverTimestamp(),
    //       'lastMessage': type == "text"
    //           ? content
    //           : type == "image"
    //               ? "imageFile"
    //               : "voiceFile",
    //     }, SetOptions(merge: true));
    //   } else
    //     await FirebaseFirestore.instance
    //         .collection("SupportList")
    //         .doc(widget.item.supportListId)
    //         .set({
    //       'supportMessageNum': FieldValue.increment(1),
    //       'supportListStatus': false,
    //       'userName': widget.user.name,
    //       'messageTime': FieldValue.serverTimestamp(),
    //       'lastMessage': type == "text"
    //           ? content
    //           : type == "image"
    //               ? "imageFile"
    //               : "voiceFile",
    //     }, SetOptions(merge: true));
    //   String messageId = Uuid().v4();

    //   await UserDataProvider.realtimeDbRef
    //       .child("SupportMessage/${widget.item.supportListId}/$messageId")
    //       .set({
    //     'type': type,
    //     'owner': widget.user.userType,
    //     'message': content,
    //     'messageTime': ServerValue.timestamp,
    //     'messageTimeUtc': DateTime.now().toUtc().toString(),
    //     'ownerName': widget.user.name,
    //     'userUid': widget.user.uid,
    //     'supportId': widget.item.supportListId,
    //   });

    //listScrollController.animateTo(0.0,  duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    setState(() {
      loading = false;
      uploadVideo = false;
    });
  }

  Future uploadRecord(File voice) async {
    Size size = MediaQuery.of(context).size;

    var uuid = const Uuid().v4();
    Reference storageReference =
        FirebaseStorage.instance.ref().child('profileImages/$uuid');
    await storageReference.putFile(voice);

    var url = await storageReference.getDownloadURL();
    print("recording file222");
    print(url);
    onSendMessage(url, "voice", size);
  }

  Future uploadToStorage(context) async {
    try {
      setState(() {
        uploadVideo = true;
      });
      final pickedFile =
          await ImagePicker.platform.pickVideo(source: ImageSource.gallery);
      final file = File(pickedFile!.path);
      var uuid = const Uuid().v4();
      Reference storageReference =
          FirebaseStorage.instance.ref().child('files/$uuid');
      await storageReference.putFile(file);
      var url = await storageReference.getDownloadURL();
      onSendMessage(url, "video", size);
    } catch (error) {
      print(error);
    }
  }

  Future uploadImage(File image) async {
    Size size = MediaQuery.of(context).size;

    var uuid = const Uuid().v4();
    Reference storageReference =
        FirebaseStorage.instance.ref().child('profileImages/$uuid');
    await storageReference.putFile(image);

    var url = await storageReference.getDownloadURL();
    onSendMessage(url, "image", size);
  }

  Future cropImage(context) async {
    setState(() {
      loading = true;
    });
    image = await ImagePicker().getImage(source: ImageSource.gallery);
    File croppedFile = File(image.path);

    if (croppedFile != null) {
      print('File size: ' + croppedFile.lengthSync().toString());
      uploadImage(croppedFile);
      setState(() {
        selectedProfileImage = croppedFile;
      });
      // signupBloc.add(PickedProfilePictureEvent(file: croppedFile));
    } else {
      //not croppped
    }
  }
}

//=======
