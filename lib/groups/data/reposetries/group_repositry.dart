//! repositry class
import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escan_ui/groups/data/models/group_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

class ChatRepository {
  ChatRepository({required this.groupName});
  String groupName;
  final StreamController<List<ChatMessage>> _messagesController =
      StreamController<List<ChatMessage>>.broadcast();
  Stream<List<ChatMessage>> get messagesStream => _messagesController.stream;

  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  Stream<List<ChatMessage>> getMessagesStream() {
    return _firestore
        .collection(groupName)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((event) =>
            event.docs.map((doc) => ChatMessage.fromMap(doc.data())).toList());
  }

  Future<void> sendMessage(String message) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    await _firestore.collection(groupName).add({
      'message': message,
      'type': 'text',
      'timestamp': timestamp,
    });
  }

  Future<void> sendPhoto(File photo) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final ref = _storage.ref().child(groupName).child('$timestamp.jpg');
    final uploadTask = ref.putFile(photo);
    final snapshot = await uploadTask.whenComplete(() {});
    final downloadUrl = await snapshot.ref.getDownloadURL();
    await _firestore.collection(groupName).add({
      'message': downloadUrl,
      'type': 'photo',
      'timestamp': timestamp,
    });
  }

  Future<void> sendVoiceNote(File voiceNote) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final ref = _storage.ref().child(groupName).child('$timestamp.wav');
    final uploadTask = ref.putFile(voiceNote);
    final snapshot = await uploadTask.whenComplete(() {});
    final downloadUrl = await snapshot.ref.getDownloadURL();
    await _firestore.collection(groupName).add({
      'message': downloadUrl,
      'type': 'voice_note',
      'timestamp': timestamp,
    });
  }

  Future<String> saveAudio(File audio) async {
    final directory = await getApplicationDocumentsDirectory();
    final path =
        '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.wav';
    final file = File(path);
    audio = file;
    return path;
  }
}
