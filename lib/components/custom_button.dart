import 'package:calculator_mobile/constants/app_constants.dart';
import 'package:calculator_mobile/constants/strings.dart';
import 'package:calculator_mobile/utils/notifiers.dart';
import 'package:calculator_mobile/utils/operations_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  CustomButton({
    super.key,
    this.height,
    this.width,
    this.borderRadius,
    this.shadowOffset,
    this.borderWidth,
    this.child,
    this.buttonType,
    this.buttonValue,
    this.color,
  });

  final double? height;
  final double? width;
  final double? borderRadius;
  final double? borderWidth;
  final Offset? shadowOffset;
  final Widget? child;
  final KeyTypes? buttonType;
  final String? buttonValue;
  final Color? color;

  final List operators = ['+', '-', 'x', '/'];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: Make the code less messier :P

        String screenValue = Notifiers.screenDisplayNotifier.value;

        switch (buttonType) {
          case KeyTypes.action:
            if (buttonValue == 'AC') {
              Notifiers.screenDisplayNotifier.value = '';
              Notifiers.historyDisplayNotifier.value = [];
            }
            break;
          case KeyTypes.operator:
            String displayValue = Notifiers.screenDisplayNotifier.value;
            Notifiers.screenDisplayNotifier.value =
                buttonValue == '=' ? '' : buttonValue;

            List<String> result = Notifiers.historyDisplayNotifier.value;
            result.add(displayValue);
            Notifiers.historyDisplayNotifier.value = result;

            if (buttonValue == '=') {
              Notifiers.screenDisplayNotifier.value = OperationUtil.total(
                Notifiers.historyDisplayNotifier.value,
              );
              Notifiers.historyDisplayNotifier.value = [];
            } else {
              List<String> result = [];
              for (var element in Notifiers.historyDisplayNotifier.value) {
                result.add(element);
              }
              result.add(buttonValue!);
              Notifiers.historyDisplayNotifier.value = result;
            }
            break;
          case KeyTypes.digit:
            if (operators.contains(Notifiers.screenDisplayNotifier.value)) {
              screenValue = '';
            }
            if (buttonValue == '.') {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(seconds: 2),
                  content: Row(
                    children: [
                      Expanded(
                        child: Text(
                          Strings.decimalCtaMessage,
                          style: GoogleFonts.roboto(
                            fontSize: 17,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }

            Notifiers.screenDisplayNotifier.value =
                screenValue + (buttonValue ?? '');
            break;
          default:
        }
      },
      child: Container(
        height: height ?? 80,
        width: width ?? 80,
        decoration: BoxDecoration(
          color: color ?? Colors.white,
          borderRadius: BorderRadius.circular(borderRadius ?? 10.0),
          border: Border.all(
            color: Colors.black,
            width: borderWidth ?? 4,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              offset: shadowOffset ?? const Offset(4, 4),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
