import 'package:uuid/data.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class GeoTag {
  GeoTag({required this.type, required this.time, required this.info}) : id = uuid.v4();

  final String id;
  final String type;
  final DateTime time;
  final String info; 
}
