import 'package:flutter/material.dart';

void loseFocus() {
  FocusManager.instance.primaryFocus?.unfocus();
}
