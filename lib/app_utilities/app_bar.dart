import 'package:flutter/material.dart';
import 'package:get/get.dart';

AppBar appBar(String pageName) => AppBar(
  leading: InkWell(
      onTap: () => Get.back(),
      child: const Icon(
        Icons.arrow_back_ios_rounded,
        color: Colors.white,
        size: 20,
      )),
      backgroundColor: Colors.blue,
        foregroundColor: Colors.white,   
  elevation: 5,
  title: Text(pageName,style:const TextStyle(color: Colors.white),),

);