import 'package:get/get.dart';
import 'package:qianshi_chat/models/enums/message_send_type.dart';
import 'package:qianshi_chat/models/message.dart';
import 'package:qianshi_chat/models/room.dart';
import 'package:qianshi_chat/stores/chat_hub_controller.dart';
import 'package:qianshi_chat/stores/groups_controller.dart';
import 'package:qianshi_chat/stores/users_controller.dart';

import 'current_user_controller.dart';

class RoomsController extends GetxController {
  final chatController = Get.find<ChatHubController>();
  final currentUserController = Get.find<CurrentUserController>();
  final usersController = Get.find<UsersController>();
  final rooms = <Room>[].obs;

  @override
  void onInit() {
    super.onInit();

    ever(chatController.isConnection, (isConnection) {
      if (isConnection) {
        _loadRooms();
      } else {
        rooms.clear();
      }
    });

    chatController.addPrivateChatListener((Message message) {
      var room =
          rooms.firstWhereOrNull((element) => element.id == message.roomId);
      if (room.isBlank ?? true) {
        _addNewRoom(message);
      } else {
        rooms.remove(room);
        room!.unreadCount++;
        rooms.insert(0, room);
      }
    });
  }

  Future<void> _addNewRoom(Message message) async {
    var room = await chatController.getRoom(message.toId, message.sendType);
    if (room == null) return;
    room.fromUser = currentUserController.current.value;
    rooms.insert(0, room);
  }

  Future<void> _loadRooms() async {
    final rooms = await chatController.getRooms();
    if (rooms == null) return;
    var groupsController = Get.find<GroupsController>();

    for (var room in rooms) {
      if (room.type == MessageSendType.personal) {
        var user = await usersController.getUserById(room.toId);
        if (user == null) continue;
        room.toObject = user;
        room.avatar = user.avatar;
        room.name = user.nickName;
      } else if (room.type == MessageSendType.group) {
        var group = await groupsController.getGroupById(room.toId);
        if (group == null) continue;
        room.toObject = group;
        room.avatar = group.avatar;
        room.name = group.name;
      }
    }
    this.rooms.value = rooms;
  }

  Future<Room?> createRoom(int toId, MessageSendType type) async {
    // check room exists
    var room = rooms.firstWhereOrNull(
        (element) => element.toId == toId && element.type == type);
    if (room != null) {
      rooms.remove(room);
      rooms.insert(0, room);
      return room;
    }

    room = await chatController.getRoom(toId, type);
    if (room == null) return null;
    room.fromUser = currentUserController.current.value;
    rooms.insert(0, room);
    return room;
  }
}
