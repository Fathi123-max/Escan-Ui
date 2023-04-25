// import 'package:auto_direction/auto_direction.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:flutter/foundation.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:fluttertoast/fluttertoast.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import 'package:intl/intl.dart';
// // import 'package:linkwell/linkwell.dart';
// // import 'package:url_launcher/url_launcher.dart';
// // import 'package:uuid/uuid.dart';

// // import '../../config/paths.dart';
// // import '../../localization/localization_methods.dart';
// // import '../../models/SupportMessage.dart';
// // import '../../models/supportReview.dart';
// // import '../../models/user.dart';
// // import '../../widget/playVideoWidget.dart';
// // import '../../widget/playrecordWidget.dart';
// // import '../config/colorsFile.dart';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:intl/intl.dart';
// import 'package:j_groups/helpers/app.dart';
// import 'package:j_groups/persentaion/add_groups_screens/body_chat_compounnt/playVideoWidget.dart';
// import 'package:j_groups/persentaion/add_groups_screens/body_chat_compounnt/playrecordWidget.dart';

// class AppointChatMessageItem extends StatefulWidget {
//   final SupportMessage message;
//   final GroceryUser user;

//   const AppointChatMessageItem(
//       {Key? key, required this.message, required this.user})
//       : super(key: key);

//   @override
//   State<AppointChatMessageItem> createState() => _AppointChatMessageItemState();

//   static Widget chatImage(
//       BuildContext context, String chatContent, String type) {
//     return Container(
//         padding:
//             const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
//         child: Align(
//           alignment: (type != "USER" ? Alignment.topLeft : Alignment.topRight),
//           child: Container(
//             margin: type == "USER"
//                 ? const EdgeInsets.only(bottom: 10.0, right: 10.0)
//                 : const EdgeInsets.only(left: 10.0),
//             child: ElevatedButton(
//                 onPressed: () async {
//                   // launchURL(chatContent);
//                   var url = chatContent;
//                   if (!url.contains('http')) {
//                     url = 'https://$url';
//                   }
//                   // await launch(url);
//                 },
//                 style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.all(0.0)),
//                 child: Material(
//                   borderRadius: const BorderRadius.all(Radius.circular(5.0)),
//                   child: kIsWeb
//                       ? widgetShowImages(chatContent, 250)
//                       : widgetShowImages(chatContent, 150),
//                   //clipBehavior: Clip.hardEdge,
//                 )),
//           ),
//         ));
//   }

//   //? Show Images from network
//   static Widget widgetShowImages(String imageUrl, double imageSize) {
//     return FadeInImage.assetNetwork(
//       placeholder: 'assets/images/load.gif',
//       placeholderScale: 0.5,
//       imageErrorBuilder: (context, error, stackTrace) => const Icon(
//         Icons.image_not_supported,
//         size: 50.0,
//       ),
//       height: imageSize,
//       width: imageSize,
//       image: imageUrl,
//       fit: BoxFit.cover,
//       fadeInDuration: const Duration(milliseconds: 250),
//       fadeInCurve: Curves.easeInOut,
//       fadeOutDuration: const Duration(milliseconds: 150),
//       fadeOutCurve: Curves.easeInOut,
//     );
//   }
// }

// class _AppointChatMessageItemState extends State<AppointChatMessageItem> {
//   bool adding = false;
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Column(
//       children: [
//         Container(
//           padding:
//               const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
//           child: Align(
//             alignment: (widget.message.userUid != widget.user.uid
//                 ? Alignment.topLeft
//                 : Alignment.topRight),
//             child: widget.message.type == "image"
//                 ? AppointChatMessageItem.chatImage(
//                     context, widget.message.message!, widget.message.owner)
//                 : widget.message.type == "voice"
//                     ? PlayRecordWidget(
//                         url: widget.message.message!,
//                         owner: widget.message.userUid == widget.user.uid,
//                       )
//                     : widget.message.type == "video"
//                         ? PlayVideoWidget(
//                             url: widget.message.message!,
//                           )
//                         : Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Container(
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.only(
//                                     topLeft: const Radius.circular(25.0),
//                                     topRight: const Radius.circular(25.0),
//                                     bottomLeft: Radius.circular(
//                                         widget.message.userUid !=
//                                                 widget.user.uid
//                                             ? 0.0
//                                             : 25.0),
//                                     bottomRight: Radius.circular(
//                                         widget.message.userUid !=
//                                                 widget.user.uid
//                                             ? 25.0
//                                             : 0.0),
//                                   ),
//                                   color:
//                                       (widget.message.userUid != widget.user.uid
//                                           ? Colors.grey.shade200
//                                           : AppColors.pink),
//                                 ),
//                                 padding: const EdgeInsets.all(16),
//                                 child: createTextMessage(context, size),
//                               ),
//                               widget.message.messageTimeUtc != null
//                                   ? Text(
//                                       // DateTime.parse(message.messageTimeUtc).toLocal().toString(),
//                                       DateFormat('dd MMM yyyy, hh:mm a').format(
//                                           DateTime.parse(widget
//                                                   .message.messageTimeUtc!)
//                                               .toLocal()),
//                                       textAlign: TextAlign.end,
//                                       style: TextStyle(
//                                         fontFamily: 'Ithra',
//                                         fontSize: 11.0,
//                                         color: Colors.black.withOpacity(0.5),
//                                       ),
//                                     )
//                                   : const SizedBox(),
//                             ],
//                           ),
//           ),
//         ),
//         const SizedBox(
//           height: 5,
//         ),
//       ],
//     );
//   }

//   void showSnack(String text, BuildContext context) {
//     // Fluttertoast.showToast(
//     //     msg: text,
//     //     toastLength: Toast.LENGTH_SHORT,
//     //     gravity: ToastGravity.BOTTOM,
//     //     backgroundColor: Colors.red,
//     //     textColor: Colors.white,
//     //     fontSize: 16.0);
//   }

//   launchURL(String url) async {
//     // if (!url.contains('http')) url = 'https://$url';
//     // if (await canLaunch(url)) {
//     //   await launch(url);
//     // } else {
//     //   // showSnakbar('Could not launch $url', false);

//     //   throw 'Could not launch $url';
//     // }
//   }

//   Widget createTextMessage(context, Size size) {
//     return (widget.message.message != null &&
//             widget.message.message!.contains('https://'))
//         ? InkWell(
//             splashColor: Colors.white.withOpacity(0.5),
//             onTap: () {
//               Clipboard.setData(ClipboardData(text: widget.message.message));
//               // showSnack(getTranslated(context, "textCopy"), context);
//             },
//             child: widget.message.message
//             // != null
//             //     ? AutoDirection(
//             //         text: widget.message.message! != null
//             //             ? widget.message.message!
//             //             : "...",
//             //         child: LinkWell(
//             //           widget.message.message! != null
//             //               ? widget.message.message!
//             //               : "...",
//             //           linkStyle: const TextStyle(
//             //             fontFamily: 'Ithra',
//             //             color: Colors.blue,
//             //             fontSize: 15.0,
//             //           ),
//             //           textAlign: TextAlign.start,
//             //           style: TextStyle(
//             //             fontFamily: 'Ithra',
//             //             color: widget.message.userUid == widget.user.uid
//             //                 ? Colors.black
//             //                 : AppColors.white,
//             //             fontSize: 15.0,
//             //           ),
//             //         ),
//             //       )
//             //     : const SizedBox(),
//             )
//         : InkWell(
//             splashColor: Colors.white.withOpacity(0.5),
//             onTap: () {
//               if (widget.message.type == "closing" &&
//                   widget.user.userType != "SUPPORT") {
//                 // rateDialog(size);
//               } else {
//                 Clipboard.setData(ClipboardData(text: widget.message.message));
//                 // showSnack(getTranslated(context, "textCopy"), context);
//               }
//             },
//             child: widget.message.message
//             // != null
//             //     ? AutoDirection(
//             //         text: widget.message.message! != null
//             //             ? widget.message.message!
//             //             : "...",
//             //         child: Text.rich(
//             //           TextSpan(
//             //             text: widget.message.message != null
//             //                 ? widget.message.message
//             //                 : "...",
//             //             style: TextStyle(
//             //               fontFamily: 'Ithra',
//             //               color: widget.message.userUid == widget.user.uid
//             //                   ? AppColors.white
//             //                   : Colors.black,
//             //               fontSize: 15.0,
//             //             ),
//             //             children: <TextSpan>[
//             //               const TextSpan(
//             //                 text: " ",
//             //               ),
//             //               widget.message.type == "closing"
//             //                   ? TextSpan(
//             //                       text: getTranslated(context, "pressHere"),
//             //                       style: const TextStyle(
//             //                           decoration: TextDecoration.underline,
//             //                           decorationThickness: 3,
//             //                           fontFamily: 'Ithra',
//             //                           color: Colors.lightBlueAccent,
//             //                           fontSize: 15.0,
//             //                           fontWeight: FontWeight.bold),
//             //                     )
//             //                   : const TextSpan(
//             //                       text: ' ',
//             //                     ),
//             //             ],
//             //           ),
//             //           softWrap: true,
//             //           maxLines: 10,
//             //           textAlign: TextAlign.center,
//             //         ),
//             //       )
//             //     : const SizedBox(),

//             );
//   }
// }
// //   rateDialog(Size size) {
// //     return showDialog(
// //       builder: (context) => AlertDialog(
// //           shape: const RoundedRectangleBorder(
// //             borderRadius: BorderRadius.all(
// //               Radius.circular(20.0),
// //             ),
// //           ),
// //           elevation: 5.0,
// //           contentPadding: const EdgeInsets.only(
// //               left: 16.0, right: 16.0, top: 20.0, bottom: 10.0),
// //           content: StatefulBuilder(builder: (context, setState) {
// //             return Column(
// //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //               crossAxisAlignment: CrossAxisAlignment.center,
// //               mainAxisSize: MainAxisSize.min,
// //               children: <Widget>[
// //                 Row(
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   children: [
// //                     Text(
// //                        "supportRating",
// //                       style: GoogleFonts.cairo(
// //                         fontSize: 14.5,
// //                         fontWeight: FontWeight.w600,
// //                         letterSpacing: 0.3,
// //                         color: Colors.black87,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 Padding(
// //                   padding: const EdgeInsets.only(
// //                       left: 20, right: 20, top: 10, bottom: 10),
// //                   child: Row(
// //                     mainAxisAlignment: MainAxisAlignment.center,
// //                     children: <Widget>[
// //                       InkWell(
// //                         onTap: () {
// //                           addReview("good");
// //                         },
// //                         child: Row(
// //                           mainAxisAlignment: MainAxisAlignment.center,
// //                           children: [
// //                             Image.asset(
// //                               'assets/applicationIcons/happyEmo.png',
// //                               width: 15,
// //                               height: 15,
// //                               color: Colors.lightBlue,
// //                             ),
// //                             const SizedBox(
// //                               width: 5,
// //                             ),
// //                             Text(
// //                               getTranslated(context, "good"),
// //                               style: GoogleFonts.cairo(
// //                                 fontSize: 13,
// //                                 fontWeight: FontWeight.w600,
// //                                 letterSpacing: 0.3,
// //                                 color: Colors.lightBlue,
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                       const Spacer(),
// //                       InkWell(
// //                         onTap: () {
// //                           addReview("bad");
// //                         },
// //                         child: Row(
// //                           mainAxisAlignment: MainAxisAlignment.start,
// //                           children: [
// //                             Image.asset(
// //                               'assets/applicationIcons/bad.png',
// //                               width: 15,
// //                               height: 15,
// //                               color: Colors.lightBlue,
// //                             ),
// //                             const SizedBox(
// //                               width: 5,
// //                             ),
// //                             Text(
// //                               getTranslated(context, "bad"),
// //                               style: GoogleFonts.cairo(
// //                                 fontSize: 13,
// //                                 fontWeight: FontWeight.w600,
// //                                 letterSpacing: 0.3,
// //                                 color: Colors.lightBlue,
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //                 Padding(
// //                   padding: const EdgeInsets.only(
// //                       left: 5, right: 5, top: 5, bottom: 10),
// //                   child: Container(
// //                     width: size.width,
// //                     height: 0.5,
// //                     color: AppColors.lightGrey1,
// //                   ),
// //                 ),
// //                 /* Row(
// //                   mainAxisAlignment: MainAxisAlignment.end,
// //                   children: [
// //                     TextButton(
// //                       onPressed: () {
// //                         //Navigator.pop(context);
// //                       },
// //                       child: Text(
// //                         "Thank You",
// //                         //getTranslated(context, "discard"),
// //                         style: GoogleFonts.cairo(
// //                           fontSize: 14.5,
// //                           fontWeight: FontWeight.w600,
// //                           letterSpacing: 0.3,
// //                           color: Colors.lightBlue,
// //                         ),
// //                       ),
// //                     )
// //                   ],
// //                 ),*/
// //               ],
// //             );
// //           })),
// //       barrierDismissible: false,
// //       context: context,
// //     );
// //   }

// //   Future<bool?> addReview(String review) async {
// //     setState(() {
// //       adding = true;
// //     });
// //     try {
// //       /*QuerySnapshot querySnapshot = await FirebaseFirestore.instance
// //           .collection(Paths.usersPath)
// //           .where('uid', isEqualTo: widget.message.userUid)
// //           .limit(1)
// //           .get();
// //       var support = GroceryUser.fromMap(querySnapshot.docs[0]);*/

// //       String reviewId = Uuid().v4();
// //       await FirebaseFirestore.instance
// //           .collection(Paths.supportReviewPath)
// //           .doc(reviewId)
// //           .set({
// //         'rating': review == 'good' ? 5 : 0,
// //         'review': review == "good" ? "good" : "bad",
// //         'reviewTime': Timestamp.now(),
// //         'userName': widget.user.name,
// //         'supportListId': widget.user.supportListId,
// //         'supportUid': widget.message.userUid,
// //         'supportName': widget.message.ownerName,
// //       });
// //       //update user review
// //       List<SupportReview> reviews;
// //       try {
// //         QuerySnapshot snap = await FirebaseFirestore.instance
// //             .collection(Paths.supportReviewPath)
// //             .where('supportUid', isEqualTo: widget.message.userUid)
// //             .get();

// //         reviews = List<SupportReview>.from(
// //           (snap.docs).map(
// //             (e) => SupportReview.fromMap(e.data() as Map),
// //           ),
// //         );

// //         if (reviews.length > 0) {
// //           double _rating = 0;
// //           for (var rev in reviews) {
// //             _rating = _rating + double.parse(rev.rating.toString());
// //           }
// //           print('wwwww=${_rating}');

// //           _rating = _rating / reviews.length;
// //           _rating = double.parse((_rating.toStringAsFixed(1)));

// //           print('qqqqq=${reviews.length}');
// //           await FirebaseFirestore.instance
// //               .collection(Paths.usersPath)
// //               .doc(widget.message.userUid)
// //               .set({
// //             'rating': _rating,
// //             'reviewsCount': reviews.length,
// //           }, SetOptions(merge: true));
// //         }
// //         setState(() {
// //           adding = false;
// //         });

// //         Navigator.pop(context);
// //         Navigator.pop(context);
// //       } catch (e) {
// //         print("reviewwwwww" + e.toString());
// //         return null;
// //       }
// //       return true;
// //     } catch (e) {
// //       print("reviewwwwww222" + e.toString());
// //     }
// //   }
// // }
