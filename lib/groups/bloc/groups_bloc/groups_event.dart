import 'package:equatable/equatable.dart';

import '../../data/models/groups.dart';

abstract class GroupEvent extends Equatable {
  const GroupEvent();

  @override
  List<Object> get props => [];
}

class LoadGroups extends GroupEvent {}

class AddGroup extends GroupEvent {
  final String consultId;
  final String groupName;
  final String groupImage;
  final String groupLink;
  final List<GroupMember> groupMembers;

  const AddGroup({
    required this.consultId,
    required this.groupName,
    required this.groupImage,
    required this.groupLink,
    required this.groupMembers,
  });

  @override
  List<Object> get props =>
      [consultId, groupName, groupImage, groupLink, groupMembers];
}

class UpdateGroup extends GroupEvent {
  final Group group;

  const UpdateGroup({required this.group});

  @override
  List<Object> get props => [group];
}

class DeleteGroup extends GroupEvent {
  final String groupId;

  const DeleteGroup({required this.groupId});

  @override
  List<Object> get props => [groupId];
}

















































// import 'package:equatable/equatable.dart';

// //? base event
// abstract class GroupsEvent extends Equatable {}

// //? Group events

// //! shold be stream to enable realtime creation
// class LoadGroups extends GroupsEvent {
//   @override
//   List<Object?> get props => [];
// }

// //?( teacher id  )
// class CreateGroup extends GroupsEvent {
//   @override
//   List<Object?> get props => [];
// }

// //?( student id )
// class EnterGroup extends GroupsEvent {
//   @override
//   List<Object?> get props => [];
// }

// //?( student id )
// class LeaveGroup extends GroupsEvent {
//   @override
//   List<Object?> get props => [];
// }

// //?( teacher id  )
// class ExitGroup extends GroupsEvent {
//   @override
//   List<Object?> get props => [];
// }

// //? end of group events

// // part of 'groups_bloc.dart';

// // abstract class GroupsEvent extends Equatable {}

// // class GetGroupsEvent extends GroupsEvent {
// //   final String groupUid;

// //   GetGroupsEvent(this.groupUid);

// //   @override
// //   String toString() => 'GetGroupsEvent';

// //   @override
// //   List<Object?> get props => throw UnimplementedError();
// // }

// // class GetAllGroups extends GroupsEvent {
// //   final String groupUid;
// //   GetAllGroups(this.groupUid);

// //   @override
// //   String toString() => 'GetAllGroups';

// //   @override
// //   List<Object?> get props => throw UnimplementedError();
// // }
