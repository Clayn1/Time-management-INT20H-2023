import 'package:flutter/material.dart';

void showNoInternetPopUp(BuildContext context, Function onTap) {
  showDialog(
    barrierDismissible: false,
    routeSettings: const RouteSettings(name: "noInternetPopUp"),
    context: context,
    builder: (_) => Container(),
  );
}
