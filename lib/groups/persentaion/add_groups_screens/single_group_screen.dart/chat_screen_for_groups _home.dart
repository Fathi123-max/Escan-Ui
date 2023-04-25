// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart' as intl;

// import 'package:uuid/uuid.dart';

// var image;
// File? selectedProfileImage;

// class ChatScreenForGroups extends StatefulWidget {
//   const ChatScreenForGroups(
//       {Key? key, required this.appointment, required this.user})
//       : super(key: key);
//   // final AppAppointments appointment;
//   // final GroceryUser user;

//   @override
//   State<ChatScreenForGroups> createState() => _ChatScreenForGroupsState();
// }

// class _ChatScreenForGroupsState extends State<ChatScreenForGroups> {
//   // PaginateRefreshedChangeListener refreshChangeListener =
//   //     PaginateRefreshedChangeListener();

//   final _scaffoldKey = GlobalKey<ScaffoldState>();
//   bool loading = false;
//   bool loadingCall = false, joinMeeting = false;
//   late String imageUrl;
//   var stCollection = 'messages', theme = "light";
//   ValueNotifier<String> text = ValueNotifier("");
//   late AccountBloc accountBloc;
//   final TextEditingController textEditingController =
//       new TextEditingController();
//   final ScrollController listScrollController = new ScrollController();
//   bool answered = false, done = true, endingCall = false;
//   bool checkAgora = false, uploadVideo = false;
//   final FocusNode focusNode = new FocusNode();
//   late Size size;
//   var _key = Key(DateTime.now().millisecondsSinceEpoch.toString());
//   late DocumentReference reference;
//   bool checkCall = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: true,

//       appBar: AppBarScreenForGroup(),
//       body: chatBody(context),

//       // bottomNavigationBar: ChatInput(),
//     );
//   }

// // Widget roundedButton(String buttonLabel, Color bgColor, Color textColor) {
// //   var loginBtn = new Container(
// //     padding: EdgeInsets.all(5.0),
// //     alignment: FractionalOffset.center,
// //     decoration: new BoxDecoration(
// //       color: bgColor,
// //       borderRadius: new BorderRadius.all(const Radius.circular(10.0)),
// //       boxShadow: <BoxShadow>[
// //         BoxShadow(
// //           color: const Color(0xFF696969),
// //           offset: Offset(1.0, 6.0),
// //           blurRadius: 0.001,
// //         ),
// //       ],
// //     ),
// //     child: Text(
// //       buttonLabel,
// //       style: new TextStyle(
// //           color: textColor, fontSize: 20.0, fontWeight: FontWeight.bold),
// //     ),
// //   );
// //   return loginBtn;
// // }

//   Widget chatBody(BuildContext context) {
//     return Column(
//       children: [
//         Expanded(
//           child: RefreshIndicator(
//             onRefresh: () async {
//               refreshChangeListener.refreshed = true;
//             },
//             child: StreamBuilder(
//               //? get messages from firebase
//               stream: FirebaseDatabase.instance
//                   .ref()
//                   .child(
//                       'appointmentsChatMessage/${widget.appointment.appointmentId}')
//                   .orderByChild('messageTime')
//                   .onValue,
//               builder: (ctx, snapshot) {
//                 print(
//                     "message after = ${snapshot.data}**************************************");
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 } else if (snapshot.data == null || !snapshot.hasData) {
//                   return Center(
//                     child: Text(getTranslated(context, "sendFirstMessage")),
//                   );
//                 } else if ((snapshot.data!).snapshot.value == null) {
//                   return Center(
//                     child: Text(getTranslated(context, "sendFirstMessage")),
//                   );
//                 } else {
//                   List<dynamic> messages = Map<String, dynamic>.from(
//                           (snapshot.data!).snapshot.value
//                               as Map<dynamic, dynamic>)
//                       .values
//                       .toList()
//                     //? sorting tekneek messages
//                     ..sort(
//                         (a, b) => a['messageTime'].compareTo(b['messageTime']));
//                   //? to make newer message dowen
//                   messages = messages.reversed.toList();

//                   return ListView.builder(
//                     shrinkWrap: true,
//                     reverse: true,
//                     padding: EdgeInsets.zero,
//                     controller: listScrollController,
//                     itemCount: messages.length,
//                     itemBuilder: (ctx, index) => AppointChatMessageItem(
//                         message: SupportMessage.fromDatabase(
//                           Map<String, dynamic>.from(messages[index]),
//                         ),
//                         user: widget.user),
//                   );
//                 }
//               },
//             ),
//           ),
//         ),
//         buildInput(size)
//       ],
//     );
//   }

//   Widget buildInput(Size size) {
//     return Container(
//       child: Row(
//         children: <Widget>[
//           // Button send image
//           Material(
//             child: new Container(
//               margin: new EdgeInsets.symmetric(horizontal: 1.0),
//               child: new IconButton(
//                 icon: new Icon(Icons.image),
//                 onPressed: () => cropImage(context),
//                 color: theme == "light"
//                     ? Theme.of(context).primaryColor
//                     : Colors.black,
//               ),
//             ),
//             color: Colors.white,
//           ),
//           // Button send video
//           uploadVideo
//               ? CircularProgressIndicator()
//               : Material(
//                   child: new Container(
//                     margin: new EdgeInsets.symmetric(horizontal: 1.0),
//                     child: new IconButton(
//                       icon: new Icon(Icons.video_camera_front_outlined),
//                       onPressed: () => uploadToStorage(context),
//                       color: theme == "light"
//                           ? Theme.of(context).primaryColor
//                           : Colors.white,
//                     ),
//                   ),
//                   color: Colors.white,
//                 ),
//           //record button
//           AudioRecorder(
//             onSendMessage: onSendMessage,
//             theme: theme,
//             focusNode: focusNode,
//             loggedId: widget.user.uid!,
//           ),

//           // Edit text
//           Flexible(
//             child: Container(
//               child: ValueListenableBuilder<String>(
//                 valueListenable: text,
//                 builder: (context, value, child) => Directionality(
//                   textDirection: intl.Bidi.detectRtlDirectionality(text.value)
//                       ? TextDirection.rtl
//                       : TextDirection.ltr,
//                   child: TextField(
//                     enableInteractiveSelection: true,
//                     keyboardType: TextInputType.multiline,
//                     maxLines: null,
//                     style: TextStyle(
//                         color: theme == "light"
//                             ? Theme.of(context).primaryColor
//                             : Colors.black,
//                         fontSize: 15.0),
//                     controller: textEditingController,
//                     decoration: InputDecoration.collapsed(
//                       hintText: getTranslated(context, "typeMessage"),
//                       hintStyle: TextStyle(color: Colors.grey),
//                     ),
//                     focusNode: focusNode,
//                     onChanged: (str) {
//                       text.value = str;
//                     },
//                   ),
//                 ),
//               ),
//             ),
//           ),

//           // Button send message
//           Material(
//             child: new Container(
//               margin: new EdgeInsets.symmetric(horizontal: 8.0),
//               child: loading
//                   ? Center(child: CircularProgressIndicator())
//                   : Container(
//                       height: 30,
//                       width: 30,
//                       alignment: Alignment.center,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: theme == "light"
//                             ? Theme.of(context).primaryColor
//                             : Colors.black,
//                       ),
//                       child: Center(
//                         child: new IconButton(
//                           icon: new Icon(
//                             Icons.send,
//                             color: Colors.white,
//                             size: 15,
//                           ),
//                           onPressed: () => onSendMessage(
//                               textEditingController.text, "text", size),
//                           color: theme == "light"
//                               ? Theme.of(context).primaryColor
//                               : Colors.black,
//                         ),
//                       ),
//                     ),
//             ),
//             color: Colors.white,
//           ),
//         ],
//       ),
//       width: double.infinity,
//       height: 50.0,
//       decoration: new BoxDecoration(
//           border:
//               new Border(top: new BorderSide(color: Colors.grey, width: 0.5)),
//           color: Colors.white),
//     );
//   }

//   Future<void> onSendMessage(String content, String type, Size size) async {
//     if (content.trim() != '') {
//       textEditingController.clear();
//       String messageId = Uuid().v4();

//       await UserDataProvider.realtimeDbRef
//           .child(
//               "appointmentsChatMessage/${widget.appointment.appointmentId}/$messageId")
//           .set({
//         'type': type,
//         'owner': widget.user.userType,
//         'message': content,
//         'messageTime': ServerValue.timestamp,
//         'messageTimeUtc': DateTime.now().toUtc().toString(),
//         'ownerName': widget.user.name,
//         'userUid': widget.user.uid,
//         'appointmentId': widget.appointment.appointmentId,
//       });

//       String data = getTranslated(context, "attatchment");
//       if (type == "text") data = content;
//       if (widget.user.userType == "CONSULTANT") {
//         await FirebaseFirestore.instance
//             .collection(Paths.appAppointments)
//             .doc(widget.appointment.appointmentId)
//             .set({
//           'consultChat': FieldValue.increment(1),
//         }, SetOptions(merge: true));
//         sendNotification(widget.appointment.user.uid!, data);
//       } else {
//         await FirebaseFirestore.instance
//             .collection(Paths.appAppointments)
//             .doc(widget.appointment.appointmentId)
//             .set({
//           'userChat': FieldValue.increment(1),
//         }, SetOptions(merge: true));
//         sendNotification(widget.appointment.consult.uid!, data);
//       }

//       //listScrollController.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
//       setState(() {
//         loading = false;
//         uploadVideo = false;
//       });
//     } else {
//       // Fluttertoast.showToast(msg: 'Nothing to send');
//     }
//   }

//   Future uploadToStorage(context) async {
//     try {
//       setState(() {
//         uploadVideo = true;
//       });
//       final pickedFile =
//           await ImagePicker.platform.pickVideo(source: ImageSource.gallery);
//       final file = File(pickedFile!.path);
//       var uuid = Uuid().v4();
//       Reference storageReference =
//           FirebaseStorage.instance.ref().child('files/$uuid');
//       await storageReference.putFile(file);
//       var url = await storageReference.getDownloadURL();
//       onSendMessage(url, "video", size);
//     } catch (error) {
//       print(error);
//     }
//   }

//   Future cropImage(context) async {
//     setState(() {
//       loading = true;
//     });
//     image = await ImagePicker().getImage(source: ImageSource.gallery);
//     File croppedFile = File(image.path);

//     if (croppedFile != null) {
//       print('File size: ' + croppedFile.lengthSync().toString());
//       uploadImage(croppedFile);
//       setState(() {
//         selectedProfileImage = croppedFile;
//       });
//       // signupBloc.add(PickedProfilePictureEvent(file: croppedFile));
//     } else {
//       //not croppped
//     }
//   }

//   Future<void> sendNotification(String userId, String text) async {
//     try {
//       Map notifMap = Map();
//       notifMap.putIfAbsent('title', () => "Chat");
//       notifMap.putIfAbsent('body', () => text);
//       notifMap.putIfAbsent('userId', () => userId);
//       notifMap.putIfAbsent(
//           'appointmentId', () => widget.appointment.appointmentId);
//       await http.post(
//         Uri.parse(
//             'https://us-central1-app-jeras.cloudfunctions.net/sendChatNotification'),
//         body: notifMap,
//       );
//     } catch (e) {
//       print("sendnotification111  " + e.toString());
//     }
//   }

//   Future uploadImage(File image) async {
//     Size size = MediaQuery.of(context).size;

//     var uuid = Uuid().v4();
//     Reference storageReference =
//         FirebaseStorage.instance.ref().child('profileImages/$uuid');
//     await storageReference.putFile(image);

//     var url = await storageReference.getDownloadURL();
//     onSendMessage(url, "image", size);
//   }
// }
