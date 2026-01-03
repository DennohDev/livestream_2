// flutter imports
import 'package:flutter/material.dart';
import 'package:livestream_2/home_page.dart';

// Package imports:
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ZegoUIKit().initLog().then((value) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LiveStreaming',
      home: ZegoUIKitPrebuiltLiveStreamingMiniPopScope(child: HomePage(),),
    );
  }
}
