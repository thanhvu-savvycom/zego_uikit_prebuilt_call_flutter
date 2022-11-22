// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_call/src/call_invitation/defines.dart';
import 'package:zego_uikit_prebuilt_call/src/call_invitation/internal/internal.dart';
import 'package:zego_uikit_prebuilt_call/src/call_invitation/pages/page_manager.dart';

// Project imports:

typedef AvatarBuilder = Widget Function(BuildContext context, Size size, ZegoUIKitUser? user, Map extraInfo);

/// top sheet, popup when invitee receive a invitation
class ZegoCallInvitationDialog extends StatefulWidget {
  const ZegoCallInvitationDialog({
    Key? key,
    required this.invitationData,
    this.avatarBuilder,
  }) : super(key: key);

  final ZegoCallInvitationData invitationData;
  final AvatarBuilder? avatarBuilder;

  @override
  ZegoCallInvitationDialogState createState() => ZegoCallInvitationDialogState();
}

class ZegoCallInvitationDialogState extends State<ZegoCallInvitationDialog> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFF0A0B09).withOpacity(0.8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16.r)),
      ),
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 22.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.avatarBuilder?.call(context, Size(45.r, 45.r), widget.invitationData.inviter, {}) ??
                circleName(widget.invitationData.inviter?.name ?? ""),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.invitationData.inviter?.name ?? "",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0.r,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.none,
                        height: 28 / 20),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    invitationTypeString(
                      widget.invitationData.type,
                      widget.invitationData.invitees,
                    ),
                    style: TextStyle(
                        color: Color(0xFF99EBEBF5),
                        fontSize: 20.r,
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.none,
                        height: 28 / 20),
                  )
                ],
              ),
            ),
            Listener(
              onPointerDown: (e) {
                ZegoInvitationPageManager.instance.hideInvitationTopSheet();
              },
              child: AbsorbPointer(
                absorbing: false,
                child: ZegoRefuseInvitationButton(
                  inviterID: widget.invitationData.inviter?.id ?? "",
                  // customization is not supported
                  data: '{"reason":"decline"}',
                  icon: ButtonIcon(
                    icon: Image(
                      image: PrebuiltCallImage.asset(InvitationStyleIconUrls.callDecline).image,
                      fit: BoxFit.fill,
                    ),
                  ),
                  iconSize: Size(36.r, 36.r),
                  buttonSize: Size(36.r, 36.r),
                  onPressed: (String code, String message) {
                    ZegoInvitationPageManager.instance.onLocalRefuseInvitation(code, message);
                  },
                ),
              ),
            ),
            SizedBox(width: 14.w),
            Listener(
              onPointerDown: (e) {
                ZegoInvitationPageManager.instance.hideInvitationTopSheet();
              },
              child: AbsorbPointer(
                absorbing: false,
                child: ZegoAcceptInvitationButton(
                  inviterID: widget.invitationData.inviter?.id ?? "",
                  icon: ButtonIcon(
                    icon: Image(
                      image: PrebuiltCallImage.asset(imageCallURLByInvitationType(widget.invitationData.type)).image,
                      fit: BoxFit.fill,
                    ),
                  ),
                  iconSize: Size(36.r, 36.r),
                  buttonSize: Size(36.r, 36.r),
                  onPressed: (String code, String message) {
                    ZegoInvitationPageManager.instance.onLocalAcceptInvitation(code, message);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget circleName(String name) {
    return Container(
      width: 45.r,
      height: 45.r,
      decoration: const BoxDecoration(color: Color(0xffDBDDE3), shape: BoxShape.circle),
      child: Center(
        child: Text(
          name.isNotEmpty ? name.characters.first : "",
          style: TextStyle(
            fontSize: 28.r,
            color: const Color(0xff222222),
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }

  String imageCallURLByInvitationType(ZegoInvitationType invitationType) {
    switch (invitationType) {
      case ZegoInvitationType.voiceCall:
        return InvitationStyleIconUrls.callAcceptAudio;
      case ZegoInvitationType.videoCall:
        return InvitationStyleIconUrls.callAcceptVideo;
    }
  }

  String imageURLByInvitationType(ZegoInvitationType invitationType) {
    switch (invitationType) {
      case ZegoInvitationType.voiceCall:
        return InvitationStyleIconUrls.inviteVoice;
      case ZegoInvitationType.videoCall:
        return InvitationStyleIconUrls.inviteVideo;
    }
  }

  String invitationTypeString(ZegoInvitationType invitationType, List<ZegoUIKitUser> invitees) {
    switch (invitationType) {
      case ZegoInvitationType.voiceCall:
        return invitees.length > 1 ? "Group voice call" : "Voice call";
      case ZegoInvitationType.videoCall:
        return invitees.length > 1 ? "Group video call" : "Video call";
    }
  }
}
