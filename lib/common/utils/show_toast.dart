import 'package:flutter_easyloading/flutter_easyloading.dart';

void showToast(String text) {
  EasyLoading.showToast(
    text,
    duration: const Duration(seconds: 2),
    dismissOnTap: false,
    toastPosition: EasyLoadingToastPosition.bottom,
  );
}
