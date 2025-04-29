import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

enum GetImageType { camera, gallery }

class ServiceController {
  SharedPreferences? prefs;
  ServiceController({this.prefs});


  Future<DateTime> selectDate(
      context, DateTime? startData, DateTime? endDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      initialDate: startData ?? DateTime.now().add(const Duration(minutes: 1)),
      lastDate: endDate ??
          DateTime.now().add(
            const Duration(days: 60),
          ),
    );
    return pickedDate!;
  }

  Future<String> selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dial,
    );
    // ignore: use_build_context_synchronously
    return timeOfDay!.format(context);
  }

  Future multipartReq(File? trImage) async {
    var postUri = Uri.parse("");

    http.MultipartRequest request = http.MultipartRequest("POST", postUri);

    http.MultipartFile multipartFile =
        await http.MultipartFile.fromPath('image', trImage!.path);

    request.fields['user_id'] = '';

    request.files.add(multipartFile);

    http.StreamedResponse response = await request.send();

    log("${response.statusCode}", name: "STATUSCODE");
    response.stream.bytesToString().then((value) {
      log(value, name: "multipartReq");
    });
  }
}
