import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'loading_controller.dart';

class LoadingScreen extends GetView<LoadingController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('변환 중...')),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
} 