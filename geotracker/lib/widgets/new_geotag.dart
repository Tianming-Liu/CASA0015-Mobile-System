import 'package:flutter/material.dart';
import 'package:geotracker/widgets/create_geodata/create_tag.dart';

class NewGeoTagBottom extends StatelessWidget {
  final BuildContext mainContext;

  NewGeoTagBottom({super.key, required this.mainContext});

  final ButtonStyle buttonStyleforNewTag = ButtonStyle(
    fixedSize: MaterialStateProperty.all<Size>(const Size(200, 40)),
    backgroundColor: MaterialStateProperty.all<Color>(
      const Color.fromRGBO(80, 7, 120, 1),
    ), // Background Color
    padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(5)), //
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Round Radius
      ),
    ),
  );

  final TextStyle textStyleforNewTag = const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w700,
    fontSize: 14,
  );

  void _showCreateTagBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      // isScrollControlled: true,
      builder: (BuildContext context) {
        return const CreateTagPage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(75, 32, 75, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton.icon(
            icon: const Icon(Icons.pin_drop,color: Colors.white,size: 20,),
            label: Text('Tag Current Location',style: textStyleforNewTag,),
            onPressed: () {
              Navigator.pop(context);
              _showCreateTagBottomSheet(mainContext);
            },
            style: buttonStyleforNewTag,
          ),
          const SizedBox(
            height: 5,
          ),
          ElevatedButton(
            onPressed: () {},
            style: buttonStyleforNewTag,
            child: Text(
              'Tag Other Location',
              style: textStyleforNewTag,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          ElevatedButton(
            onPressed: () {},
            style: buttonStyleforNewTag,
            child: Text(
              'Track New Route',
              style: textStyleforNewTag,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
