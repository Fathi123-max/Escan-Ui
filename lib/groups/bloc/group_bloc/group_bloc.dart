import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/group_model.dart';
import '../../data/reposetries/group_repositry.dart';
import 'group_event.dart';
import 'group_state.dart';

class ChatGroupBloc extends Bloc<ChatGroupEvent, ChatGroupState> {
  final ChatRepository chatRepository;
  ChatGroupBloc({required this.chatRepository})
      : super(InitialChatGroupState()) {
    on<LoadMessagesEvent>((event, emit) async {
      // Handle LoadMessagesEvent
      emit(LoadingState());
      try {
        final messages = chatRepository.getMessagesStream();
        emit(LoadedState(messages: messages));
      } catch (e) {
        emit(ErrorState(message: e.toString()));
        print("${e.toString()}");
      }
    });

    on<SendMessageEvent>((event, emit) async {
      // Handle SendMessageEvent
      emit(LoadingState());
      try {
        if (event.message != null) {
          await chatRepository.sendMessage(event.message!);
        } else if (event.photo != null) {
          await chatRepository.sendPhoto(event.photo!);
        } else if (event.voiceNote != null) {
          await chatRepository.sendVoiceNote(event.voiceNote!);
        }
// fix audio showing
        final messages = chatRepository.getMessagesStream();
        emit(LoadedState(messages: messages));
      } catch (e) {
        emit(ErrorState(message: e.toString()));
      }
    });

    // You can add more event handlers here for other events
  }

  Stream<List<ChatMessage>> get messagesStream =>
      chatRepository.getMessagesStream();

  // The rest of your code
}
