import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:qianshi_chat/locale/globalization.dart';
import 'package:qianshi_chat/main.dart';
import 'package:qianshi_chat/models/attachment.dart';
import 'package:qianshi_chat/models/userinfo.dart';
import 'package:qianshi_chat/providers/attachment_provider.dart';
import 'package:qianshi_chat/providers/group_provider.dart';
import 'package:qianshi_chat/widget/select_friends.dart';

class NewGroupPage extends StatefulWidget {
  const NewGroupPage({super.key});

  @override
  State<NewGroupPage> createState() => _NewGroupPageState();
}

class _NewGroupPageState extends State<NewGroupPage> {
  final GlobalKey _formKey = GlobalKey<FormState>();
  final AttachmentProvider _attachmentProvider = Get.find();
  String _groupName = "";
  Attachment? _groupAvatar;
  final List<UserInfo> _groupMembers = [];
  final GroupProvider _groupProvider = Get.find<GroupProvider>();
  bool _isSaving = false;
  bool _uploading = false;
  double _uploadProgress = 0;

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
                    if (!form.validate() || _groupAvatar == null) return;
                    setState(() {
                      _isSaving = true;
                    });
                    try {
                      var response = await _groupProvider.create(
                          _groupMembers.map((e) => e.id).toList(),
                          name: _groupName,
                          avatarId: _groupAvatar!.id);
                      var body = response.body!;
                      logger.i(body);
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
      body: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ConstrainedBox(
            constraints: const BoxConstraints.expand(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const SizedBox(height: 8),
                _buildGroupNameTextField(),
                const SizedBox(height: 8),
                Text(Globalization.groupAvatar.tr),
                const SizedBox(height: 8),
                _buildGroupAvatarUpload(),
                const SizedBox(height: 8),
                const Divider(),
                const SizedBox(height: 8),
                Text(
                    "${Globalization.groupMembers.tr}(${_groupMembers.length})"),
                _buildGroupMemberList(),
              ],
            ),
          )),
    );
  }

  Widget _buildGroupNameTextField() {
    return TextFormField(
      decoration: InputDecoration(
        isCollapsed: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        label: Text(Globalization.groupName.tr),
        prefixIcon: const Icon(Icons.group),
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            borderSide: BorderSide(width: 2)),
      ),
      validator: (v) {
        return v!.trim().isNotEmpty
            ? null
            : Globalization.groupNameCanNotBeEmpty.tr;
      },
      onSaved: (newValue) => _groupName = newValue!,
    );
  }

  Widget _buildGroupAvatarUpload() {
    return Stack(
      children: [
        Container(
          height: 200,
          width: 200,
          color: const Color.fromARGB(255, 206, 204, 204),
          child: _uploading
              ? LinearProgressIndicator(
                  value: _uploadProgress,
                )
              : IconButton(
                  padding: EdgeInsets.zero,
                  icon: _groupAvatar == null
                      ? const Icon(Icons.add_a_photo)
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.network(
                            _groupAvatar!.rawPath,
                            fit: BoxFit.cover,
                          ),
                        ),
                  onPressed: () async {
                    var fileResult = await FilePicker.platform
                        .pickFiles(type: FileType.image, allowMultiple: false);
                    if (fileResult == null || fileResult.count == 0) return;
                    var croppedPath =
                        await _cropImage(fileResult.files.first.path!);
                    setState(() {
                      _uploading = true;
                    });
                    try {
                      var response = await _attachmentProvider.upload(
                        croppedPath,
                        uploadProgress: (p0) {
                          setState(() {
                            _uploadProgress = p0;
                          });
                        },
                      );
                      if (response.isOk && response.body!.succeeded) {
                        setState(() {
                          _groupAvatar =
                              Attachment.fromMap(response.body!.data!);
                        });
                      }
                    } catch (e) {
                      Get.snackbar(Globalization.errorNetwork.tr, e.toString());
                    } finally {
                      setState(() {
                        _uploading = false;
                      });
                    }
                  },
                ),
        ),
      ],
    );
  }

  Future<String> _cropImage(String imagePath) async {
    var croppedFile = await ImageCropper.platform.cropImage(
      sourcePath: imagePath,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
    );
    return croppedFile == null ? imagePath : croppedFile.path;
  }

  Widget _buildGroupMemberList() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _groupMembers.length + 1,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 64, childAspectRatio: 0.78),
      itemBuilder: (context, index) {
        if (index == 0) {
          return IconButton(
            color: Colors.grey,
            onPressed: () async {
              var selectFriends = await Get.to(() => SelectFriends(
                    selectedFriends: _groupMembers,
                  ));
              if (selectFriends != null) {
                _groupMembers.clear();

                setState(() {
                  _groupMembers.addAll(selectFriends);
                });
              }
            },
            icon: const Icon(Icons.add),
          );
        }
        index = index - 1;
        return Stack(fit: StackFit.expand, children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(
                    _groupMembers[index].avatar,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Text(_groupMembers[index].alias ?? _groupMembers[index].nickName),
            ],
          ),
          Positioned(
            top: 0,
            right: 0,
            width: 20,
            height: 20,
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.delete),
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
