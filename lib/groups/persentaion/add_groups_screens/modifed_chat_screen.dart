import 'package:auto_direction/auto_direction.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:linkwell/linkwell.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/models/group_model.dart';
import '../../helpers/app.dart';
import 'body_chat_compounnt/playrecordWidget.dart';

ChatMessage message = ChatMessage();

final ScrollController listScrollController = ScrollController();
Widget buildMessage2(BuildContext context, message) {
  String type = "USR";
  final bool isPhoto = message.photoUrl != null;
  final bool isAudio = message.voiceNoteUrl != null;

  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Align(
            //  alignment: (type != "USER" ? Alignment.topLeft : Alignment.topRight),

            //? left or right logic
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (message.text != null) ...[
                  createTextMessage(context, message, type),
                  const SizedBox(height: 5),
                ],
                if (isPhoto) ...[chatImage(context, message.photoUrl!, type)],
                if (isAudio) ...[
                  PlayRecordWidget(
                    url: message.voiceNoteUrl!,
                    owner: true
                    // widget.message.userUid == widget.user.uid
                    ,
                  )
                ],
                Align(
                  alignment:
                      (type != "USER" ? Alignment.topLeft : Alignment.topRight),
                  child: Text(
                    DateFormat('yyyy-MM-dd kk:mm').format(message.timestamp!),
                    style: TextStyle(
                      fontFamily: 'Ithra',
                      fontSize: 11.0,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    ),
  );
}

launchURL(String url) async {
  if (!url.contains('http')) url = 'https://$url';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    // showSnakbar('Could not launch $url', false);

    throw 'Could not launch $url';
  }
}

Widget createTextMessage(context, ChatMessage message, String type) {
  return (message.text != null && message.text!.contains('https://'))
      ? InkWell(
          splashColor: Colors.white.withOpacity(0.5),
          onTap: () {
            Clipboard.setData(ClipboardData(text: message.text));
            // showSnack(getTranslated(context, "textCopy"), context);
          },
          child: message.text != null
              ? AutoDirection(
                  text: message.text!,
                  child: LinkWell(
                    message.text!,
                    linkStyle: const TextStyle(
                      fontFamily: 'Ithra',
                      color: Colors.blue,
                      fontSize: 15.0,
                    ),
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontFamily: 'Ithra',
                      color: message.sender == "user"
                          ? Colors.black
                          : AppColors.white,
                      fontSize: 15.0,
                    ),
                  ),
                )
              : const SizedBox(),
        )
      : InkWell(
          splashColor: Colors.white.withOpacity(0.5),
          onTap: () {
            if (message.sender == "user" && message.text != "SUPPORT") {
              // rateDialog(size);
            } else {
              Clipboard.setData(ClipboardData(text: message.text));
              // showSnack(getTranslated(context, "textCopy"), context);
            }
          },
          child: message.text != null
              ? Align(
                  alignment:
                      (type != "USER" ? Alignment.topLeft : Alignment.topRight),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text.rich(
                      TextSpan(
                        text: message.text ?? "...",
                        style: TextStyle(
                          fontFamily: 'Ithra',
                          color: message.sender == "user"
                              ? AppColors.white
                              : Colors.black,
                          fontSize: 15.0,
                        ),
                        children: <TextSpan>[
                          const TextSpan(
                            text: " ",
                          ),
                          message.sender == "closing"
                              ? const TextSpan(
                                  text: "pressHere",
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      decorationThickness: 3,
                                      fontFamily: 'Ithra',
                                      color: Colors.lightBlueAccent,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold),
                                )
                              : const TextSpan(
                                  text: ' ',
                                ),
                        ],
                      ),
                      softWrap: true,
                      maxLines: 10,
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : const SizedBox(),
        );
}

Widget chatImage(BuildContext context, String chatContent, String type) {
  return Container(
      padding: const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
      child: Align(
        alignment: (type != "USER" ? Alignment.topLeft : Alignment.topRight),
        child: Container(
          margin: type == "USER"
              ? const EdgeInsets.only(bottom: 10.0, right: 10.0)
              : const EdgeInsets.only(left: 10.0),
          child: ElevatedButton(
              onPressed: () async {
                // launchURL(chatContent);
                var url = chatContent;
                if (!url.contains('http')) {
                  url = 'https://$url';
                }
                await launch(url);
              },
              style:
                  ElevatedButton.styleFrom(padding: const EdgeInsets.all(0.0)),
              child: Material(
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                clipBehavior: Clip.hardEdge,
                child: kIsWeb
                    ? widgetShowImages(chatContent, 250)
                    : widgetShowImages(chatContent, 150),
              )),
        ),
      ));
}

//? Show Images from network
Widget widgetShowImages(String imageUrl, double imageSize) {
  return FadeInImage.assetNetwork(
    placeholder: 'assets/images/load.gif',
    placeholderScale: 0.5,
    imageErrorBuilder: (context, error, stackTrace) => const Icon(
      Icons.image_not_supported,
      size: 50.0,
    ),
    height: imageSize,
    width: imageSize,
    image: imageUrl,
    fit: BoxFit.cover,
    fadeInDuration: const Duration(milliseconds: 250),
    fadeInCurve: Curves.easeInOut,
    fadeOutDuration: const Duration(milliseconds: 150),
    fadeOutCurve: Curves.easeInOut,
  );
}
