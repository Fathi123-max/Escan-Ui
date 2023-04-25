import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escan_ui/groups/bloc/groups_bloc/groups_state.dart';
import 'package:escan_ui/groups/data/models/groups.dart';

import '../../data/reposetries/groups_repository.dart';
import 'groups_event.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final _firestore = FirebaseFirestore.instance;

  GroupsRepositry groupsRepositry = GroupsRepositry();
  GroupBloc() : super(GroupInithal()) {
    on<LoadGroups>((event, emit) async {
      emit(GroupLoading());
      try {
        var groups = await groupsRepositry.getGroupStream();
        emit(GroupLoaded(groups: groups));
      } catch (e) {
        emit(GroupError(message: 'Error loading groups: $e'));
      }
    });
    on<AddGroup>((event, emit) async {
      emit(GroupLoading());
      try {
        await groupsRepositry.addGroup(event);
        var groups = await groupsRepositry.getGroupStream();
        emit(GroupLoaded(groups: groups));
      } catch (e) {
        emit(GroupError(message: 'Error adding group: $e'));
      }
    });
    on<DeleteGroup>((event, emit) async {
      emit(GroupLoading());
      try {
        await groupsRepositry.deleteGroup(event.groupId);
        var groups = await groupsRepositry.getGroupStream();
        emit(GroupLoaded(groups: groups));
      } catch (e) {
        emit(GroupError(message: 'Error adding group: $e'));
      }
    });
    // get the singleton instance of the firebase db.
  }

  Stream<List<Group>> get groupsStream => groupsRepositry.getGroupStream();
  String search = "";
  Stream<List<Group>> groupsStreamByName(String searchQuery) {
    return groupsRepositry.getGroupStreamByName(search);
  }
}





  //? old event to state method 
/*
  Stream<GroupState> mapEventToState(GroupEvent event) async* {
    if (event is LoadGroups) {
      yield GroupLoading();
      try {
        var groups = await _loadGroups();
        yield GroupLoaded(groups: groups);
      } catch (e) {
        yield GroupError(message: 'Error loading groups: $e');
      }
    } else if (event is AddGroup) {
      try {
        await _addGroup(event);
        var groups = await _loadGroups();
        yield GroupLoaded(groups: groups);
      } catch (e) {
        yield GroupError(message: 'Error adding group: $e');
      }
    } else if (event is UpdateGroup) {
      try {
        await _updateGroup(event);
        var groups = await _loadGroups();
        yield GroupLoaded(groups: groups);
      } catch (e) {
        yield GroupError(message: 'Error updating group: $e');
      }
    } else if (event is DeleteGroup) {
      try {
        await _deleteGroup(event.groupId);
        var groups = await _loadGroups();
        yield GroupLoaded(groups: groups);
      } catch (e) {
        yield GroupError(message: 'Error deleting group: $e');
      }
    }
  }
*/




//? old code by fathi 
/*

// 
class GroupBloc extends Bloc<Gr
oupEvent, GroupState> {
  final GroupRepository _groupRepository;
  List<Group> _groups = [];

  GroupBloc(this._groupRepository) : super(GroupLoading()) {
    on<LoadGroups>((event, emit) async {
      emit(GroupLoading());

      try {
        _groups = await _groupRepository.getAllGroups();
        emit(GroupLoaded( groups: _groups));
      } catch (e) {
        emit(GroupError(, message: ''));
      }
    });

    on<AddGroup>((event, emit) async {
      emit(GroupLoading());

      try {
        var group = await _groupRepository.addGroup(
          event.groupName,
          event.groupLink,
          event.groupImage,
          event.groupMembers,
        );

        _groups.add(group);

        emit(GroupLoaded(_groups));
      } catch (e) {
        emit(GroupError('Failed to add group: $e'));
      }
    });

    on<UpdateGroup>((event, emit) async {
      emit(GroupLoading());

      try {
        var group = await _groupRepository.updateGroup(event.group);

        var index = _groups.indexWhere((g) => g.id == group.id);
        _groups[index] = group;

        emit(GroupLoaded(_groups));
      } catch (e) {
        emit(GroupError('Failed to update group: $e'));
      }
    });

    on<DeleteGroup>((event, emit) async {
      emit(GroupLoading());

      try {
        await _groupRepository.deleteGroup(event.group.id);

        _groups.removeWhere((g) => g.id == event.group.id);

        emit(GroupLoaded(_groups));
      } catch (e) {
        emit(GroupError('Failed to delete group: $e'));
      }
    });
  }

  static GroupBloc create() {
    final groupRepository = GroupRepository();
    return GroupBloc(groupRepository);
  }
}

 */





//? ethar code  
/*


import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeras/models/groups.dart';
import 'package:jeras/repositories/groups_repository.dart';

part 'groups_event.dart';
part 'groups_state.dart';

class GroupsBloc extends Bloc<GroupsEvent, GroupState> {
  GroupsRepository groupsRepository = GroupsRepository();

  GroupsBloc({required this.groupsRepository}) : super(GroupInitial()) {
    on<GetGroupsEvent>((event, emit) async {
      try {
        Groups groups = await groupsRepository.getGroups(event.groupUid);

        emit(LoadGroupsState(groups));
      } catch (e) {
        print(e);
        print(" Error GetGroup");
      }
    });
  }

  @override
  GroupState get initialState => GroupInitial();

  loadGroups(Groups groups) async {
    await groupsRepository.loadGroups(groups).then((groups) {
      emit(LoadGroupsState(groups));
    });
  }

  createGroup(String consultId, String groupUid, Groups groups) async {
    await groupsRepository
        .createGroup(groups, groupUid)
        .then((value) => emit(CreateGroupState(consultId, groupUid, groups)));
  }

  uploadGroupImage() async {
    await groupsRepository.uploadImage();
    emit(UploadGroupImage());
  }

  // getImageFromGallery() async {
  // await userDataRepository.getImageFromGallary();
  // }

  void fetchGroups(String consultId) async {
    await groupsRepository.fetchConsultGroups(consultId).then((consultGroups) {
      emit(FetchGroupsState(consultId, consultGroups));
    });
    
  }
}
 */
