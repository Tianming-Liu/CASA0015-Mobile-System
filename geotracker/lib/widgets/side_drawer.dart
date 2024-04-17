import 'package:flutter/material.dart';
// import firebase auth package for logout functionality
import 'package:firebase_auth/firebase_auth.dart';

import 'package:geotracker/style/custom_text_style.dart';

class SideDrawer extends StatefulWidget {
  final NetworkImage? userProfileImage;
  final String userName;
  final Function(String) onChangeStyle;
  const SideDrawer(
      {super.key,
      required this.userName,
      required this.userProfileImage,
      required this.onChangeStyle});

  @override
  State<SideDrawer> createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(
          height: 20,
        ),
        // Use a CircleAvatar widget to display the user's profile image
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          foregroundImage: widget.userProfileImage,
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('@${widget.userName}',
                style: CustomTextStyle.smallBoldBlackText),
          ],
        ),
        const SizedBox(
          height: 50,
        ),
        Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            Text('Map Style', style: CustomTextStyle.smallBoldGreyText),
            const SizedBox(
              width: 10,
            ),
            Container(
              height: 50,
              width: 120,
              padding:
                  const EdgeInsets.only(left: 5, right: 5), // 调整内边距来对齐文本和图标
              child:
                  // Add a dropdown button to change the map style
                  DropdownButton<String>(
                isExpanded: true,
                value: 'light-grey',
                items: const [
                  DropdownMenuItem(
                    value: 'light-grey',
                    child: Text('Light Grey'),
                  ),
                  DropdownMenuItem(
                    value: 'light-green',
                    child: Text('Light Green'),
                  ),
                  DropdownMenuItem(
                    value: 'dark-blue',
                    child: Text('Dark Blue'),
                  ),
                ],
                onChanged: (String? value) {
                  widget.onChangeStyle(value!);
                },
                style: CustomTextStyle.smallBoldBlackText,
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                padding: const EdgeInsets.all(5),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 300,
        ),
        Container(
          margin: const EdgeInsets.only(
            top: 10,
            left: 20,
            right: 20,
          ),
          child: Image.asset('assets/images/logo.png', height: 60),
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Logout', style: CustomTextStyle.smallBoldGreyText),
            IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
      ],
    );
  }
}
