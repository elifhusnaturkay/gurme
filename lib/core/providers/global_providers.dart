import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rect_getter/rect_getter.dart';

var rectGetter = RectGetter.createGlobalKey();
final locationProvider = StateProvider<GeoPoint?>((ref) => null);
