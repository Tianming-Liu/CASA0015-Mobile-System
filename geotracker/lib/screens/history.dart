import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:geotracker/provider/user_records.dart';
import 'package:geotracker/widgets/geotag_list/geotag_list.dart';
import 'package:geotracker/style/custom_text_style.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRecords = ref.watch(userRecordProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Places Records', style: CustomTextStyle.mediumBoldGreyText),
      ),
      body: GeoTagList(geoTags: userRecords),
    );
  }
}
