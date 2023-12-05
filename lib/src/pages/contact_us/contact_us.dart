import 'package:flutter/material.dart';
import 'package:radio_test_player/controller/preferences/user_preferences.dart';
import 'package:radio_test_player/src/icons/radio_play_icons.dart';
import 'package:radio_test_player/src/utils/interal_webview.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  String nombre = "";

  @override
  void initState() {
    super.initState();
    getName();
  }

  void getName() async {
    final data = await UserPreferences().getUsername();
    final last = await UserPreferences().getUserLastname() ?? "";

    setState(() => nombre = "$data $last");
  }

  List<Map<String, dynamic>> optionsContact = [
    {
      "id": 1,
      "name": "Whatsapp",
      "icon": RadioPlay.whatsapp,
      "url":
          "https://api.whatsapp.com/send/?phone=593991272929&text=Hola+me+llamo+nombre+y+soy+oyente+de+la+radio+Horizontes,+mi+inquietud+es+la+siguiente:&type=phone_number&app_absent=0"
    },
    {
      "id": 2,
      "name": "Facebook",
      "icon": RadioPlay.facebook,
      "url": "https://www.facebook.com/RadioHorizontes94.9/"
    },
    {
      "id": 3,
      "name": "Instagram",
      "icon": RadioPlay.instagram,
      "url": "https://www.instagram.com/radiohorizontes94.9/"
    },
    {
      "id": 4,
      "name": "Nuestra web",
      "icon": Icons.web,
      "url": "http://www.radiohorizontes.com.ec"
    },
    {
      "id": 5,
      "name": "Youtube",
      "icon": RadioPlay.youtube,
      "url": "https://www.youtube.com/@radiohorizontes94.9"
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(33, 29, 82, 1),
          title: const Text(
            "Contáctanos",
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.white)),
        ),
        backgroundColor: const Color.fromRGBO(33, 29, 82, 1),
        body: options());
  }

  Widget options() => GridView.builder(
      itemCount: optionsContact.length,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (itemBuilder, index) {
        return GestureDetector(
          onTap: () async {
            if (optionsContact[index]["id"] == 1) {
              final replace = optionsContact[index]["url"]
                  .toString()
                  .replaceAll("nombre", nombre);
              final finalurl = replace;

              debugPrint("url: $finalurl");
              if (await canLaunchUrl(Uri.parse(finalurl))) {
                await launchUrl(Uri.parse(finalurl));
              }
            } else if (optionsContact[index]["id"] == 2) {
              if (await canLaunchUrl(Uri.parse(optionsContact[index]["url"]))) {
                await launchUrl(
                  Uri.parse(optionsContact[index]["url"]),
                  mode: LaunchMode.externalNonBrowserApplication,
                );
              }
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (builder) => InternalWebView(
                            title: "Radio Horizontes",
                            url: optionsContact[index]["url"],
                          )));
            }
          },
          child: Card(
            color: Colors.grey.shade600,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  optionsContact[index]["icon"],
                  color: Colors.white,
                  size: 50,
                ),
                const SizedBox(height: 10),
                Text(
                  optionsContact[index]["name"].toUpperCase(),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
      });
}
