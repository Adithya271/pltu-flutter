import 'package:flutter/material.dart';

class DashboardUserShowType extends StatelessWidget {
  const DashboardUserShowType({Key? key, required this.typeId})
      : super(key: key);

  final String typeId;

  @override
  Widget build(BuildContext context) {
    // Replace the Container with the actual content of the DashboardUserShowType screen
    return Container(
      child: Text('Type ID: $typeId'),
    );
  }
}
