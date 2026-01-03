import 'dart:math';

import 'package:flutter/material.dart';
import 'package:livestream_2/constants.dart';
import 'package:livestream_2/live_page.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // Users who have the same ID can join the live stream
  final liveTextCtrl = TextEditingController(
    text: Random().nextInt(10000).toString(),
  );
  @override
  Widget build(BuildContext context) {
    final buttonStyle = ElevatedButton.styleFrom(
      fixedSize: const Size(120, 60),
      backgroundColor: const Color(0xff2CF3E).withOpacity(0.6),
    );

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('User ID:$localUserID'),
            const Text('Please test with two or more devices'),
            TextFormField(
              controller: liveTextCtrl,
              decoration: const InputDecoration(labelText: 'join live by id'),
            ),
            const SizedBox(height: 20),

            // click to navigate to live page
            ElevatedButton(
              style: buttonStyle,
              onPressed: () {
                if (ZegoUIKitPrebuiltLiveStreamingController()
                    .minimize
                    .isMinimizing) {
                  /// when the application is minimized go into a minimized state
                  /// disable button clicks to prevent mulitple PrebuiltLiveStreaming components grom being created.
                  return;
                }
                jumpToLivePage(
                  context,
                  liveID: liveTextCtrl.text.trim(),
                  isHost: true,
                );
              },
              child: const Text('Start a Live'),
            ),
            const SizedBox(height: 20),
            // Click me to navigate to live page
            ElevatedButton(
              style: buttonStyle,
              onPressed: () {
                if (ZegoUIKitPrebuiltLiveStreamingController()
                    .minimize
                    .isMinimizing) {
                  /// when the application is minimized go into a minimized state
                  /// disable button clicks to prevent mulitple PrebuiltLiveStreaming components grom being created.
                  return;
                }
                jumpToLivePage(
                  context,
                  liveID: liveTextCtrl.text.trim(),
                  isHost: false,
                );
              },
              child: const Text('Watch a live'),
            ),
          ],
        ),
      ),
    );
  }

  void jumpToLivePage(
    BuildContext context, {
    required String liveID,
    required bool isHost,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LivePage(liveID: liveID, isHost: isHost),
      ),
    );
  }
}
