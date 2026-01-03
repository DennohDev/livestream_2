// Flutter imports:
import 'package:flutter/material.dart';
import 'package:livestream_2/constants.dart';
import 'dart:math';

// Package imports:
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

// Project imports:
import 'common.dart';

class LivePage extends StatefulWidget {
  final String liveID;
  final bool isHost;
  final String localUserID;

  const LivePage({
    super.key,
    required this.liveID,
    this.isHost = false,
    required this.localUserID,
  });

  @override
  State<StatefulWidget> createState() => LivePageState();
}

class LivePageState extends State<LivePage> {
  @override
  Widget build(BuildContext context) {
    final hostConfig = ZegoUIKitPrebuiltLiveStreamingConfig.host(
      plugins: [ZegoUIKitSignalingPlugin()],
    )..audioVideoView.foregroundBuilder = hostAudioVideoViewForegroundBuilder;

    final audienceConfig = ZegoUIKitPrebuiltLiveStreamingConfig.audience(
      plugins: [ZegoUIKitSignalingPlugin()],
    );
    final audienceEvents = ZegoUIKitPrebuiltLiveStreamingEvents(
      onError: (ZegoUIKitError error) {
        debugPrint('onError:$error');
      },
      audioVideo: ZegoLiveStreamingAudioVideoEvents(
        onCameraTurnOnByOthersConfirmation: (BuildContext context) {
          return onTurnOnAudienceDevieConfirmation(
            context,
            isCameraOrMicrophone: true,
          );
        },
        onMicrophoneTurnOnByOthersConfirmation: (BuildContext context) {
          return onTurnOnAudienceDevieConfirmation(
            context,
            isCameraOrMicrophone: false,
          );
        },
      ),
    );
    return SafeArea(
      child: ZegoUIKitPrebuiltLiveStreaming(
        appID: 989560183 /*input your AppID*/,
        appSign:
            'e5d30554de10fb6e23664a5663bbe6c792d27704a4e899c73082d1d4ef6c004e' /*input your AppSign*/,
        userID: localUserID,
        userName: 'user_$localUserID',
        liveID: widget.liveID,
        events: widget.isHost ? ZegoUIKitPrebuiltLiveStreamingEvents(onError: (ZegoUIKitError error){
          debugPrint('onError:$error');
        },) : audienceEvents,
        config: (widget.isHost ? hostConfig : audienceConfig)..audioVideoView.useVideoViewAspectFill = true
        /// Supporting Minimizing
        ..topMenuBar.buttons = [
          ZegoLiveStreamingMenuBarButtonName.minimizingButton,
        ]

        /// custom avatar
        ..avatarBuilder = customAvatarBuilder

        /// message attributes example
        ..inRoomMessage.attributes = userLevelsAttributes
        ..inRoomMessage.avatarLeadingBuilder = userLevelBuilder,
      ),
    );
  }

  Map<String, String> userLevelsAttributes() {
    return {'lv': Random(localUserID.hashCode).nextInt(100).toString()};
  }

  Widget userLevelBuilder(
    BuildContext context,
    ZegoInRoomMessage message,
    Map<String, dynamic> extrainfo,
  ) {
    return Container(
      alignment: Alignment.center,
      height: 15,
      width: 30,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.purple.shade300, Colors.purple.shade400],
        ),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Text(
        "LV ${message.attributes['lv']}",
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 10),
      ),
    );
  }

  Image prebuiltImage(String name) {
    return Image.asset(name, package: 'zego_uikit_prebuilt_live_streaming');
  }

  Widget hostAudioVideoViewForegroundBuilder(
    BuildContext context,
    Size size,
    ZegoUIKitUser? user,
    Map<String, dynamic> extrainfo,
  ) {
    if (user == null || user.id == localUserID) {
      return Container();
    }
    const toolbarCameraNormal = 'assets/icons/toolbar_camera_normal.png';
    const toolbarCameraOff = 'assets/icons/toolbar_camera_off.png';
    const toolbarMicNormal = 'assets/icons/toolbar_mic_normal.png';
    const toolbarMicOff = 'assets/icons/toolbar_mic_off.png';
    return Positioned(
      top: 15,
      right: 0,
      child: Row(
        children: [
          ValueListenableBuilder<bool>(
            valueListenable: ZegoUIKit().getCameraStateNotifier(user.id),
            builder: (context, isCameraEnabled, _) {
              return GestureDetector(
                onTap: () {
                  ZegoUIKit().turnCameraOn(!isCameraEnabled, userID: user.id);
                },
                child: SizedBox(
                  width: size.width * 0.4,
                  height: size.width * 0.4,
                  child: prebuiltImage(
                    isCameraEnabled ? toolbarCameraNormal : toolbarCameraOff,
                  ),
                ),
              );
            },
          ),
          SizedBox(width: size.width * 0.1),
          ValueListenableBuilder<bool>(
            valueListenable: ZegoUIKit().getMicrophoneStateNotifier(user.id),
            builder: (builder, isMicrophoneEnabled, _) {
              return GestureDetector(
                onTap: () {
                  ZegoUIKit().turnMicrophoneOn(
                    !isMicrophoneEnabled,
                    userID: user.id,

                    /// if you do not want to stop cohosting automatically when both camera and microphone are off
                    /// set the [muteMode] parameter to truue.
                    ///  However, in this cas your [zegoUIKitPrebuiltLiveStreamingConfig.stopCoHostingWehnMicCameraOff]
                    /// should also be set to false.
                    muteMode: true,
                  );
                },
                child: SizedBox(
                  width: size.width * 0.4,
                  height: size.width * 0.4,
                  child: prebuiltImage(
                    isMicrophoneEnabled ? toolbarMicNormal : toolbarMicOff,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<bool> onTurnOnAudienceDevieConfirmation(
    BuildContext context, {
    required bool isCameraOrMicrophone,
  }) async {
    const textStyle = TextStyle(fontSize: 10, color: Colors.white70);
    const buttonTextStyle = TextStyle(fontSize: 10, color: Colors.black);

    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.blue[900]!.withOpacity(0.9),
          title: Text(
            "You have a request to turn on your ${isCameraOrMicrophone ? "camera" : "microphone"}?",
            style: textStyle,
          ),
          content: Text(
            "Do you agree to turn on the ${isCameraOrMicrophone ? "camera" : "microphone"}?",
            style: textStyle,
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel', style: buttonTextStyle),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Ok', style: buttonTextStyle),
            ),
          ],
        );
      },
    );
  }
}
