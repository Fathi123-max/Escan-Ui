import 'package:auto_size_text/auto_size_text.dart';
import 'package:escan_ui/groups/persentaion/add_groups_screens/list_groups_screen.dart';
import 'package:escan_ui/properties/data/models/Houses_model.dart';
import 'package:flutter/material.dart';

class GroupsPage extends StatefulWidget {
  House? house;

  GroupsPage({
    Key? key,
    this.house,
  });
  @override
  GroupsPageState createState() => GroupsPageState();
}

class GroupsPageState extends State<GroupsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const AutoSizeText(
          "Chats",
          style: TextStyle(
            fontFamily: 'Ithra',
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        // actions: [AddGroupForm()],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: GroupList(house: House()),
      ),
    );
  }
}
