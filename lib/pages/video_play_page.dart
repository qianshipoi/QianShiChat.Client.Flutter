import 'package:flutter/material.dart';
import 'package:qianshi_chat/utils/video_player_utils.dart';

class VideoPlayerUI extends StatefulWidget {
  const VideoPlayerUI({Key? key}) : super(key: key);

  @override
  State<VideoPlayerUI> createState() => _VideoPlayerUIState();
}

class _VideoPlayerUIState extends State<VideoPlayerUI> {
  Widget? _playerUI;
  @override
  void initState() {
    super.initState();
    // 播放视频
    VideoPlayerUtils.playerHandle("");
    VideoPlayerUtils.initializedListener(
        key: this,
        listener: (initialize, widget) {
          if (initialize) {
            _playerUI = widget;
            if (!mounted) return;
            setState(() {});
          }
        });
  }

  @override
  void dispose() {
    VideoPlayerUtils.removeInitializedListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        width: 414,
        height: 414 * 9 / 16,
        color: Colors.black26,
        child: _playerUI ??
            const CircularProgressIndicator(
              strokeWidth: 3,
            ));
  }
}
