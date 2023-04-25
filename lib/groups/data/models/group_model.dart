//!model class

import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String? sender;
  final String? text;
  final String? photoUrl;
  final String? voiceNoteUrl;
  final DateTime? timestamp;

  ChatMessage({
    this.sender,
    this.text,
    this.photoUrl,
    this.voiceNoteUrl,
    Timestamp? timestamp,
  }) : timestamp = timestamp?.toDate(); // Convert Timestamp to DateTime here

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    final type = map['type'] as String?;

    if (type == 'photo') {
      return ChatMessage(
        photoUrl: map['message'] as String?,
        timestamp: Timestamp.fromMillisecondsSinceEpoch(map['timestamp']),
      );
    } else if (type == 'voice_note') {
      return ChatMessage(
        voiceNoteUrl: map['message'] as String?,
        timestamp: Timestamp.fromMillisecondsSinceEpoch(map['timestamp']),
      );
    } else {
      return ChatMessage(
        text: map['message'] as String?,
        timestamp: Timestamp.fromMillisecondsSinceEpoch(map['timestamp']),
      );
    }
  }
}
