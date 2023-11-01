import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_chat/locale/globalization.dart';
import 'package:qianshi_chat/models/userinfo.dart';
import 'package:qianshi_chat/providers/group_provider.dart';
import 'package:qianshi_chat/widget/select_friends.dart';

class NewGroupPage extends StatefulWidget {
  const NewGroupPage({super.key});

  @override
  State<NewGroupPage> createState() => _NewGroupPageState();
}

class _NewGroupPageState extends State<NewGroupPage> {
  final GlobalKey _formKey = GlobalKey<FormState>();
  late String _groupName;
  late int _groupAvatarId;
  final List<UserInfo> _groupMembers = [];
  final GroupProvider _groupProvider = Get.find<GroupProvider>();
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Globalization.newGroup.tr),
        actions: [
          _isSaving
              ? const CircularProgressIndicator()
              : IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () async {
                    var form = _formKey.currentState as FormState;
                    if (!form.validate()) return;
                    setState(() {
                      _isSaving = true;
                    });
                    try {
                      var response = await _groupProvider.create(
                          _groupMembers.map((e) => e.id).toList(),
                          name: _groupName,
                          avatarId: _groupAvatarId);
                      var body = response.body!;
                      if (!body.succeeded) {
                        Get.snackbar(
                            Globalization.createFailed.tr, body.errors);
                        return;
                      }
                      Get.snackbar(Globalization.success.tr,
                          Globalization.createSuccess.tr);
                      Get.back();
                    } catch (e) {
                      Get.snackbar(Globalization.createFailed.tr, e.toString());
                    } finally {
                      setState(() {
                        _isSaving = false;
                      });
                    }
                  },
                ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: ListView(
              children: [
                Text(Globalization.groupName.tr),
                _buildGroupNameTextField(),
                Text(Globalization.groupAvatar.tr),
                _buildGroupAvatarUpload(),
                const Divider(),
                Text(
                    "${Globalization.groupMembers.tr}(${_groupMembers.length})"),
                _buildGroupMemberList(),
              ],
            )),
      ),
    );
  }

  _buildGroupNameTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "群聊名称",
        hintText: "请输入群聊名称",
      ),
      validator: (v) {
        return v!.trim().isNotEmpty ? null : "群聊名称不能为空";
      },
      onSaved: (newValue) => _groupName = newValue!,
    );
  }

  _buildGroupAvatarUpload() {
    return Container(
      height: 200,
      color: Colors.grey,
    );
  }

  _buildGroupMemberList() {
    return GridView.builder(
      itemCount: _groupMembers.length + 1,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 64),
      itemBuilder: (context, index) {
        if (index == 0) {
          return IconButton(
            color: Colors.grey,
            onPressed: () async {
              var selectFriends = await Get.to(() => SelectFriends(
                    selectedFriends: _groupMembers,
                  ));
              if (selectFriends != null) {
                setState(() {
                  _groupMembers.addAll(selectFriends);
                });
              }
            },
            icon: const Icon(Icons.add),
          );
        }
        index = index - 1;
        return Stack(children: [
          Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  _groupMembers[index].avatar,
                  fit: BoxFit.cover,
                ),
              ),
              Text(_groupMembers[index].alias ?? _groupMembers[index].nickName),
            ],
          ),
          Positioned(
            right: 0,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _groupMembers.removeAt(index);
                });
              },
            ),
          ),
        ]);
      },
    );
  }
}
