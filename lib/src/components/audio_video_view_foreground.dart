// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zego_uikit/zego_uikit.dart';

class ZegoAudioVideoForeground extends StatelessWidget {
  final Size size;
  final ZegoUIKitUser? user;
  final bool isInviter;
  final bool showMicrophoneStateOnView;
  final bool showCameraStateOnView;
  final bool showUserNameOnView;

  const ZegoAudioVideoForeground({
    Key? key,
    this.user,
    required this.size,
    this.showMicrophoneStateOnView = true,
    this.showCameraStateOnView = true,
    this.showUserNameOnView = true,
    required this.isInviter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isForeground = 1.sw / size.width > 1;
    if (user == null) {
      return Container(color: Colors.transparent);
    }
    return LayoutBuilder(builder: ((context, constraints) {
      return Container(
        padding: const EdgeInsets.all(5),
        alignment: Alignment.center,
        child: Stack(
          children: [
            Positioned(
                top: isForeground ? null : 40.h,
                left: isForeground ? null : 0,
                right: isForeground ? null : 0,
                bottom: isForeground ? 0 : null,
                child: Visibility(
                  visible: !isInviter,
                  child: Container(
                  alignment: Alignment.center,
                  child: userName(
                    context,
                    constraints.maxWidth * 0.8,
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }));
  }

  Widget userName(BuildContext context, double maxWidth) {
    bool isForeground = 1.sw / size.width > 1;
    return showUserNameOnView
        ? ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: maxWidth,
            ),
            child: Text(
              user?.name ?? "",
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: isForeground ? 14.sp : 18.sp,
                color: Colors.white,
                fontWeight: isForeground ? FontWeight.w600 : FontWeight.bold,
                height: isForeground ? 20 / 14 : 24 / 18,
                decoration: TextDecoration.none,
              ),
            ),
          )
        : const SizedBox();
  }

  Widget microphoneStateIcon() {
    if (!showMicrophoneStateOnView) {
      return const SizedBox();
    }

    return ZegoMicrophoneStateIcon(targetUser: user);
  }

  Widget cameraStateIcon() {
    if (!showCameraStateOnView) {
      return const SizedBox();
    }

    return ZegoCameraStateIcon(targetUser: user);
  }
}
