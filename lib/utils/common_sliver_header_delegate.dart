import 'package:flutter/material.dart';
import 'package:qianshi_chat/main.dart';

class CommonSliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  PreferredSize child; //传入preferredsize组件，因为此组件需要固定高度
  bool islucency; //入参 是否更加滑动变化透明度，true，false
  Color? backgroundColor; //需要设置的背景色
  CommonSliverHeaderDelegate(
      {required this.islucency, required this.child, this.backgroundColor});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    double mainHeight = maxExtent - shrinkOffset; //动态获取滑动剩余高度
    logger.i('backgroundColor: $backgroundColor');
    return Container(
      color: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      child: Opacity(
          opacity: islucency == true && mainHeight != maxExtent
              ? ((mainHeight / maxExtent) * 0.5).clamp(0, 1)
              : 1, //根据滑动高度隐藏显示
          child: child),
    );
  }

  @override
  double get maxExtent => child.preferredSize.height;

  @override
  double get minExtent => child.preferredSize.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
