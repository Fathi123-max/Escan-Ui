import 'dart:io';

import 'package:path_provider/path_provider.dart';

class Group {
  final String? consultId;
  final String? groupName;
  final String? groupImage;
  final String? groupLink;
  final List<GroupMember>? groupMembers;

  Group({
    this.consultId,
    this.groupName,
    this.groupImage,
    this.groupLink,
    this.groupMembers,
  });

  factory Group.fromMap(Map<String, dynamic> map) {
    var data = map;
    var members = (data['groupMembers'] as List<dynamic>)
        .map((member) => GroupMember.fromMap(member))
        .toList();
    String? imageUrl = '';

    if (data.containsKey('groupImage') &&
        data['groupImage'] != null &&
        data['groupImage'] != '') {
      if (data['groupImage'].startsWith('http')) {
        // If `groupImage` property already contains URL
        imageUrl = data['groupImage'];
      } else {
        // Convert file path to URL
        final Directory appDirectory =
            getApplicationDocumentsDirectory() as Directory;
        final String path = '${appDirectory.path}/${data['groupImage']}';
        final bool doesExist = File(path).exists() as bool;
        if (doesExist) {
          try {
            final Uri uri = Uri.file(path);
            imageUrl = uri.toString();
          } catch (e) {
            print('Error while getting file path - $e');
          }
        }
      }
    }

    return Group(
      consultId: data["consultId"],
      groupName: data['groupName'],
      groupImage: imageUrl,
      groupLink: data['groupLink'],
      groupMembers: members,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "consoltId": consultId,
      'groupName': groupName,
      'groupImage': groupImage,
      'groupLink': groupLink,
      'groupMembers': groupMembers?.map((member) => member.toMap()).toList(),
    };
  }
}

class GroupMember {
  final String? name;
  final String? profileImage;

  GroupMember({
    this.name,
    this.profileImage,
  });

  factory GroupMember.fromMap(Map<String, dynamic> map) {
    return GroupMember(
      name: map['name'],
      profileImage: map['email'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': profileImage,
    };
  }
}
