import 'package:flutter/material.dart';

Size displaySize(BuildContext context) {
  return MediaQuery.of(context).size;
}

double displayHeightWithoutStatusBar(BuildContext context) {
  return displaySize(context).height - MediaQuery.of(context).padding.top;
}

double displayHeightWithStatusBar(BuildContext context) {
  return displaySize(context).height;
}

double displayWidth(BuildContext context) {
  return displaySize(context).width;
}