import 'package:app_lock_flutter/executables/controllers/method_channel_controller.dart';
import 'package:app_lock_flutter/executables/controllers/password_controller.dart';
import 'package:app_lock_flutter/screens/search.dart';
import 'package:app_lock_flutter/screens/set_passcode.dart';
import 'package:app_lock_flutter/widgets/confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';

import '../services/constant.dart';
import '../widgets/pass_confirm_dialog.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({
    super.key, this.bottomWidget,
  });
final PreferredSizeWidget ? bottomWidget;
  @override
  Widget build(BuildContext context) {
    return AppBar(bottom: bottomWidget,
      leading: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.grey,
            ),
          ),
          child: IconButton(
            padding: const EdgeInsets.all(0.0),
            onPressed: () async {
              await showGeneralDialog(
                barrierColor: Colors.black.withOpacity(0.8),
                context: context,
                barrierDismissible: false,
                barrierLabel:
                    MaterialLocalizations.of(context).modalBarrierDismissLabel,
                transitionDuration: const Duration(milliseconds: 200),
                pageBuilder: (context, animation1, animation2) {
                  return const ConfirmationDialog(
                    headingColor: Colors.amber,
                    heading: "Stop",
                    bodyText: "Are you sure you want to stop the app?",
                  );
                },
              ).then((value) {
                if (value as bool) {
                  Get.find<MethodChannelController>().stopForeground();
                }
              });
            },
            icon: const Icon(
              Icons.disabled_by_default_rounded,
              color: Colors.red,
            ),
          ),
        ),
      ),
      centerTitle: true,
      title: const Text(
        "AppLock",
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: CircleAvatar(
            child: IconButton(
              onPressed: () {
                if (Get.find<PasswordController>()
                    .prefs
                    .containsKey(AppConstants.setPassCode)) {
                  showComfirmPasswordDialog(context).then((value) {
                    if (value as bool) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SetPasscode(),
                        ),
                      );
                    }
                  });
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SetPasscode(),
                    ),
                  );
                }
              },
              icon: Icon(
                Icons.key,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: CircleAvatar(
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const SearchPage();
                    },
                  ),
                );
              },
              icon: const Icon(
                Icons.search,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50.0);
}
