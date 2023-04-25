import 'package:equatable/equatable.dart';
import 'package:escan_ui/properties/data/models/Houses_model.dart';

abstract class HouseState extends Equatable {
  const HouseState();

  @override
  List<Object> get props => [];
}

class HouseLoading extends HouseState {}

class HouseLoaded extends HouseState {
  final Stream<List<House>> Houses;

  const HouseLoaded({required this.Houses});

  @override
  List<Object> get props => [Houses];
}

class HouseError extends HouseState {
  final String message;

  const HouseError({required this.message});

  @override
  List<Object> get props => [message];
}

class HouseInithal extends HouseState {
  @override
  List<Object> get props => [];
}




































// import 'package:equatable/equatable.dart';

// abstract class GroupsStates extends Equatable {}

// //! states of event (load groups)
// class LoadGroups_loading extends GroupsStates {
//   @override
//   List<Object?> get props => [];
// }

// class LoadGroups_loaded extends GroupsStates {
//   @override
//   List<Object?> get props => [];
// }

// class LoadGroups_faild extends GroupsStates {
//   @override
//   List<Object?> get props => [];
// }

// //! states of event (create group)

// class CreateGroup_creating extends GroupsStates {
//   @override
//   List<Object?> get props => [];
// }

// class CreateGroup_created extends GroupsStates {
//   @override
//   List<Object?> get props => [];
// }

// class CreateGroup_faild extends GroupsStates {
//   @override
//   List<Object?> get props => [];
// }

// //! states of event (enter group)

// class EnterGroup_entering extends GroupsStates {
//   @override
//   List<Object?> get props => [];
// }

// class EnterGroup_entered extends GroupsStates {
//   @override
//   List<Object?> get props => [];
// }

// class EnterGroup_faild extends GroupsStates {
//   @override
//   List<Object?> get props => [];
// }



// //? states of event (leave group)

// //? states of event (exit group)



































// // part of 'groups_bloc.dart';

// // abstract class GroupState {}

// // class LoadGroupsState extends GroupState {
// //   final Groups groups;

// //   LoadGroupsState(
// //     this.groups,
// //   );
// // }

// // class GroupInitial extends GroupState {}

// // class CreateGroupState extends GroupState {
// //   final String consultId;
// //   final String groupUid;
// //   final Groups groups;

// //   CreateGroupState(this.consultId, this.groupUid, this.groups);
// // }

// // class UploadGroupImage extends GroupState {}

// // class DownloadListState extends GroupState {}

// // class GetImageFromGallery extends GroupState {}

// // class FetchGroupsState extends GroupState {
// //   final String consultId;
// //   List<Groups> consultGroups;

// //   FetchGroupsState(this.consultId, this.consultGroups);
// // }
