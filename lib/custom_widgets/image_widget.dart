import 'package:auto_size_text/auto_size_text.dart';
import 'package:escan_ui/properties/data/models/Houses_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/color_constants.dart';
import '../screens/item_detail_screen.dart';

class ImageWidget extends StatefulWidget {
  House house;
  bool showFavorite;
  Function()? onRemove;

  ImageWidget(
    this.house, {
    super.key,
    this.showFavorite = true,
    this.onRemove,
  });

  @override
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  final oCcy = NumberFormat("##,##,###", "en_INR");

  Future<void> addFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];

    if (!favorites.contains(id)) {
      favorites.add(id);
      prefs.setStringList('favorites', favorites);
    }
  }

  Future<void> removeFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];

    if (favorites.contains(id)) {
      favorites.remove(id);
      prefs.setStringList('favorites', favorites);

      if (widget.onRemove != null) widget.onRemove!();
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ItemDetailScreen(
                  widget.house,
                ),
              ),
            );
          },
          child: Container(
            height: 160,
            width: screenWidth,
            padding: const EdgeInsets.only(left: 12, right: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(widget.house.photos![0]),
              ),
            ),
            child: widget.showFavorite
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                        ),
                        child: IconButton(
                          icon: widget.house.isFavorite ?? false
                              ? const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                )
                              : const Icon(
                                  Icons.favorite_border,
                                  color: ColorConstant.kWhiteColor,
                                ),
                          onPressed: () {
                            setState(() {
                              widget.house.isFavorite =
                                  !widget.house.isFavorite!;

                              if (widget.house.isFavorite!) {
                                addFavorite(widget.house.id!);
                              } else {
                                removeFavorite(widget.house.id!);
                              }
                            });
                          },
                        ),
                      )
                    ],
                  )
                : Container(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 10,
            top: 15,
            bottom: 10,
          ),
          child: Row(
            children: <Widget>[
              AutoSizeText(
                "\$" + "${oCcy.format(widget.house.amount ?? 0)}",
                style: GoogleFonts.notoSans(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              AutoSizeText(
                widget.house.address ?? "",
                style: GoogleFonts.notoSans(
                  fontSize: 10,
                  color: ColorConstant.kGreyColor,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 10,
            top: 0,
            bottom: 10,
          ),
          child: AutoSizeText(
            widget.house.bedrooms.toString() +
                " bedrooms / " +
                widget.house.bathrooms.toString() +
                " bathrooms / " +
                widget.house.squarefoot.toString() +
                " ft\u00B2",
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }
}

















/*
class _ImageWidgetState extends State<ImageWidget> {
// add property to shared preferences
  void addFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];

// Copy code

    if (!favorites.contains(id)) {
      favorites.add(id);
      prefs.setStringList('favorites', favorites);
    }
  }

// remove property from shared preferences
  void removeFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];

// Copy code

    if (favorites.contains(id)) {
      favorites.remove(id);
      prefs.setStringList('favorites', favorites);

      if (widget.onRemove != null) widget.onRemove!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final oCcy = NumberFormat("##,##,###", "en_INR");
    var screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            if (widget.house != null &&
                widget.imgpathIndex != null &&
                widget.imageList != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ItemDetailScreen(this.widget.house,
                      this.widget.imgpathIndex, this.widget.imageList),
                ),
              );
            }
          },
          child: Container(
            height: 160,
            width: screenWidth,
            padding: const EdgeInsets.only(left: 12, right: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(
                  widget.imageList[widget.imgpathIndex],
                ),
              ),
            ),
            child: widget.showFavorite
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                        ),
                        child: IconButton(
                          icon: widget.house.isFavorite!
                              ? const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                )
                              : const Icon(
                                  Icons.favorite_border,
                                  color: ColorConstant.kWhiteColor,
                                ),
                          onPressed: () {
                            setState(() {
                              widget.house.isFavorite =
                                  !widget.house.isFavorite!;

// Copy code                          // add/remove the property from shared preferences based on the favorite status
                              if (widget.house.isFavorite!) {
                                addFavorite(widget.house.id!);
                              } else {
                                removeFavorite(widget.house.id!);
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  )
                : Container(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 10,
            top: 15,
            bottom: 10,
          ),
          child: Row(
            children: <Widget>[
              Text(
                "\$${oCcy.format(widget.house.amount)}",
                style: GoogleFonts.notoSans(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                widget.house.address!,
                style: GoogleFonts.notoSans(
                  fontSize: 15,
                  color: ColorConstant.kGreyColor,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 10,
            top: 0,
            bottom: 10,
          ),
          child: Text(
            "${widget.house.bedrooms} bedrooms / ${widget.house.bathrooms} bathrooms / ${widget.house.squarefoot} ft\u00B2",
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }
}
*/
