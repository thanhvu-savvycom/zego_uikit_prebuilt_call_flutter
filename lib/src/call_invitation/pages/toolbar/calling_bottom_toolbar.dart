// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_call/src/call_invitation/defines.dart';
import 'package:zego_uikit_prebuilt_call/src/call_invitation/internal/internal.dart';
import 'package:zego_uikit_prebuilt_call/src/call_invitation/pages/page_manager.dart';

class ZegoInviterCallingBottomToolBar extends StatelessWidget {
  final List<ZegoUIKitUser> invitees;

  const ZegoInviterCallingBottomToolBar({
    Key? key,
    required this.invitees,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ZegoCancelInvitationButton(
        invitees: invitees.map((e) => e.id).toList(),
        text: "Huỷ",
        textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 20 / 14,
            decoration: TextDecoration.none),
        icon: ButtonIcon(
          icon: Image(
            image: PrebuiltCallImage.asset(InvitationStyleIconUrls.callDecline).image,
            fit: BoxFit.fill,
          ),
        ),
        buttonSize: Size(72.r, 72.r + 30.r),
        iconSize: Size(72.r, 72.r),
        onPressed: (String code, String message, List<String> errorInvitees) {
          ZegoInvitationPageManager.instance.onLocalCancelInvitation(code, message, errorInvitees);
        },
      ),
    );
  }
}

class ZegoInviteeCallingBottomToolBar extends StatefulWidget {
  final ZegoInvitationType invitationType;
  final ZegoUIKitUser inviter;
  final List<ZegoUIKitUser> invitees;

  const ZegoInviteeCallingBottomToolBar({
    Key? key,
    required this.inviter,
    required this.invitees,
    required this.invitationType,
  }) : super(key: key);

  @override
  State<ZegoInviteeCallingBottomToolBar> createState() {
    return ZegoInviteeCallingBottomToolBarState();
  }
}

class ZegoInviteeCallingBottomToolBarState extends State<ZegoInviteeCallingBottomToolBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 44.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ZegoRefuseInvitationButton(
            inviterID: widget.inviter.id,
            // data customization is not supported
            data: '{"reason":"decline"}',
            text: "Từ chối",
            textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 20 / 14,
                decoration: TextDecoration.none),
            icon: ButtonIcon(
              icon: Image(
                image: PrebuiltCallImage.asset(InvitationStyleIconUrls.callDecline).image,
                fit: BoxFit.fill,
              ),
            ),
            buttonSize: Size(72.r, 72.r + 30.r),
            iconSize: Size(72.r, 72.r),
            onPressed: (String code, String message) {
              ZegoInvitationPageManager.instance.onLocalRefuseInvitation(code, message);
            },
          ),
          const Spacer(),
          ZegoAcceptInvitationButton(
            inviterID: widget.inviter.id,
            icon: ButtonIcon(
              icon: Image(
                image: PrebuiltCallImage.asset(imageCallURLByInvitationType(widget.invitationType)).image,
                fit: BoxFit.fill,
              ),
            ),
            text: "Nghe máy",
            textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 20 / 14,
                decoration: TextDecoration.none),
            buttonSize: Size(72.r, 72.r + 30.r),
            iconSize: Size(72.r, 72.r),
            onPressed: (String code, String message) {
              ZegoInvitationPageManager.instance.onLocalAcceptInvitation(code, message);
            },
          ),
        ],
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
        return InvitationStyleIconUrls.toolbarBottomVoice;
      case ZegoInvitationType.videoCall:
        return InvitationStyleIconUrls.toolbarBottomVideo;
    }
  }
}
