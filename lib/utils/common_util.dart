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

  static String getFileName(String path) {
    var index = path.lastIndexOf('/');
    if (index == -1) return path;
    return path.substring(index + 1);
  }

  static String getContentType(String path) {
    var index = path.lastIndexOf('.');
    if (index == -1) return path;
    var ext = path.substring(index + 1);
    switch (ext) {
      case "jpg":
      case "jpeg":
        return "image/jpeg";
      case "png":
        return "image/png";
      case "gif":
        return "image/gif";
      case "webp":
        return "image/webp";
      case "mp4":
        return "video/mp4";
      case "mp3":
        return "audio/mpeg";
      default:
        return "application/octet-stream";
    }
  }

  static bool isLocaleFile(String path) {
    return !path.startsWith("http");
    // path.startsWith('file://');
  }
}
