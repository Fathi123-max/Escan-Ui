//! states classes

import '../../data/models/group_model.dart';

abstract class ChatGroupState {}

class InitialChatGroupState extends ChatGroupState {}

class LoadingState extends ChatGroupState {}

class LoadedState extends ChatGroupState {
  final Stream<List<ChatMessage>> messages;

  LoadedState({required this.messages});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoadedState &&
          runtimeType == other.runtimeType &&
          messages == other.messages;

  @override
  int get hashCode => messages.hashCode;
}

class ErrorState extends ChatGroupState {
  final String message;

  ErrorState({required this.message});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ErrorState &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}
