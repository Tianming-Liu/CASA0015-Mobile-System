import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:geotracker/provider/user_records.dart';
import 'package:geotracker/widgets/geotag_list/geotag_list.dart';
import 'package:geotracker/style/custom_text_style.dart';

class HistoryPage extends ConsumerStatefulWidget {
  const HistoryPage({super.key});

  @override
  ConsumerState<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends ConsumerState<HistoryPage> {
  late Future<void> _recordsFuture;

  @override
  void initState() {
    super.initState();
    _recordsFuture = ref.read(userRecordProvider.notifier).loadRecords();
  }

  void syncRecords() {
    ref.read(userRecordProvider.notifier).syncDataFromCloud();
    // Optionally reload local data after sync
    _recordsFuture = ref.read(userRecordProvider.notifier).loadRecords();
    setState(() {}); // Trigger a rebuild if necessary
  }

  @override
  Widget build(BuildContext context) {
    final userRecords = ref.watch(userRecordProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Places Records',
            style: CustomTextStyle.mediumBoldGreyText),
        actions: <Widget>[
          TextButton(
            onPressed: syncRecords,

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Sync From Cloud',
                  style: CustomTextStyle.smallBoldGreyText,
                ),
                const SizedBox(width: 8),
                const Icon(Icons.sync),
              ],
            ),
          )
        ],
      ),
      body: FutureBuilder(
        future: _recordsFuture,
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : GeoTagList(geoTags: userRecords),
      ),
    );
  }
}
