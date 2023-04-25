import 'dart:async';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:escan_ui/common/color_constants.dart';
import 'package:escan_ui/custom_widgets/floating_widget.dart';
import 'package:escan_ui/custom_widgets/house_widget.dart';
import 'package:escan_ui/custom_widgets/menu_widget.dart';
import 'package:escan_ui/groups/persentaion/add_groups_screens/group_page.dart';
import 'package:escan_ui/properties/data/models/Houses_model.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../groups/bloc/groups_bloc/groups_bloc.dart';
import '../groups/bloc/groups_bloc/groups_event.dart';

class ItemDetailScreen extends StatefulWidget {
  House house;
  ItemDetailScreen(
    this.house,
  );

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  Future<File> loadAssetAsFile(String assetPath) async {
    final completer = Completer<File>();
    final fileStream =
        File('${(await getTemporaryDirectory()).path}/$assetPath');

    try {
      final bytes = await rootBundle.load(assetPath);
      final buffer = bytes.buffer;
      await fileStream.create(recursive: true);
      await fileStream.writeAsBytes(
          buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
      completer.complete(fileStream);
    } catch (error) {
      completer.completeError(error);
    }

    return completer.future;
  }

  String? imageUrl;

  @override
  void initState() {
    super.initState();
    groupImage = File("");
    storage = FirebaseStorage.instance;
  }

  @override
  void dispose() {
    super.dispose();
  }

//! image frpm gallery
  File? groupImage;
  final picker = ImagePicker();

  FirebaseStorage? storage;

// Initialize the image picker
  final ImagePicker _picker = ImagePicker();

  /*

  
  void _copyGroupLink() async {
    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse(
          "https://firebasedynamiclinks.googleapis.com/v1/shortLinks?key=AIzaSyAZ9B_jnmkYC-HmcNAPZ8OxeiRsltBTof4"),
      uriPrefix: "https://jeras.page.link",
      androidParameters: const AndroidParameters(
        packageName: "com.app.jerasgroups",
        minimumVersion: 30,
      ),
      iosParameters: const IOSParameters(
        bundleId: "com.app.jerasgroups",
        appStoreId: "123456789",
        minimumVersion: "1.0.1",
      ),
      // googleAnalyticsParameters: const GoogleAnalyticsParameters(
      //   source: "twitter",
      //   medium: "social",
      //   campaign: "example-promo",
      // ),
      // socialMetaTagParameters: SocialMetaTagParameters(
      //   title: "Example of a Dynamic Link",
      //   imageUrl: Uri.parse("https://example.com/image.png"),
      // ),
    );
    final dynamicLink =
        await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);

    try {
      // Build a short dynamic link
      final dynamicLinkString = await dynamicLink.toString();
      // Copy the dynamic link to the clipboard
      await Clipboard.setData(ClipboardData(text: dynamicLinkString));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Link copied to clipboard.'),
        ),
      );
    } catch (e) {
      print('Error: $e');
    }
  }
void _copyGroupLink() async {
  // Create a dynamic link with the group ID
  final DynamicLinkParameters parameters = DynamicLinkParameters(
    uriPrefix: 'https://yourproject.page.link',
    link: Uri.parse('https://yourproject.com/group/${_groupNameController.text}'),
    androidParameters: AndroidParameters(
      packageName: 'yourproject.package.name',
      minimumVersion: 125,
    ),
  );

  try {
    // Build a short dynamic link
    final Uri dynamicLink = await parameters.buildShortLink();
    final String dynamicLinkString = dynamicLink.toString();

    // Copy the dynamic link to the clipboard
    await Clipboard.setData(ClipboardData(text: dynamicLinkString));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Link copied to clipboard.'),
      ),
    );
  } catch (e) {
    print('Error: $e');
  }
}
*/
/*
  Future imgFromGallery(String imageUrl) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        groupImage = File(pickedFile.path);
        print(pickedFile.path);
        imageUrl = pickedFile.path;
      } else {
        print('No image selected.');
      }
    });
  }
 */
  @override
  Widget build(BuildContext context) {
    imageUrl = widget.house.photos![0];
    final houseArray = [
      "${widget.house.squarefoot}",
      "${widget.house.bedrooms}",
      "${widget.house.bathrooms}",
      "${widget.house.garages}",
      "${widget.house.kitchen}",
    ];

    final typeArray = [
      "Square foot",
      "Bedrooms",
      "bathrooms",
      "Garage",
      "Kitchen",
    ];
    var screenWidth = MediaQuery.of(context).size.width;
    final oCcy = NumberFormat("##,##,###", "en_INR");
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: ColorConstant.kWhiteColor,
      ),
    );
    return Scaffold(
      backgroundColor: ColorConstant.kWhiteColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 0,
        ),
        width: screenWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            FloatingWidget(
              leadingIcon: Icons.mail,
              txt: "Message",
              ontap: () async {
                var groupImageRef = storage!.ref().child('path/to/groupImage');
                var groupImageUploadTask = groupImageRef.putString(imageUrl!);

                await groupImageUploadTask.whenComplete(() async {
                  var groupImageURL = await groupImageRef.getDownloadURL();

                  context.read<GroupBloc>().add(AddGroup(
                        groupName: "groupName",
                        groupLink: "groupLink",
                        groupImage: groupImageURL,
                        groupMembers: [],
                        consultId: "consoltId",
                      ));

                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => GroupsPage(house: widget.house),
                  ));
                });
              },
            ),
            FloatingWidget(leadingIcon: Icons.phone, txt: "Call", ontap: () {}),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 25, bottom: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(top: 0, bottom: 10),
                    child: SizedBox(
                        height: 200.0,
                        width: screenWidth,
                        child: CarouselSlider(
                            items: widget.house.photos!
                                .map((e) => GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Scaffold(
                                              body: Center(
                                                child: ExtendedImage.network(
                                                  e,
                                                  mode:
                                                      ExtendedImageMode.gesture,
                                                  initGestureConfigHandler:
                                                      (_) => GestureConfig(
                                                    minScale: 0.9,
                                                    animationMinScale: 0.7,
                                                    maxScale: 3.0,
                                                    animationMaxScale: 3.5,
                                                    speed: 1.0,
                                                    inertialSpeed: 100.0,
                                                    inPageView: false,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      child: Image.network(
                                        e,
                                        fit: BoxFit.fill,
                                      ),
                                    ))
                                .toList(),
                            options: CarouselOptions(
                                autoPlay: true,
                                aspectRatio: 16 / 9,
                                disableCenter: true,
                                enlargeFactor: 1,
                                enlargeCenterPage: true,
                                pageSnapping: false,
                                pauseAutoPlayOnTouch: true,
                                viewportFraction: 1))),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 15,
                      right: 15,
                      left: 15,
                    ),

/*
 Carousel(
                        images: [
                          ExactAssetImage(imageList[imgpath_index]),
                          ExactAssetImage(imageList[0]),
                          ExactAssetImage(imageList[1]),
                          ExactAssetImage(imageList[2]),
                          ExactAssetImage(imageList[3]),
                          ExactAssetImage(imageList[4]),
                          ExactAssetImage(imageList[5]),
                        ],
                        showIndicator: true,
                        borderRadius: false,
                        moveIndicatorFromBottom: 180.0,
                        noRadiusForIndicator: true,
                        overlayShadow: false,
                        overlayShadowColors: Colors.white,
                        overlayShadowSize: 0.7,
                      ), */

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        MenuWidget(
                          iconImg: Icons.arrow_back,
                          iconColor: ColorConstant.kWhiteColor,
                          conBackColor: Colors.transparent,
                          onbtnTap: () {
                            Navigator.pop(context);
                          },
                          scaffoldContext: context,
                        ),
                        MenuWidget(
                          iconImg: Icons.favorite_border,
                          iconColor: ColorConstant.kWhiteColor,
                          conBackColor: Colors.transparent,
                          onbtnTap: () {},
                          scaffoldContext: context,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Container(
                padding: const EdgeInsets.only(left: 15, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '\$' + "${oCcy.format(widget.house.amount)}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            widget.house.address!,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Container(
                        height: 45,
                        width: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                            color: Colors.grey[200]!,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "20 hours ago",
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 15,
                  bottom: 15,
                  left: 15,
                ),
                child: Text(
                  "House Information",
                  style: GoogleFonts.notoSans(
                    fontSize: 20,
                    color: ColorConstant.kBlackColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                height: 110,
                child: ListView.builder(
                  shrinkWrap: false,
                  scrollDirection: Axis.horizontal,
                  itemCount: houseArray.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: HouseWidget(
                        type: typeArray[index],
                        number: houseArray[index].toString(),
                      ),
                    );
                  },
                ),
              ),
              Container(
                  child: Padding(
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                  top: 20,
                  bottom: 20,
                ),
                child: Text(
                  "Flawless 2 story on a family friendly cul-de-sac in the heart of Blue Valley! Walk in to an open floor plan flooded w daylightm, formal dining private office, screened-in lanai w fireplace, TV hookup & custom heaters that overlooks the lit basketball court.",
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.notoSans(
                    fontSize: 15,
                    color: ColorConstant.kGreyColor,
                  ),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
