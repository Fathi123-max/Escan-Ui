// Modified code with fixed audio player issue

import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escan_ui/groups/persentaion/add_groups_screens/group_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record_mp3/record_mp3.dart';

import '../../bloc/group_bloc/group_bloc.dart';
import '../../bloc/group_bloc/group_event.dart';
import '../../bloc/group_bloc/group_state.dart';
import '../../bloc/groups_bloc/groups_bloc.dart';
import '../../bloc/groups_bloc/groups_event.dart';
import '../../data/models/group_model.dart';
import '../../data/reposetries/group_repositry.dart';
import 'modifed_chat_screen.dart';

class ChatGroupScreen2 extends StatefulWidget {
  const ChatGroupScreen2({Key? key, required this.groupName}) : super(key: key);
  final String groupName;

  @override
  ChatGroupScreen2State createState() => ChatGroupScreen2State();
}

class ChatGroupScreen2State extends State<ChatGroupScreen2> {
  final _textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isComposing = false;
  bool _isRecording = false;
  late ChatGroupBloc _chatGroupBloc;
  late FirebaseFirestore firestore;
  late String recordFilePath;
  bool isPlaying = false;
  AudioPlayer audioPlayer = AudioPlayer();
  var consoltId;
  @override
  void initState() {
    super.initState();
    recordFilePath = "";
    firestore = FirebaseFirestore.instance;
    _chatGroupBloc = ChatGroupBloc(
        chatRepository: ChatRepository(groupName: widget.groupName));
    _chatGroupBloc.add(LoadMessagesEvent());
  }

  @override
  void dispose() {
    _textController.dispose();
    _chatGroupBloc.close();
    audioPlayer.release();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: PopupMenuButton(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30))),
          itemBuilder: (contextx) => [
            PopupMenuItem(
              height: 5,
              value: 'exit',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [Icon(Icons.clear, size: 10)],
              ),
            ),
            PopupMenuItem(
              height: 5,
              value: "addMember",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text("أضاقة اعضاء",
                      style: TextStyle(
                          color: Color(0xff838383),
                          fontWeight: FontWeight.w300,
                          fontFamily: "Ithra",
                          fontStyle: FontStyle.normal,
                          fontSize: 10.0),
                      textAlign: TextAlign.right),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                        height: 10,
                        width: 10,
                        child: Image.asset("assets/icons/user.png")),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: "copyUrl",
              height: 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text("نسخ الرابط ",
                      style: TextStyle(
                          color: Color(0xff838383),
                          fontWeight: FontWeight.w300,
                          fontFamily: "Ithra",
                          fontStyle: FontStyle.normal,
                          fontSize: 10.0),
                      textAlign: TextAlign.right),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                        height: 10,
                        width: 10,
                        child: Image.asset("assets/icons/copy-line.png")),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              height: 5,
              value: "sitting",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text("الأعدادات",
                      style: TextStyle(
                          color: Color(0xff838383),
                          fontWeight: FontWeight.w300,
                          fontFamily: "Ithra",
                          fontStyle: FontStyle.normal,
                          fontSize: 10.0),
                      textAlign: TextAlign.right),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                        height: 10,
                        width: 10,
                        child: Image.asset("assets/icons/settings.png")),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              height: 5,
              value: "removeGroup",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text("حذف المجموعه",
                      style: TextStyle(
                          color: Color(0xff838383),
                          fontWeight: FontWeight.w300,
                          fontFamily: "Ithra",
                          fontStyle: FontStyle.normal,
                          fontSize: 10.0),
                      textAlign: TextAlign.right),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                        height: 10,
                        width: 10,
                        child: Image.asset("assets/icons/delete.png")),
                  ),
                ],
              ),
            )
          ],
          onSelected: (value) {
            switch (value) {
              case "exit":
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GroupsPage()),
                );
                break;
              case "addMember":
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GroupsPage()),
                );
                break;
              case "sitting":
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GroupsPage()),
                );
                break;
              case "removeGroup":
                BlocProvider.of<GroupBloc>(context)
                    .add(DeleteGroup(groupId: widget.groupName));

                // context
                //     .read<GroupBloc>()
                //     .add(DeleteGroup(groupId: widget.groupName));

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => GroupsPage()),
                );
                break;
              case "copyUrl":
                Navigator.pop(
                  context,
                  MaterialPageRoute(builder: (context) => GroupsPage()),
                );

                break;
              default:
            }
          },
        ),
        leadingWidth: 20,
        // automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // IconButton(
            //     onPressed: () {

            //     },
            //     icon: const Icon(
            //       Icons.more_vert,
            //       color: Colors.black,
            //     )),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: GestureDetector(
                child: Container(
                    width: 75,
                    height: 27,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: Color(0xfff84e4e)),
                    child: const Center(
                      child: Text("star live",
                          style: TextStyle(
                              color: Color(0xffffffff),
                              fontWeight: FontWeight.w600,
                              fontFamily: "Montserrat",
                              fontStyle: FontStyle.normal,
                              fontSize: 11.0),
                          textAlign: TextAlign.center),
                    )),
              ),
            ),
            const Spacer(),
            const Text("العربيـة بسهولة",
                style: TextStyle(
                    color: Color(0xff202020),
                    fontWeight: FontWeight.w700,
                    fontFamily: "Ithra",
                    fontStyle: FontStyle.normal,
                    fontSize: 15.0),
                textAlign: TextAlign.right),
            const SizedBox(
              width: 8,
            ),
            // Rectangle 1094
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(
                          color: const Color(0xffd3d3d3), width: 0.5)),
                  child: const Center(child: Icon(Icons.arrow_forward))),
            ),
            const SizedBox(
              width: 10,
            )
          ],
        ),
      ),
      body: BlocBuilder(
        bloc: _chatGroupBloc,
        builder: (context, state) {
          if (state is LoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is LoadedState) {
            return Column(
              children: [
                Expanded(
                    child: StreamBuilder(
                        stream: _chatGroupBloc.messagesStream,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text(snapshot.error.toString()),
                            );
                          } else {
                            final messages = snapshot.data!.reversed.toList();

                            return ListView.builder(
                              itemCount: messages.length,
                              itemBuilder: (context, index) {
                                return buildMessage2(context, messages[index]);
                              },
                            );
                          }
                        })),
                // Text input
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: groupInputs(context)),
              ],
            );
          } else if (state is ErrorState) {
            return Center(
              child: Text(state.message),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget groupInputs(BuildContext context) {
    return Container(
      height: 75,
      width: double.infinity,
      padding: const EdgeInsets.only(left: 16, right: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            offset: const Offset(0, -2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(
            width: 15,
          ),
          GestureDetector(
            onTap: () {
              _sendPhoto();
            },
            child: SizedBox(
              height: 25,
              width: 25,
              child: Image.asset("assets/icons/photos.png"),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          GestureDetector(
            onTap: () {
              _isRecording ? stopRecord() : startRecord();
            },
            child: SizedBox(
              height: 25,
              width: 25,
              child: _isRecording
                  ? const Icon(Icons.abc)
                  : Image.asset("assets/icons/mic.png"),
            ),
          ),
          const SizedBox(
            width: 40,
          ),
          Expanded(
            child: Container(
              width: 253,
              height: 42,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(21)),
                border: Border.all(color: const Color(0xffd3d3d3), width: 0.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                      child: Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: _textController,
                      textAlign: TextAlign.right,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "...أكـتب رسـالة ",
                        alignLabelWithHint: true,
                        // hintTextDirection: TextDirection.rtl,
                        hintStyle: TextStyle(
                            color: Color(0xffd3d3d3),
                            fontWeight: FontWeight.w300,
                            fontFamily: "Ithra",
                            fontStyle: FontStyle.normal,
                            fontSize: 13.0),
                      ),
                    ),
                  )),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      _sendMessage();
                    },
                    child: SizedBox(
                      height: 20,
                      width: 30,
                      child: Image.asset("assets/icons/send.png"),
                    ),
                  ),
                  const SizedBox(width: 15),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          )
        ],
      ),
    );
  }

  Widget buildMessage(BuildContext context, ChatMessage message) {
    const String photoTagPrefix = 'photo';

    final bool isPhoto = message.photoUrl != null;
    final bool isAudio = message.voiceNoteUrl != null;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 10.0),
            child: const CircleAvatar(
              child: Text('Me'),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (message.text != null) ...[
                  Text(
                    message.text!,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                ],
                if (isPhoto) ...[
                  Hero(
                    tag: photoTagPrefix + message.photoUrl!,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FullScreenPhotoView(
                              photoUrl: message.photoUrl!,
                              heroTag: photoTagPrefix + message.photoUrl!,
                            ),
                          ),
                        );
                      },
                      child: CachedNetworkImage(
                        imageUrl: message.photoUrl!,
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                        errorWidget: (BuildContext context, String url, error) {
                          return const Icon(Icons.error);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                ],
                if (isAudio) ...[
                  GestureDetector(
                    onTap: () async {
                      if (isPlaying) {
                        audioPlayer.pause();
                        setState(() {
                          isPlaying = false;
                        });
                      } else {
                        await audioPlayer.play(
                          UrlSource(message.voiceNoteUrl!),
                          mode: PlayerMode.lowLatency,
                        );

                        setState(() {
                          isPlaying = true;
                        });
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                        const SizedBox(width: 5),
                        const Text(
                          'Voice Note',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                ],
                Text(
                  DateFormat('yyyy-MM-dd kk:mm').format(message.timestamp!),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_formKey.currentState!.validate()) {
      _chatGroupBloc.add(SendMessageEvent(message: _textController.text));
      _textController.clear();
    }
  }

  void _sendPhoto() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final photo = File(pickedFile.path);
      _chatGroupBloc.add(SendMessageEvent(photo: photo));
    }
  }

  void startRecord() async {
    bool hasPermission = await checkPermission();
    if (hasPermission) {
      recordFilePath = await getFilePath();
      RecordMp3.instance.start(recordFilePath, (type) {
        setState(() {});
      });
      setState(() {
        _isRecording = true;
      });
    } else {
      setState(() {
        _isRecording = false;
      });
    }
  }

  void pauseRecord() {
    if (RecordMp3.instance.status == RecordStatus.PAUSE) {
      bool s = RecordMp3.instance.resume();
      if (s) {
        setState(() {});
      }
    } else {
      bool s = RecordMp3.instance.pause();
      if (s) {
        setState(() {});
      }
    }
  }

  void stopRecord() {
    bool s = RecordMp3.instance.stop();
    if (s) {
      setState(() {
        _isRecording = false;
      });
      _chatGroupBloc.add(SendMessageEvent(
        voiceNote: File(recordFilePath),
      ));
    }
  }

  void resumeRecord() {
    bool s = RecordMp3.instance.resume();
    if (s) {
      setState(() {});
    }
  }

  Future checkPermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  Future getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = "${storageDirectory.path}/record";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return "$sdPath/test_${DateTime.now().millisecondsSinceEpoch}.wav";
  }
}

class FullScreenPhotoView extends StatelessWidget {
  final String photoUrl;
  final String heroTag;

  const FullScreenPhotoView({
    Key? key,
    required this.photoUrl,
    required this.heroTag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Hero(
          tag: heroTag,
          child: Image.network(
            photoUrl,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
