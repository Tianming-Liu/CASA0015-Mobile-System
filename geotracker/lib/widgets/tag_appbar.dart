import 'package:flutter/material.dart';
import 'package:geotracker/style/custom_text_style.dart';

final tagAppBar = AppBar(
  title: Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Image.asset(
        'assets/images/logo.png',
        height: 20,
        width: 20,
      ),
      Text(
        ' Go Track',
        style: CustomTextStyle.boldTitle,
      ),
    ],
  ),
  actions: [
    Builder(
      builder: (context) => IconButton(
        onPressed: () {
          Scaffold.of(context).openEndDrawer();
        },
        icon: const Icon(Icons.menu),
      ),
    ),
  ],
);
