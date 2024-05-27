

import 'package:flutter/material.dart';

import 'package:trys_1/src/status_request.dart';

class HandlingDataView extends StatelessWidget {
  final StatusRequest statusRequest;
  final Widget widget;
  const HandlingDataView({super.key, required this.statusRequest, required this.widget});

  @override
  Widget build(BuildContext context) {
    return statusRequest == StatusRequest.loading?
    const Center(child: Text('pending')) :
    statusRequest == StatusRequest.offlinefailure?
    const Center(child: Text("offline failure"),) :
    statusRequest == StatusRequest.serverfailure?
    const Center(child: Text("server failure"),) :
    statusRequest == StatusRequest.failure?
    const Center(child: Text("No Data"),) : widget;

  }
}
class HandlingDataRequst extends StatelessWidget {
  final StatusRequest statusRequest;
  final Widget widget;
  const HandlingDataRequst({super.key, required this.statusRequest, required this.widget});

  @override
  Widget build(BuildContext context) {
    return statusRequest == StatusRequest.loading?
    const Center(child: Text('pending'),) :
    statusRequest == StatusRequest.offlinefailure?
    const Center(child: Text("offline failure"),) :
    statusRequest == StatusRequest.serverfailure?
    const Center(child: Text("server failure"),) : widget;

  }
}