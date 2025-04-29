import 'dart:ui';

import 'package:app_lock_flutter/widgets/home_app_bar.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:lottie/lottie.dart';

import '../executables/controllers/apps_controller.dart';
import '../services/constant.dart';

class UnlockedAppScreen extends StatelessWidget {
  const UnlockedAppScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: const HomeAppBar(),
        body: Stack(
          children: [
            SizedBox(
              height: double.infinity,
              width: size.width,
              child: GetBuilder<AppsController>(
                builder: (appsController) {
                  if (appsController.unLockList.isEmpty) {
                    return Center(
                      child: Container(
                        color: Colors.transparent,
                        height: 300,
                        child: Column(
                          children: [
                            Lottie.asset(
                              "assets/jsonFiles/102600-pink-no-data.json",
                              width: 200,
                            ),
                            Text(
                              "Loading...",
                              style: MyFont().subtitle(
                                color: Theme.of(context).primaryColor,
                                fontweight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () async {
                      return await appsController.getAppsData();
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.only(top: 20),
                      itemCount: appsController.unLockList.length,
                      itemBuilder: (context, index) {
                        Application app = appsController.unLockList[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 14,
                                  ),
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    // color: Theme.of(context).primaryColorDark,
                                    borderRadius: BorderRadius.circular(10),
                                    // ignore: prefer_const_literals_to_create_immutables
                                  ),
                                  child: app is ApplicationWithIcon
                                      ? CircleAvatar(
                                          backgroundImage:
                                              MemoryImage(app.icon),
                                          backgroundColor: Theme.of(context)
                                              .primaryColorDark,
                                        )
                                      : CircleAvatar(
                                          backgroundColor: Theme.of(context)
                                              .primaryColorDark,
                                          child: Text(
                                            "Error",
                                            style: MyFont().subtitle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        app.appName,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                GetBuilder<AppsController>(
                                  id: Get.find<AppsController>()
                                      .addRemoveToUnlockUpdate,
                                  builder: (appsController) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      child: FlutterSwitch(
                                        width: 50.0,
                                        height: 25.0,
                                        valueFontSize: 25.0,
                                        toggleColor: Colors.white,
                                        activeColor:
                                            Theme.of(context).primaryColor,
                                        inactiveColor: Colors.grey,
                                        toggleSize: 20.0,
                                        value: appsController.selectLockList
                                            .contains(app.appName),
                                        borderRadius: 30.0,
                                        padding: 2.0,
                                        showOnOff: false,
                                        onToggle: (val) {
                                          appsController.addToLockedApps(
                                            app,
                                            context,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            GetBuilder<AppsController>(
                id: Get.find<AppsController>().addRemoveToUnlockUpdate,
                builder: (state) {
                  return state.addToAppsLoading
                      ? BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
                          child: const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                        )
                      : const SizedBox();
                }),
          ],
        ),
      ),
    );
  }
}
