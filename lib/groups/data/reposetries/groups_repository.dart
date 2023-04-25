import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escan_ui/groups/bloc/groups_bloc/groups_event.dart';

import '../models/groups.dart';

class GroupsRepositry {
  final _firestore = FirebaseFirestore.instance;

  final StreamController<List<Group>> _groupController =
      StreamController<List<Group>>.broadcast();
  Stream<List<Group>> get groupStream => _groupController.stream;

  Stream<List<Group>> get groupStreambyName => _groupController.stream;

  Stream<List<Group>> getGroupStream() {
    return _firestore.collection("new").snapshots().map(
        (event) => event.docs.map((doc) => Group.fromMap(doc.data())).toList());
  }

  Stream<List<Group>> getGroupStreamByName(String search) {
    return _firestore
        .collection("new")
        .where("groupName", isGreaterThanOrEqualTo: search)
        .snapshots()
        .map((event) =>
            event.docs.map((doc) => Group.fromMap(doc.data())).toList());
  }

  Future<void> addGroup(AddGroup event) async {
    var group = Group(
      consultId: event.groupName,
      groupName: event.groupName,
      groupImage: event.groupImage,
      groupLink: event.groupLink,
      groupMembers: event.groupMembers,
    );

    var groupMap = group.toMap();
    await _firestore.collection('new').add(groupMap);
  }

  Future<void> updateGroup(UpdateGroup event) async {
    // Obtain a reference to the document
    final docRef = FirebaseFirestore.instance.collection('new').doc('docId');

// Listen to the snapshots of the document
    final snapshot = docRef.snapshots();
    // Listen to the snapshots of the document

// Get the ID of the document
    snapshot.listen((DocumentSnapshot snapshot) {
      final docId = snapshot.id;
      print('Document ID: $docId');

      var group = event.group;
      var groupMap = group.toMap();
      _firestore.collection('new').doc(docId).update(groupMap);
    });
  }

  Future<void> deleteGroup(String consultId) async {
    // Define a Query that filters the documents by email address

    print(consultId + "*************************");
    final query = FirebaseFirestore.instance
        .collection('new')
        .where('groupName', isEqualTo: consultId);

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





//? old load groups 
/*

  Future<List<Group>> loadGroups() async {
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




















































