import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_radio_player/flutter_radio_player.dart';
import 'package:flutter_radio_player/models/frp_player_event.dart';

class FRPPlayerControls extends StatefulWidget {
  final FlutterRadioPlayer flutterRadioPlayer;
  final Function addSourceFunction;
  final Function nextSource;
  final Function prevSource;
  final Function(String status) updateCurrentStatus;

  const FRPPlayerControls({
    Key? key,
    required this.flutterRadioPlayer,
    required this.addSourceFunction,
    required this.nextSource,
    required this.prevSource,
    required this.updateCurrentStatus,
  }) : super(key: key);

  @override
  State<FRPPlayerControls> createState() => _FRPPlayerControlsState();
}

class _FRPPlayerControlsState extends State<FRPPlayerControls> {
  String latestPlaybackStatus = "flutter_radio_stopped";
  String currentPlaying = "N/A";
  double volume = 0.5;
  final nowPlayingTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.flutterRadioPlayer.frpEventStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          FRPPlayerEvents frpEvent =
              FRPPlayerEvents.fromJson(jsonDecode(snapshot.data as String));
          if (kDebugMode) {
            print("====== EVENT START =====");
            print("Playback status: ${frpEvent.playbackStatus}");
            print("Icy details: ${frpEvent.icyMetaDetails}");
            print("Other: ${frpEvent.data}");
            print("====== EVENT END =====");
          }
          if (frpEvent.playbackStatus != null) {
            latestPlaybackStatus = frpEvent.playbackStatus!;
            widget.updateCurrentStatus(latestPlaybackStatus);
          }
          if (frpEvent.icyMetaDetails != null) {
            currentPlaying = frpEvent.icyMetaDetails!;
            nowPlayingTextController.text = frpEvent.icyMetaDetails!;
          }
          var statusIcon = const Icon(Icons.pause_circle_outline,
              size: 55, color: Colors.white);
          switch (frpEvent.playbackStatus) {
            case "flutter_radio_playing":
              statusIcon = const Icon(Icons.pause_circle_outline,
                  size: 55, color: Colors.white);
              break;
            case "flutter_radio_paused":
              statusIcon = const Icon(Icons.play_circle_outline,
                  size: 55, color: Colors.white);
              break;
            case "flutter_radio_loading":
              statusIcon = const Icon(Icons.refresh_rounded,
                  size: 55, color: Colors.white);
              break;
            case "flutter_radio_stopped":
              statusIcon = const Icon(Icons.play_circle_outline,
                  size: 55, color: Colors.white);
              break;
          }
          return latestPlaybackStatus == "flutter_radio_stopped"
              ? ElevatedButton(
                  onPressed: () async {
                    await widget.addSourceFunction();
                  },
                  child: const Text("Reproducir"),
                )
              : Center(
                  child: Column(
                    children: [
                      GestureDetector(
                          onTap: () async {
                            widget.flutterRadioPlayer.playOrPause();
                            resetNowPlayingInfo();
                          },
                          child: statusIcon),
                      Slider(
                        value: volume,
                        onChanged: (value) {
                          setState(() {
                            volume = value;
                            widget.flutterRadioPlayer.setVolume(volume);
                          });
                        },
                      )
                    ],
                  ),
                );
        } else if (latestPlaybackStatus == "flutter_radio_stopped") {
          return ElevatedButton(
            onPressed: () async {
              await widget.addSourceFunction();
            },
            child: const Text("Reproducir"),
          );
        }
        return const Text("Determining state ...");
      },
    );
  }

  void resetNowPlayingInfo() {
    currentPlaying = "N/A";
  }
}
