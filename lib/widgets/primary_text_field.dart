import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PrimaryTextField extends StatelessWidget {
  /// Creates a PrimaryTextField.
  ///
  ///
  final EdgeInsetsGeometry? margin;
  final TextEditingController? controller;
  final String? label;
  final String? hintText;
  final TextCapitalization textCapitalization;
  final TextInputType? keyboardType;
  final TextInputAction inputAction;
  final TextAlign textAlignHorizontal;
  final ValueChanged<String>? onSubmitted;
  final bool enable;
  final int maxLines;
  final FocusNode? focusNode;
  final bool obscureText;
  final bool mandatory;
  final bool autoFocus;
  final bool showInfoIcon;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final Icon? infoIcon;
  final String infoIconMessage;
  final EdgeInsets? contentPadding;
  final List<TextInputFormatter> textInputFormatter;
  final VoidCallback? onTap;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const PrimaryTextField({
    Key? key,
    this.margin,
    this.controller,
    this.label,
    this.hintText,
    this.textCapitalization = TextCapitalization.sentences,
    this.keyboardType,
    this.inputAction = TextInputAction.done,
    this.textAlignHorizontal = TextAlign.start,
    this.onSubmitted,
    this.enable = true,
    this.maxLines = 1,
    this.focusNode,
    this.obscureText = false,
    this.mandatory = false,
    this.autoFocus = false,
    this.showInfoIcon = false,
    this.onChanged,
    this.maxLength,
    this.infoIcon,
    this.infoIconMessage = 'info',
    this.contentPadding = const EdgeInsets.only(
      left: 16.0,
      // top: 8.0,
      // bottom: 16.0,
    ),
    this.textInputFormatter = const [],
    this.onTap,
    this.prefixIcon,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          label != null
              ? Container(
                  margin: EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            text: '$label',
                            style: appTheme.textTheme.bodyMedium?.copyWith(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w600,
                            ),
                            children: [
                              if (mandatory)
                                TextSpan(
                                  text: '*',
                                  style:
                                      appTheme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.red,
                                    fontSize: 16.0,
                                  ),
                                ),
                              if (showInfoIcon)
                                WidgetSpan(
                                  child: InkWell(
                                    onTap: () => showInfo(
                                      context,
                                      infoIconMessage,
                                    ),
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      child: infoIcon ??
                                          Icon(
                                            Icons.info,
                                            color: appTheme.iconTheme.color,
                                            size: 12.0,
                                          ),
                                    ),
                                  ),
                                )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: TextField(
              onTap: onTap,
              obscureText: obscureText,
              textAlignVertical: TextAlignVertical.center,
              enabled: enable,
              style: appTheme.textTheme.bodyMedium?.copyWith(
                color: enable
                    ? appTheme.iconTheme.color
                    : appTheme.colorScheme.primaryContainer,
              ),
              onChanged: onChanged,
              controller: controller,
              maxLength: maxLength,
              textCapitalization: textCapitalization,
              textAlign: textAlignHorizontal,
              keyboardType: keyboardType,
              textInputAction: inputAction,
              onSubmitted: onSubmitted,
              autofocus: autoFocus,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: appTheme.textTheme.bodySmall,
                prefixIcon: prefixIcon,
                suffixIcon: suffixIcon,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                suffixIconConstraints:
                    BoxConstraints(maxWidth: 80, maxHeight: 50),
              ),
              maxLines: maxLines,
              focusNode: focusNode,
              inputFormatters: textInputFormatter,
            ),
          ),
        ],
      ),
    );
  }
}

///
///
///
void showInfo(
  BuildContext context,
  String message,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Color(0xFF000229),
        content: Text(
          message,
          style: TextStyle(
            color: Color(0xFFFFFFFF),
          ),
          textAlign: TextAlign.center,
        ),
      );
    },
  );
}
