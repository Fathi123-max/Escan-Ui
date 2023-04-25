import 'package:flutter/material.dart';

class MenuWidget8 extends StatefulWidget {
  final IconData? iconImg;
  final Color? iconColor;
  final Color? conBackColor;
  final Function() onbtnTap;
  final BuildContext scaffoldContext;

  const MenuWidget8({
    Key? key,
    @required this.iconImg,
    @required this.iconColor,
    this.conBackColor,
    required this.onbtnTap,
    required this.scaffoldContext,
  }) : super(key: key);

  @override
  State<MenuWidget8> createState() => _MenuWidget8State();
}

class _MenuWidget8State extends State<MenuWidget8> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onbtnTap();
      },
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: widget.conBackColor,
          border: Border.all(
            color: Colors.grey[200]!,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Icon(
          widget.iconImg,
          color: widget.iconColor,
        ),
      ),
    );
  }
}
