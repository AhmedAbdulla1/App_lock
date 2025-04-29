import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String? heading, bodyText, button1Text, button2Text;
  final Widget? headingWidget;
  final TextAlign? bodyTextAlign;
  final double? dialogHeight, okButton;
  final Color? headingColor,
      headingTextColor,
      bodyColor,
      bodyTextColor,
      button1Color,
      button1TextColor,
      button2Color,
      button2TextColor;

  const ConfirmationDialog({
    Key? key,
    required this.heading,
    required this.bodyText,
    this.headingColor,
    this.headingTextColor,
    this.bodyColor,
    this.bodyTextColor,
    this.button1Color,
    this.button1TextColor,
    this.button2Color,
    this.button2TextColor,
    this.dialogHeight,
    this.okButton,
    this.headingWidget,
    this.bodyTextAlign,
    this.button1Text,
    this.button2Text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, false);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.5),
        body: Center(
          child: SafeArea(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Container(
                height: dialogHeight ?? size.height * 0.28,
                width: size.width * 0.8,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    headingWidget ??
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            heading ?? "",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: headingTextColor ??
                                      Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Text(
                        bodyText ?? "",
                        textAlign: bodyTextAlign ?? TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: bodyTextColor ??
                                  Theme.of(context).colorScheme.onSurface,
                            ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _dialogButton(
                          context,
                          text: okButton == null ? button1Text ?? "No" : "OK",
                          color: button1Color ?? Colors.transparent,
                          textColor: button1TextColor ??
                              Theme.of(context).colorScheme.primary,
                          borderColor: Theme.of(context).colorScheme.primary,
                          onTap: () {
                            Navigator.pop(
                                context, okButton != null ? true : false);
                          },
                        ),
                        if (okButton == null)
                          _dialogButton(
                            context,
                            text: button2Text ?? "Yes",
                            color: button2Color ??
                                Theme.of(context).colorScheme.primary,
                            textColor: button2TextColor ??
                                Theme.of(context).colorScheme.onPrimary,
                            borderColor: Theme.of(context).colorScheme.primary,
                            onTap: () {
                              Navigator.pop(context, true);
                            },
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _dialogButton(
    BuildContext context, {
    required String text,
    required Color color,
    required Color textColor,
    required Color borderColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            text,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ),
    );
  }
}
