// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_call/src/call_invitation/defines.dart';
import 'package:zego_uikit_prebuilt_call/src/call_invitation/internal/internal.dart';
import 'toolbar/calling_bottom_toolbar.dart';
import 'toolbar/calling_top_toolbar.dart';

typedef AvatarBuilder = Widget Function(
    BuildContext context, Size size, ZegoUIKitUser? user, Map extraInfo);

class ZegoCallingInviterView extends StatelessWidget {
  const ZegoCallingInviterView({
    Key? key,
    required this.inviter,
    required this.invitees,
    required this.invitationType,
    this.avatarBuilder,
  }) : super(key: key);

  final ZegoUIKitUser inviter;
  final List<ZegoUIKitUser> invitees;
  final ZegoInvitationType invitationType;
  final AvatarBuilder? avatarBuilder;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        backgroundView(),
        surface(context),
      ],
    );
  }

  Widget backgroundView() {
    if (ZegoInvitationType.videoCall == invitationType) {
      return ZegoAudioVideoView(user: inviter);
    }

    return backgroundImage();
  }

  Widget surface(BuildContext context) {
    var isVideo = ZegoInvitationType.videoCall == invitationType;

    var firstInvitee =
        invitees.isNotEmpty ? invitees.first : ZegoUIKitUser.empty();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        isVideo ? const ZegoInviterCallingVideoTopToolBar() : Container(),
        isVideo ? SizedBox(height: 80.h) : SizedBox(height: 120.h),
        SizedBox(
          width: 120.r,
          height: 120.r,
          child: avatarBuilder
                  ?.call(context, Size(120.r, 120.r), firstInvitee, {}) ??
              circleAvatar(firstInvitee.name),
        ),
        SizedBox(height: 10.r),
        centralName(firstInvitee.name),
        SizedBox(height: 8.r),
        callingText(invitationType),
        const Expanded(child: SizedBox()),
        ZegoInviterCallingBottomToolBar(invitees: invitees),
        SizedBox(height: 90.r),
      ],
    );
  }
}

class ZegoCallingInviteeView extends StatelessWidget {
  const ZegoCallingInviteeView({
    required this.inviter,
    required this.invitees,
    required this.invitationType,
    this.avatarBuilder,
    Key? key,
  }) : super(key: key);

  final ZegoUIKitUser inviter;
  final List<ZegoUIKitUser> invitees;
  final ZegoInvitationType invitationType;
  final AvatarBuilder? avatarBuilder;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        backgroundImage(),
        surface(context),
      ],
    );
  }

  Widget surface(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 150.r),
        SizedBox(
          width: 120.r,
          height: 120.r,
          child:
              avatarBuilder?.call(context, Size(120.r, 120.r), inviter, {}) ??
                  circleAvatar(inviter.name),
        ),
        SizedBox(height: 10.r),
        centralName(inviter.name),
        SizedBox(height: 8.r),
        callingText(invitationType),
        const Expanded(child: SizedBox()),
        ZegoInviteeCallingBottomToolBar(
          inviter: inviter,
          invitees: invitees,
          invitationType: invitationType,
        ),
        SizedBox(height: 90.r),
      ],
    );
  }
}

Widget backgroundImage() {
  return Container(
    width: double.infinity,
    height: double.infinity,
    color: Color(0xFF212E4A)
    // decoration: BoxDecoration(
    //   image: DecorationImage(
    //     image: PrebuiltCallImage.asset(InvitationStyleIconUrls.inviteBackground)
    //         .image,
    //     fit: BoxFit.fitHeight,
    //   ),
    // ),
  );
}

Widget centralName(String name) {
  return Text(
    name,
    style: TextStyle(
      color: Colors.white,
      fontSize: 18.0.r,
      decoration: TextDecoration.none,
      fontWeight: FontWeight.w700,
      height: 24/18
    ),
  );
}

Widget callingText(ZegoInvitationType invitationType) {
  return Text(
    invitationType == ZegoInvitationType.videoCall ? "Cuộc gọi Video đến" : "Cuộc gọi đến",
    style: TextStyle(
      color: Colors.white,
      fontSize: 14.0.r,
      fontWeight: FontWeight.w400,
      decoration: TextDecoration.none,
      height: 20/14
    ),
  );
}

Widget circleAvatar(String name) {
  return Container(
    decoration: const BoxDecoration(
      color: Color(0xffDBDDE3),
      shape: BoxShape.circle,
    ),
    child: Center(
      child: Text(
        name.isNotEmpty ? name.characters.first : "",
        style: TextStyle(
          fontSize: 96.0.r,
          color: const Color(0xff222222),
          decoration: TextDecoration.none,
        ),
      ),
    ),
  );
}
