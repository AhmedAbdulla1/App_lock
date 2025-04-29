import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';

import '../executables/controllers/apps_controller.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  void dispose() {
    Get.find<AppsController>().searchApkText.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(),
        leading: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        title: const Text(
          "Search App",
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 4,
            ),
            child: GetBuilder<AppsController>(builder: (state) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Theme.of(context).primaryColorDark,
                  ),
                ),
                child: TextField(
                  controller: state.searchApkText,
                  onChanged: (value) {
                    state.appSearch();
                  },
                  decoration: const InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    isCollapsed: true,
                    hintText: 'Search apps',
                    prefixIcon: const Padding(
                      padding: EdgeInsets.all(12),
                      child: Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                    ),
                    border: InputBorder.none,
                  ),
                ),
              );
            }),
          ),
          Expanded(
            child: GetBuilder<AppsController>(
                id: Get.find<AppsController>().appSearchUpdate,
                builder: (state) {
                  return ListView.builder(
                    itemCount: state.searchedApps.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Theme.of(context).primaryColorDark,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
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
                                child: Image.memory(
                                  state.getAppIcon(
                                    state.searchedApps[index].application!
                                        .appName,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      state.searchedApps[index].application!
                                          .appName,
                                    ),
                                    Text(
                                      state.searchedApps[index].application!
                                          .versionName,
                                    ),
                                  ],
                                ),
                              ),
                              GetBuilder<AppsController>(
                                builder: (appLockCtrl) {
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
                                      inactiveColor:
                                          Theme.of(context).primaryColorDark,
                                      toggleSize: 20.0,
                                      value: state.selectLockList.contains(state
                                          .searchedApps[index]
                                          .application!
                                          .appName),
                                      borderRadius: 30.0,
                                      padding: 2.0,
                                      showOnOff: false,
                                      onToggle: (val) {
                                        if ("${Get.find<AppsController>().getPasscode()}" !=
                                            "") {
                                          state
                                              .addRemoveFromLockedAppsFromSearch(
                                            state.searchedApps[index]
                                                .application!,
                                          );
                                        } else {
                                          // Fluttertoast.showToast(
                                          //     msg: "Set password");
                                        }
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
                  );
                }),
          )
        ],
      ),
    );
  }
}
