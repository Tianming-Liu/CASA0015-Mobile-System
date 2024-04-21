import 'package:flutter/material.dart';
// import firebase auth package for logout functionality
import 'package:firebase_auth/firebase_auth.dart';

import 'package:geotracker/style/custom_text_style.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geotracker/provider/user_records.dart';
import 'package:geotracker/provider/user_info.dart';
import 'package:geotracker/provider/map_style.dart';

class SideDrawer extends ConsumerStatefulWidget {
  final NetworkImage? userProfileImage;
  final String? userName;
  const SideDrawer({
    super.key,
    required this.userName,
    required this.userProfileImage,
  });

  @override
  ConsumerState<SideDrawer> createState() => _SideDrawerState();
}

class _SideDrawerState extends ConsumerState<SideDrawer> {
  String currentMapStyle = 'light-grey';
  @override
  Widget build(BuildContext context) {
    final userInfo = ref.watch(userInfoProvider);
    final userRecord = ref.watch(userRecordProvider);

    return ListView(
      children: [
        const SizedBox(
          height: 20,
        ),
        // Use a CircleAvatar widget to display the user's profile image
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          foregroundImage:
              userInfo != null ? NetworkImage(userInfo.userProfileImage) : null,
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(userInfo != null ? userInfo.userName : widget.userName ?? '',
                style: CustomTextStyle.smallBoldBlackText),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(
              width: 10,
            ),
            Text('History:', style: CustomTextStyle.smallBoldGreyText),
            const SizedBox(
              width: 30,
            ),
            Text('Added  ',
                style: CustomTextStyle.smallBoldBlackText,),
            Text(userRecord.length.toString(),
                style: CustomTextStyle.boldTitle),
            Text('  records',
                style: CustomTextStyle.smallBoldBlackText),
          ],
        ),
        const SizedBox(
          height: 10,
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
                value: currentMapStyle,
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
                  if (value != null) {
                    setState(() {
                      currentMapStyle = value;
                      ref.read(mapStyleProvider.notifier).setMapStyle(value);
                    });
                  }
                },
                style: CustomTextStyle.smallBoldBlackText,
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                padding: const EdgeInsets.all(5),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
          child: TextButton.icon(
            icon: const Icon(Icons.delete, color: Colors.white,size: 20,),
            onPressed: () {
              ref.read(userRecordProvider.notifier).clearUserRecords();
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Local data cleared')));
            },
            style: TextButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 81, 7, 120)),
            label: Text('Clear Local Data',
                style: CustomTextStyle.smallBoldWhiteText),
          ),
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
                FirebaseAuth.instance.signOut().then((_) {
                  ref.read(userRecordProvider.notifier).clearTempRecords();
                  ref.read(userInfoProvider.notifier).clearUser();
                });
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
      ],
    );
  }
}
