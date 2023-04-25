//!event classes

import 'dart:io';

abstract class ChatGroupEvent {}

class LoadMessagesEvent extends ChatGroupEvent {}

class SendMessageEvent extends ChatGroupEvent {
  final String? message;
  final File? photo;
  final File? voiceNote;

  SendMessageEvent({this.message, this.photo, this.voiceNote});
}
