import 'package:get/get.dart';
import 'package:qianshi_chat/locale/globalization.dart';

class CommonUtil {
  static String formatFileSize(int size) {
    if (size < 1024) {
      return '${size}B';
    } else if (size < 1024 * 1024) {
      return '${(size / 1024).toStringAsFixed(2)}KB';
    } else if (size < 1024 * 1024 * 1024) {
      return '${(size / (1024 * 1024)).toStringAsFixed(2)}MB';
    } else {
      return '${(size / (1024 * 1024 * 1024)).toStringAsFixed(2)}GB';
    }
  }

  static String getFileSuffix(String fileName) {
    return fileName.substring(fileName.lastIndexOf('.') + 1);
  }

  static String formatMessageContent(dynamic content) {
    if (content is String) {
      return content;
    } else if (content is Map) {
      return '[${content['type']}]';
    } else {
      return '';
    }
  }

  static String timestampToTime(int timestamp) {
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var now = DateTime.now();
    var diff = now.difference(date);
    if (diff.inDays > 0) {
      return '${date.month}-${date.day}';
    } else if (diff.inHours > 0) {
      return '${diff.inHours} ${Globalization.hoursAgo.tr}';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes} ${Globalization.minutesAgo.tr}';
    } else {
      return Globalization.justNow.tr;
    }
  }
}
