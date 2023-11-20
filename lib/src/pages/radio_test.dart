// En tu código Flutter (Dart)
// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:flutter_radio_player/flutter_radio_player.dart';
import 'package:flutter_radio_player/models/frp_source_modal.dart';
import 'package:radio_test_player/src/pages/frp_player.dart';

class RadioPage extends StatefulWidget {
  const RadioPage({super.key});

  @override
  State<RadioPage> createState() => _RadioPageState();
}

class _RadioPageState extends State<RadioPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Radio App'),
      ),
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (builder) =>
                          PlayRadio(name: "Radio Horizontes"))),
              child: const Card(
                color: Color.fromRGBO(33, 29, 82, 1),
                elevation: 2,
                child: ListTile(
                  title: Text(
                    "Pulsa aquí",
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: Icon(
                    Icons.headphones,
                    color: Colors.white,
                  ),
                ),
              ),
            )
            /*FRPlayer(
              flutterRadioPlayer: _flutterRadioPlayer,
              frpSource: frpSource,
              useIcyData: false,
            ),*/
          ],
        ),
      ),
    );
  }
}

class PlayRadio extends StatefulWidget {
  String name;
  PlayRadio({super.key, required this.name});

  @override
  State<PlayRadio> createState() => _PlayRadioState();
}

class _PlayRadioState extends State<PlayRadio> {
  bool visibility = true;

  final FlutterRadioPlayer _flutterRadioPlayer = FlutterRadioPlayer();

  final FRPSource frpSource = FRPSource(
    mediaSources: <MediaSources>[
      MediaSources(
        url:
            "http://stream-153.zeno.fm/rxce5k6u5i5vv?zs=bHmqfjptRNyQtI4GdZOO7w", // dummy url
        description: "Horizonte",
        isPrimary: true,
        title: "Tu radio favorita",
        isAac: true,
      ),
    ],
  );

  @override
  void initState() {
    super.initState();
    _flutterRadioPlayer.initPlayer();
    _flutterRadioPlayer.addMediaSources(frpSource);
    _flutterRadioPlayer.play();
  }

  @override
  void dispose() {
    super.dispose();
    _flutterRadioPlayer.stop();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        setState(() => visibility = true);
      },
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(33, 29, 82, 1),
        body: Column(
          children: [
            Visibility(
              visible: visibility,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 100,
                height: 320,
                child: Stack(
                  children: [
                    Image.asset("assets/horizontes.png"),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        height: 100,
                        child: FRPlayer(
                          flutterRadioPlayer: _flutterRadioPlayer,
                          frpSource: frpSource,
                          useIcyData: false,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 30,
                      left: 5,
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 5, right: 5),
                width: double.infinity,
                height: double.infinity,
                color: Colors.white,
                child: Column(
                  children: [
                    Expanded(child: ListView()),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: const EdgeInsets.only(left: 10, right: 10),
                        child: TextField(
                          enabled: false,
                          onTap: () => setState(() => visibility = false),
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.send),
                              ),
                              hintText: "Escriba su mensaje...",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

/*
  const SizedBox(height: 5),
              )*/
