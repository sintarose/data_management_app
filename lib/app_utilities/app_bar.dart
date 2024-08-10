import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

AppBar appBar() => AppBar(
  leading: InkWell(
      onTap: () => Get.back(),
      child: const Icon(
        Icons.arrow_back_ios_rounded,
        color: Colors.white,
        size: 20,
      )),
  backgroundColor: const Color.fromARGB(255, 3, 38, 90),
  elevation: 5,
  title:const Text("News Today",style: TextStyle(color: Colors.white),),

);