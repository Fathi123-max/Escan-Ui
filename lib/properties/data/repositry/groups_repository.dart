import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escan_ui/properties/bloc/property_bloc/Houses_event.dart';
import 'package:escan_ui/properties/data/models/Houses_model.dart';

class HouseRepositry {
  static House house = House();

  final _firestore = FirebaseFirestore.instance;
  static String city = "AllCities";
  final StreamController<List<House>> _houseController =
      StreamController<List<House>>.broadcast();
  Stream<List<House>> get houseStream => _houseController.stream;

  Stream<List<House>> get houseStreambyName => _houseController.stream;

  Stream<List<House>> getHouseStream() {
    return _firestore.collection(city).snapshots().map((event) =>
        event.docs.map((doc) => House.fromFirebaseSnapshot(doc)).toList());
  }

  Stream<List<House>> getHouseStreamByName(String search) {
    return _firestore
        .collection(city)
        .where("HouseName", isGreaterThanOrEqualTo: search)
        .snapshots()
        .map((event) =>
            event.docs.map((doc) => House.fromFirebaseSnapshot(doc)).toList());
  }

  Future<void> addHouse(AddHouse event) async {
    var house = House(
      address: event.address,
      amount: event.amount,
      bathrooms: event.bathrooms,
      bedrooms: event.bedrooms,
      garages: event.garages,
      id: event.id,
      isFavorite: event.isFavourite,
      kitchen: event.kitchen,
      photos: event.photos,
      squarefoot: event.squarefoot,
    );

    var houseMap = house.toFirebaseMap();
    await _firestore.collection(city).add(houseMap);
  }

  Future<void> updateHouse(UpdateHouse event) async {
    // Obtain a reference to the document
    final docRef = FirebaseFirestore.instance.collection('houses').doc('docId');

// Listen to the snapshots of the document
    final snapshot = docRef.snapshots();
    // Listen to the snapshots of the document

// Get the ID of the document
    snapshot.listen((DocumentSnapshot snapshot) {
      final docId = snapshot.id;
      print('Document ID: $docId');

      var House = event.house;
      var HouseMap = House.toFirebaseMap();
      _firestore.collection(city).doc(docId).update(HouseMap);
    });
  }

  Future<void> deleteHouse(String id) async {
    // Define a Query that filters the documents by email address

    print(id + "*************************");
    final query = FirebaseFirestore.instance
        .collection(city)
        .where('HouseName', isEqualTo: id);

// Execute the query and get the QuerySnapshot
    final querySnapshot = await query.get();

// Iterate over the matched documents and delete them
    for (final docSnapshot in querySnapshot.docs) {
      final docRef = docSnapshot.reference;
      await docRef.delete();
      print(docRef);
    }
  }
} 





//? old load Houses 
/*

  Future<List<House>> loadGroups() async {
    var querySnapshot = await _firestore.collection('newgroups').get();
    var groups = <Group>[];
    for (var docSnapshot in querySnapshot.docs) {
      groups.add(Group.fromMap(docSnapshot.data()));
    }

    // Check if there are no groups in the collection
    if (groups.isEmpty) {
      // Create a new group document by calling set()
      var newGroupData = {
        'groupName': 'New Group',
        'groupImageUrl': "https://via.placeholder.com/600/24f355",
        'groupLink': "",
        'groupMembers': []
      };
      await _firestore
          .collection('newgroupstest556')
          .doc('new-group-id')
          .set(newGroupData);

      // Reload the groups after adding the new document
      querySnapshot = await _firestore.collection('newgroupstest556').get();
      for (var docSnapshot in querySnapshot.docs) {
        groups.add(Group.fromMap(docSnapshot.data()));
      }
    }

    return groups;
  } */


















//? ny prives code

/*

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jeras/models/groups.dart';

class GroupRepository {
  final CollectionReference _groupsCollection =
      FirebaseFirestore.instance.collection('groups');

  Future<List<Group>> getAllGroups() async {
    QuerySnapshot snapshot = await _groupsCollection.get();
    return snapshot.docs.map((doc) => Group.fromSnapshot(doc)).toList();
  }

  Future<Group> getGroupById(String groupId) async {
    final doc = await _groupsCollection.doc(groupId).get();
    return Group.fromSnapshot(doc);
  }

  Future<void> addGroup(Group group) async {
    await _groupsCollection.add({
      'groupName': group.groupName,
      'groupImage': group.groupImage,
      'groupLink': group.groupLink,
      'groupMembers': group.groupMembers
          ?.map((member) =>
              {'name': member.name, 'profileImage': member.profileImage})
          .toList(),
    });
  }

  Future<void> updateGroup(Group group) async {
    await _groupsCollection.doc(group.id).update({
      'groupName': group.groupName,
      'groupImage': group.groupImage,
      'groupLink': group.groupLink,
      'groupMembers': group.groupMembers
          ?.map((member) =>
              {'name': member.name, 'profileImage': member.profileImage})
          .toList(),
    });
  }

  Future<void> deleteGroup(String groupId) async {
    await _groupsCollection.doc(groupId).delete();
  }
}


 */ 







//! ithar code 

/*






import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:jeras/config/paths.dart';
import 'package:jeras/models/groups.dart';

class GroupsProvider {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  late Groups groups;
  late File groupImage;

  Future<Groups> createGroup(Groups groups, String groupUid) async {
    await db
        .collection(Paths.groupsPath)
        .doc(groupUid)
        .set(groups.toJson(), SetOptions(merge: true));

    print('success creating********************');
    return groups;
  }

  Future<Groups> getGroups(String groupUid) async {
    try {
      DocumentSnapshot documentSnapshot =
          await db.collection(Paths.groupsPath).doc(groupUid).get();

      groups = Groups.fromJson(documentSnapshot.data() as Map);

      return groups;
    } catch (e) {
      print(e);

      return Future.error(e.toString());
    }
  }

  // Future<Groups> fetchGroupUid (Groups formattedGroups) async {
  //   if (formattedGroups.groupUid!.isEmpty == true) {
  //     final groupDoc = await db.collection(Paths.groupsPath).where('glo')
  //   }
  // }

  Future<void> updateConsultGroups(String consultId) async {
    final QuerySnapshot snapshot = await db
        .collection(Paths.groupsPath)
        .where('consultId', isEqualTo: consultId)
        .get();

    // final List<dynamic> groupUids = snapshot.docs.map((doc) =>
    // Groups.fromFirestore).toList();

    // Update the consultGroups list of the document associated with the input consultId.
    await db.collection('groups').doc(consultId).update({
      'consultGroups': groups.groupUid,
    });
    print('success Updating groups********************');
  }

  Future<Groups> loadGroups(Groups groups) async {
    try {
      await db.collection(Paths.groupsPath).doc(groups.groupUid).get();
      print('load Groups **********************');
      return groups;
    } on FirebaseException catch (e) {
      print(e.toString());
      return Future.error(e.toString());
    }
  }

  Future<List<Groups>> getGroupsForConsultant(String consultId) async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('groups')
        .where('consultId', isEqualTo: consultId)
        .get();
    print(querySnapshot.docs.map((doc) => Groups.fromDocument(doc)).toList());
    return querySnapshot.docs.map((doc) => Groups.fromDocument(doc)).toList();
  }

  // Future getImageFromGallery() async {
  //   final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  //
  //
  //     if (pickedFile != null) {
  //       groupImage = File(pickedFile.path);
  //       // BlocProvider.of<AccountBloc>(context).uploadGroupImage(groupImage);
  //     } else {
  //       print('No image selected.');
  //     }
  // }
  Future uploadImage() async {
    final storageRef = FirebaseStorage.instance.ref();
    final pathReference =
        storageRef.child("groupImage/${DateTime.now().toString()}");
    // child('images/${groupImage.path}');

    TaskSnapshot taskSnapshot = await pathReference.putFile(groupImage);
    final downloadUrl = await taskSnapshot.ref.getDownloadURL();

    final encodedUrl = Uri.encodeFull(downloadUrl.replaceAll(' ', '%20'));

    await FirebaseFirestore.instance.collection('groups').add({
      'image': encodedUrl,
    });
  }
}





import 'package:jeras/models/groups.dart';
import 'package:jeras/providers/groups_provider.dart';

class GroupsRepository {
  GroupsProvider groupsProvider = GroupsProvider();

  Future<Groups> createGroup(Groups groups, String uid) =>
      groupsProvider.createGroup(groups, uid);

  Future<Groups> getGroups(String groupUid) =>
      groupsProvider.getGroups(groupUid);

  Future uploadImage() => groupsProvider.uploadImage();
  // Future getImageFromGallary() => userDataProvider.getImageFromGallery();

  Future<List<Groups>> fetchConsultGroups(String consultId) =>
      groupsProvider.getGroupsForConsultant(consultId);

  Future<Groups> loadGroups(Groups groups) => groupsProvider.loadGroups(groups);

  Future<void> updateConsultGroups(String consultId) =>
      groupsProvider.updateConsultGroups(consultId);
}
 */




















































