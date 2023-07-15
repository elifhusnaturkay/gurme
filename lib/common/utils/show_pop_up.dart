import 'package:flutter/material.dart';

Future<dynamic> showPopUpScreen({
  required BuildContext context,
  required WidgetBuilder builder,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).canvasColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.elliptical(20, 17),
        topRight: Radius.elliptical(20, 17),
      ),
    ),
    enableDrag: true,
    useSafeArea: true,
    builder: builder,
  );
}
