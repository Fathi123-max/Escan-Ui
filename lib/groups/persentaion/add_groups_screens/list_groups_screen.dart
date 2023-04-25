// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:escan_ui/properties/data/models/Houses_model.dart';

import '../../bloc/groups_bloc/groups_bloc.dart';
import '../../bloc/groups_bloc/groups_event.dart';
import '../../bloc/groups_bloc/groups_state.dart';
import '../../helpers/app.dart';
import 'group_screen.dart';

// import '../single_group_screen.dart/chat_screen_for_groups _home.dart';

class GroupList extends StatefulWidget {
  GroupList({super.key, required this.house});
  House house;
  @override
  State<GroupList> createState() => _GroupListState();
}

class _GroupListState extends State<GroupList> {
  late GroupBloc _groupBloc;
  List consultGroups = [];

  String _searchQuery = "";
  bool searchOn = false;
  @override
  void initState() {
    super.initState();
    // Dispatch the LoadGroups event when the widget is initialized

    _groupBloc = GroupBloc();
    _groupBloc.add(LoadGroups());
    // Call the fetchGroups method to fetch the groups for the current user
  }

  @override
  void dispose() {
    _groupBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      children: [
        Expanded(
          child: Container(
            alignment: Alignment.center,
            child: SizedBox(
              height: size.height,
              width: size.width * .77,
              child: BlocBuilder(
                bloc: _groupBloc,
                builder: (context, state) {
                  if (state is GroupLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is GroupLoaded) {
                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xfffafafa),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextFormField(
                            onChanged: (value) {
                              setState(() {
                                _searchQuery = value;
                                print(_searchQuery + "*********************");
                                searchOn = true;
                              });
                            },
                            decoration: const InputDecoration(
                              hintText: 'Search by Name',
                              icon: Icon(Icons.search),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Expanded(
                          child: StreamBuilder(
                              stream: searchOn
                                  ? _groupBloc.groupsStreamByName(_searchQuery)
                                  : _groupBloc.groupsStream,
                              builder: (context, snapshot) {
                                print(
                                    _searchQuery + "********************* 123");

                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (snapshot.hasError) {
                                  return Center(
                                    child:
                                        AutoSizeText(snapshot.error.toString()),
                                  );
                                } else {
                                  final groups = snapshot.data!.toList();
                                  print(searchOn);
                                  return ListView.builder(
                                      itemCount: groups.length,
                                      itemBuilder: (context, index) {
                                        var group = groups[index];
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) {
                                                return ChatGroupScreen2(
                                                  groupName: group.groupName!,
                                                );
                                              }
                                                  //  => ChatScreenForGroups(appointment: , user: "",),
                                                  ),
                                            );
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 20, top: 20),
                                            child: Container(
                                              padding: const EdgeInsets.only(
                                                  left: 10, right: 20),
                                              height: 150,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  color: AppColors.grey4),
                                              child: Row(
                                                children: [
                                                  CircleAvatar(
                                                    radius: size.height * .04,
                                                    backgroundColor:
                                                        AppColors.lightGrey1,
                                                    child: widget.house.photos![
                                                                    0] !=
                                                                null &&
                                                            widget
                                                                .house
                                                                .photos![0]
                                                                .isNotEmpty &&
                                                            Uri.tryParse(widget
                                                                        .house
                                                                        .photos![
                                                                    0]) !=
                                                                null
                                                        ? ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50),
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl: widget
                                                                  .house
                                                                  .photos![0],
                                                              fit: BoxFit.cover,
                                                              width:
                                                                  size.height *
                                                                      .080,
                                                              height:
                                                                  size.height *
                                                                      .080,
                                                              placeholder: (context,
                                                                      url) =>
                                                                  const CircularProgressIndicator(),
                                                              errorWidget: (context,
                                                                      url,
                                                                      error) =>
                                                                  const Icon(Icons
                                                                      .error),
                                                            ),
                                                          )
                                                        : const Icon(
                                                            Icons.image),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        15, 45, 15, 20),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        AutoSizeText(
                                                          widget.house.address!,
                                                          style:
                                                              const TextStyle(
                                                            fontFamily: 'Ithra',
                                                            color:
                                                                AppColors.pink,
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                        Text(
                                                          "memmbers${widget.house.squarefoot}    ",
                                                          style:
                                                              const TextStyle(
                                                            fontFamily: 'Ithra',
                                                            color:
                                                                AppColors.grey,
                                                            fontSize: 13,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      IconButton(
                                                        icon: const Icon(
                                                          Icons.arrow_forward,
                                                          color: AppColors.pink,
                                                        ),
                                                        onPressed: () {
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) {
                                                            return ChatGroupScreen2(
                                                              groupName: widget
                                                                  .house.id!,
                                                            );
                                                          }
                                                              //  => ChatScreenForGroups(appointment: , user: "",),
                                                              );
                                                        },
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                                }
                              }),
                        ),
                      ],
                    );
                  } else if (state is GroupError) {
                    return Center(
                      child: AutoSizeText(state.message),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}



































































































































/*    color: AppColors.pink,
              Icons.add_circle_outline,
              size: 30.h,
           */


// class ListGroupScreen extends StatefulWidget {
//   const ListGroupScreen({Key? key, required this.consultId}) : super(key: key);
//   final String consultId;

//   @override
//   State<ListGroupScreen> createState() => _ListGroupScreenState();
// }

// class _ListGroupScreenState extends State<ListGroupScreen> {
//   List<Groups> consultGroups = [];

//   @override
//   void initState() {
//     BlocProvider.of<GroupsBloc>(context).fetchGroups(widget.consultId);

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: AutoSizeText(
//           getTranslated(context, "myGroups"),
//           style: TextStyle(
//             fontFamily: 'Ithra',
//             color: Colors.black,
//             fontWeight: FontWeight.bold,
//             fontSize: 18.0,
//           ),
//         ),
//         actions: [
//           GroupBottomSheet(
//             iconButton: Icon(
//               color: AppColors.pink,
//               Icons.add_circle_outline,
//               size: 30.h,
//             ),
//             consultId: widget.consultId,
//             context: context,
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Container(
//               alignment: Alignment.center,
//               child: Container(
//                 height: size.height,
//                 width: size.width * .77,
//                 child: BlocBuilder<GroupsBloc, GroupState>(
//                   builder: (context, state) {
//                     if (state is FetchGroupsState) {
//                       consultGroups = state.consultGroups;
//                       print(
//                           "**************************${consultGroups.length}");
//                       return ListView.builder(
//                           itemCount: consultGroups.length,
//                           itemBuilder: (context, index) {
//                             return GestureDetector(
//                               onTap: () {
//                                 Navigator.of(context).push(
//                                   MaterialPageRoute(builder: (context) {
//                                     return Container();
//                                   }
//                                       //  => ChatScreenForGroups(appointment: , user: "",),
//                                       ),
//                                 );
//                               },
//                               child: Padding(
//                                 padding: EdgeInsets.all(20.h),
//                                 child: Container(
//                                   padding:
//                                       EdgeInsets.only(left: 10.h, right: 20.h),
//                                   height: 150.h,
//                                   decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(30.h),
//                                       color: AppColors.grey4),
//                                   child: Row(
//                                     children: [
//                                       CircleAvatar(
//                                         radius: 31.h,
//                                         // backgroundColor: AppColors.lightGrey1,
//                                         //  child: Image.network(Uri.decodeFull(consultGroups[index].image!)),
//                                         //   : Icon(
//                                         // Icons.person, color: AppColors.lightGrey, size: 35.h,),
//                                       ),
//                                       Padding(
//                                         padding: EdgeInsets.fromLTRB(
//                                             15.h, 45.h, 15.h, 20.h),
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             AutoSizeText(
//                                               consultGroups[index].groupName!,
//                                               style: TextStyle(
//                                                 fontFamily: 'Ithra',
//                                                 color: AppColors.pink,
//                                                 fontSize: 15,
//                                               ),
//                                             ),
//                                             AutoSizeText(
//                                               '20 applicant',
//                                               style: TextStyle(
//                                                 fontFamily: 'Ithra',
//                                                 color: AppColors.grey,
//                                                 fontSize: 13,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       Spacer(),
//                                       Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.end,
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.end,
//                                         children: [
//                                           IconButton(
//                                             icon: Icon(
//                                               Icons.arrow_forward,
//                                               color: AppColors.pink,
//                                             ),
//                                             onPressed: () {
//                                               print(
//                                                   "object********************************************************************");
//                                               return setState(() {});
//                                             },
//                                           )
//                                         ],
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             );
//                           });
//                     } else {
//                       return MyGroupsScreen(consultId: widget.consultId);
//                     }
//                   },
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

















































/*

class AddGroupForm extends StatefulWidget {
  @override
  _AddGroupFormState createState() => _AddGroupFormState();
}

class _AddGroupFormState extends State<AddGroupForm> {
  final _formKey = GlobalKey<FormState>();
  final _groupNameController = TextEditingController();
  final _groupLinkController = TextEditingController();
  final _groupImageController = TextEditingController();
  final _groupMembersController = TextEditingController();
  List<GroupMember> _members = [];

  @override
  void dispose() {
    _groupNameController.dispose();
    _groupLinkController.dispose();
    _groupImageController.dispose();
    _groupMembersController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: AutoSizeText('Add Group'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _groupNameController,
              decoration: InputDecoration(labelText: 'Group Name'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a group name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _groupLinkController,
              decoration: InputDecoration(labelText: 'Group Link'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a group link';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _groupImageController,
              decoration: InputDecoration(labelText: 'Group Image URL'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a group image URL';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _groupMembersController,
              decoration: InputDecoration(labelText: 'Group Members'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter group members';
                }
                return null;
              },
              onEditingComplete: () {
                setState(() {
                  var members = _groupMembersController.text
                      .replaceAll(' ', '')
                      .split(',');
                  _members = members
                      .map((member) =>
                          GroupMember(name: member, profileImage: ''))
                      .toList();
                });
              },
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: AutoSizeText('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      var groupName = _groupNameController.text;
                      var groupLink = _groupLinkController.text;
                      var groupImage = _groupImageController.text;

                      context.read<GroupBloc>().add(AddGroup(
                            groupName: groupName,
                            groupLink: groupLink,
                            groupImage: groupImage,
                            groupMembers: _members,
                          ));

                      Navigator.of(context).pop();
                    }
                  },
                  child: AutoSizeText('Add'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

*/


