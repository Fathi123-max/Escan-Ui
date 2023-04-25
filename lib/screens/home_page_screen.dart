import 'package:auto_size_text/auto_size_text.dart';
import 'package:escan_ui/common/color_constants.dart';
import 'package:escan_ui/custom_widgets/custom_munu_button.dart';
import 'package:escan_ui/custom_widgets/drawer.dart';
import 'package:escan_ui/custom_widgets/filter_widget.dart';
import 'package:escan_ui/custom_widgets/floating_widget.dart';
import 'package:escan_ui/custom_widgets/image_widget.dart';
import 'package:escan_ui/custom_widgets/menu_widget.dart';
import 'package:escan_ui/groups/persentaion/add_groups_screens/group_page.dart';
import 'package:escan_ui/properties/bloc/property_bloc/Houses_bloc.dart';
import 'package:escan_ui/properties/bloc/property_bloc/Houses_event.dart';
import 'package:escan_ui/properties/bloc/property_bloc/Houses_state.dart';
import 'package:escan_ui/properties/data/repositry/groups_repository.dart';
import 'package:escan_ui/screens/add_item_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePageScreen extends StatefulWidget {
  HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  final filterArray = [
    "<\$220.000",
    "For sale",
    "3-4 beds",
    "Kitchen",
  ];
  String _selectedCity = '';

  final List<String> cities = [
    'Madina Nasr',
    'Sharqia',
    'Mansoura',
    'AllCities'
  ];
  late HouseBloc houseBloc;
  List consulthouses = [];

  String _searchQuery = "";
  bool searchOn = false;
  @override
  void initState() {
    super.initState();
    // Dispatch the LoadGroups event when the widget is initialized

    houseBloc = HouseBloc();
    houseBloc.add(LoadHouses());
    // Call the fetchGroups method to fetch the groups for the current user
  }

  @override
  void dispose() {
    houseBloc.close();
    super.dispose();
  }

// Method to show the city picker slide bar.
  void _showCityPicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 300.0, // Adjust the height according to your needs.
          child: ListView.builder(
            itemCount: cities.length,
            itemBuilder: (BuildContext context, int index) {
              final city = cities[index];

              return ListTile(
                title: Text(city),
                onTap: () {
                  setState(() {
                    _selectedCity = city;
                    HouseRepositry.city = city;
                  });
                  print(HouseRepositry.city);

                  Navigator.pop(context);
                },
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Object? house = ModalRoute.of(context)?.settings.arguments;

    // State variable to keep track of the selected city.
    var screenWidth = MediaQuery.of(context).size.width;

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: ColorConstant.kWhiteColor,
      ),
    );
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
    return BlocBuilder<HouseBloc, HouseState>(
      bloc: houseBloc,
      builder: (context, state) {
        if (state is HouseLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is HouseLoaded) {
          return Scaffold(
            key: _scaffoldKey,
            backgroundColor: ColorConstant.kWhiteColor,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FloatingWidget(
              leadingIcon: Icons.home_filled,
              txt: "New Property",
              ontap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AddHouseScreen(),
                ));
              },
            ),
            endDrawer: MyDrawer(),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                  top: 35,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Builder(
                          builder: (context) {
                            return MenuWidget8(
                              iconImg: Icons.subject,
                              iconColor: ColorConstant.kBlackColor,
                              scaffoldContext: context,
                              onbtnTap: () {
                                _scaffoldKey.currentState!.openEndDrawer();
                              },
                            );
                          },
                        ),
                        MenuWidget(
                          iconImg: Icons.group,
                          iconColor: ColorConstant.kBlackColor,
                          onbtnTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => GroupsPage(),
                            ));
                          },
                          scaffoldContext: context,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Choose Your City 👇👇👇",
                      style: GoogleFonts.notoSans(
                        fontSize: 12,
                        color: ColorConstant.kGreyColor,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: _showCityPicker,
                      child: Text(
                        _selectedCity.isNotEmpty ? _selectedCity : 'AllCities',
                        style: GoogleFonts.notoSans(
                          fontSize: 36,
                          color: ColorConstant.kBlackColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Divider(
                      color: ColorConstant.kGreyColor,
                      thickness: .2,
                    ),
                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                        shrinkWrap: false,
                        scrollDirection: Axis.horizontal,
                        itemCount: filterArray.length,
                        itemBuilder: (context, index) {
                          return FilterWidget(
                            filterTxt: filterArray[index],
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    StreamBuilder(
                        stream: houseBloc.housesStream,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: AutoSizeText(snapshot.error.toString()),
                            );
                          } else {
                            final houses = snapshot.data!.toList();

                            return Column(
                              children: List.generate(
                                houses.length
                                // Constants.houseList.length
                                ,
                                (index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: ImageWidget(houses[index]
                                        // Constants.houseList[index]

                                        // Constants.imageList
                                        // houses[index].photos!

                                        ),
                                  );
                                },
                              ),
                            );
                          }
                        }),
                  ],
                ),
              ),
            ),
          );
        } else if (state is HouseError) {
          return Center(
            child: AutoSizeText(state.message),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
