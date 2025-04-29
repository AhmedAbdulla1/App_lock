import 'package:app_lock_flutter/executables/controllers/password_controller.dart';
import 'package:app_lock_flutter/services/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';

class SetPasscode extends StatefulWidget {
  const SetPasscode({Key? key}) : super(key: key);

  @override
  State<SetPasscode> createState() => _SetPasscodeState();
}

class _SetPasscodeState extends State<SetPasscode> {
  @override
  void initState() {
    super.initState();
    Get.find<PasswordController>().clearData();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        bottomNavigationBar: SizedBox(
          height: 60,
          width: size.width,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: colorScheme.primary),
              ),
              child: MaterialButton(
                color: colorScheme.primary,
                elevation: 0,
                onPressed: () {
                  Get.find<PasswordController>().savePasscode();
                },
                child: GetBuilder<PasswordController>(
                  builder: (state) {
                    return Text(
                      state.isConfirm ? "Confirm Passcode" : "Save Passcode",
                      style: MyFont().subtitle(color: colorScheme.onPrimary),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: colorScheme.onBackground),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            "Set Passcode",
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onBackground,
            ),
          ),
        ),
        body: SizedBox(
          height: size.height,
          width: size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                  child: Center(
                    child: Image.asset(
                      'assets/images/appLogo.png',
                      height: 100,
                      width: 100,
                    ),
                  ),
                ),
              ),
              GetBuilder<PasswordController>(builder: (state) {
                return Text(
                  state.isConfirm ? "Confirm Passcode" : "Set Passcode",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onBackground,
                  ),
                );
              }),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (i) {
                  return GetBuilder<PasswordController>(builder: (state) {
                    bool filled = state.passcode.length >= i + 1;
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 2),
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: colorScheme.primary),
                      ),
                      child: Center(
                        child: Text(
                          filled ? "•" : "",
                          style: MyFont().normaltext(
                            fontsize: 28,
                            color: filled
                                ? colorScheme.primary
                                : colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                      ),
                    );
                  });
                }),
              ),
              const SizedBox(height: 10),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                child: GetBuilder<PasswordController>(builder: (state) {
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 12,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 0.0,
                      mainAxisSpacing: 10.0,
                      childAspectRatio: 2,
                    ),
                    itemBuilder: (context, index) {
                      if (index == 9) return const SizedBox();

                      bool isDelete = index == 11;
                      int number = index == 10 ? 0 : index + 1;

                      return GestureDetector(
                        onTap: () {
                          state.setPasscode(index);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: colorScheme.primary),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(isDelete ? "<" : "$number",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: isDelete
                                      ? colorScheme.error
                                      : colorScheme.onBackground,
                                )),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
