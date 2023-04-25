import 'package:equatable/equatable.dart';
import 'package:escan_ui/properties/data/models/Houses_model.dart';

abstract class HouseEvent extends Equatable {
  const HouseEvent();

  @override
  List<Object> get props => [];
}

class LoadHouses extends HouseEvent {}

class AddHouse extends HouseEvent {
  final int amount, bathrooms, bedrooms, garages, kitchen;
  final double squarefoot;
  final String address, id;
  final bool isFavourite;
  final List<String> photos;

  const AddHouse({
    required this.amount,
    required this.bathrooms,
    required this.bedrooms,
    required this.garages,
    required this.kitchen,
    required this.squarefoot,
    required this.address,
    required this.id,
    required this.isFavourite,
    required this.photos,
  });

  @override
  List<Object> get props => [
        amount,
        bathrooms,
        bedrooms,
        garages,
        kitchen,
        squarefoot,
        address,
        id,
        isFavourite,
        photos
      ];
}

class UpdateHouse extends HouseEvent {
  final House house;
  const UpdateHouse({required this.house});

  @override
  List<Object> get props => [house];
}

class DeleteHouse extends HouseEvent {
  final String houseId;

  const DeleteHouse({required this.houseId});

  @override
  List<Object> get props => [houseId];
}
















































// import 'package:equatable/equatable.dart';

// //? base event
// abstract class HousesEvent extends Equatable {}

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
