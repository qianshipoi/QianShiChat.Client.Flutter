import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_chat/locale/globalization.dart';
import 'package:qianshi_chat/models/group.dart';
import 'package:qianshi_chat/providers/group_provider.dart';

class ApplyGroupPage extends StatefulWidget {
  const ApplyGroupPage({super.key});

  @override
  State<ApplyGroupPage> createState() => _ApplyGroupPageState();
}

class _ApplyGroupPageState extends State<ApplyGroupPage> {
  final Group _group = Get.arguments;
  final TextEditingController _remarkController = TextEditingController();
  final GroupProvider _groupProvider = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Globalization.applyJoinGroupPageTitle.tr),
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(_group.avatar),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Column(
                  children: [
                    Text(_group.name),
                    Text("GID:${_group.id}"),
                  ],
                )
              ],
            ),
            Text(Globalization.remark.tr),
            TextField(
              controller: _remarkController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: Globalization.remark.tr,
              ),
            ),
            Row(
              children: [
                ElevatedButton(
                    onPressed: () async {
                      var response = await _groupProvider.join(
                          _group.id, _remarkController.text);
                      if (response.hasError) {
                        Get.snackbar(Globalization.error.tr,
                            Globalization.errorNetwork.tr);
                        return;
                      }
                      if (!response.body!.succeeded) {
                        Get.snackbar(
                            Globalization.error.tr, response.body!.errors);
                        return;
                      }
                      Get.snackbar(Globalization.success.tr,
                          Globalization.applySuccess.tr);
                      Get.back();
                    },
                    child: Text(Globalization.actionApply.tr)),
                ElevatedButton(
                  onPressed: Get.back,
                  child: Text(Globalization.actionCancel.tr),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
