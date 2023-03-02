import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

Future<dynamic> animatedPopUp({
  required BuildContext context,
  required String? title,
  required String? content,
  required void Function()? onNegativeClick,
  required void Function()? onPositiveClick,
  required String? negativeText,
  required String? positiveText,
}) {
  return showAnimatedDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return ClassicGeneralDialogWidget(
        titleText: title,
        contentText: title,
        onPositiveClick: onPositiveClick,
        negativeTextStyle:
            const TextStyle(color: Color.fromARGB(255, 98, 71, 230)),
        onNegativeClick: onNegativeClick,
      );
    },
    animationType: DialogTransitionType.size,
    curve: Curves.fastOutSlowIn,
    duration: const Duration(seconds: 1),
  );
}
