import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:voice_message_package/voice_message_package.dart';

import '../../../helpers/app.dart';

// import '../config/colorsFile.dart';

class PlayRecordWidget extends StatefulWidget {
  final String url;
  final bool owner;
  const PlayRecordWidget({Key? key, required this.url, required this.owner})
      : super(key: key);
  @override
  State<PlayRecordWidget> createState() => _PlayRecordWidgetState();
}

class _PlayRecordWidgetState extends State<PlayRecordWidget> {
  int maxDuration = 100;
  int currentPos = 0;
  String currentPostLabel = "00:00";
  bool isPlaying = false;
  bool audioPlayed = false;

  AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      player.onDurationChanged.listen((Duration d) {
        //get the duration of audio
        maxDuration = d.inMilliseconds;
      });

      player.onPositionChanged.listen((Duration p) {
        setState(() {
          currentPos =
              p.inMilliseconds; //get the current position of playing audio
        });

        //generating the duration label
        int shours = Duration(milliseconds: currentPos).inHours;
        int sminutes = Duration(milliseconds: currentPos).inMinutes;
        int sseconds = Duration(milliseconds: currentPos).inSeconds;

        int rhours = shours;
        int rminutes = sminutes - (shours * 60);
        int rseconds = sseconds - (sminutes * 60 + shours * 60 * 60);

        currentPostLabel = "$rhours:$rminutes:$rseconds";
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    player.stop();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: (widget.owner ? Alignment.topLeft : Alignment.topRight),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
            bottomLeft: Radius.circular(widget.owner ? 0.0 : 20.0),
            bottomRight: Radius.circular(widget.owner ? 20.0 : 0.0),
          ),
          color: (widget.owner ? Colors.grey.shade200 : AppColors.pink),
        ),
        child: VoiceMessage(
          meBgColor: (widget.owner ? Colors.grey.shade200 : AppColors.pink),
          mePlayIconColor: Colors.white,
          meFgColor: Colors.white,
          contactBgColor:
              (widget.owner ? Colors.grey.shade200 : AppColors.pink),
          contactPlayIconColor: Colors.white,
          contactFgColor: widget.owner
              ? AppColors.greendark2
              : Colors.black.withOpacity(0.5),
          audioSrc: widget.url,
          played: false, // To show played badge or not.
          me: false, // Set message side.
          onPlay: () {}, // Do something when voice played.
        ),
      ),
    );
  }
}
