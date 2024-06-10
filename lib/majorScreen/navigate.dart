import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:video_player/video_player.dart';

class Navigate extends StatefulWidget {
  const Navigate({Key? key});

  @override
  State<Navigate> createState() => _NavigateState();
}

class _NavigateState extends State<Navigate> {
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset(
      'assets/nav.mp4', // Replace with the video URL
    )..initialize().then((_) {
      _videoController.setLooping(true); // Loop the video
      _videoController.play();
    });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Navigation'),
        centerTitle: true,
        backgroundColor: Color(0xff252525),
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: VideoPlayer(_videoController),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            heightFactor: 12,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Adjust the blur intensity
                child: FractionallySizedBox(
                  widthFactor: 0.7, // Adjust as needed
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent, // Make the button background transparent
                      elevation: 0, // Remove the default elevation
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        side: BorderSide(
                          color: Colors.black, // Add a white border
                          width: 2.0, // Adjust the border width
                        ),
                      ),
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 18, // Adjust text size
                      ),
                    ),
                    onPressed: () async {
                      var openAppResult = await LaunchApp.openApp(
                        androidPackageName: 'com.neogoma.stardustnavigationsample',
                      );
                      print('openAppResult => $openAppResult ${openAppResult.runtimeType}');
                    },
                    child: const Text('START NAVIGATION',style: TextStyle(color: Colors.black),),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
