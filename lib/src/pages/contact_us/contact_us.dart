import 'package:flutter/material.dart';
import 'package:radio_test_player/src/icons/radio_play_icons.dart';
import 'package:radio_test_player/src/utils/interal_webview.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  List<Map<String, dynamic>> optionsContact = [
    {
      "id": 1,
      "name": "Whatsapp",
      "icon": RadioPlay.whatsapp,
      "url": "https://web.whatsap.com"
    },
    {
      "id": 2,
      "name": "Facebook",
      "icon": RadioPlay.facebook,
      "url": "https://www.facebook.com/"
    },
    {
      "id": 3,
      "name": "Instagram",
      "icon": RadioPlay.instagram,
      "url": "https://www.instagram.com/"
    },
    {
      "id": 4,
      "name": "Nuestra web",
      "icon": Icons.web,
      "url": "https://www.google.com/"
    },
    {
      "id": 5,
      "name": "Youtube",
      "icon": RadioPlay.youtube,
      "url": "https://www.youtube.com/"
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
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (builder) => InternalWebView(
                        title: "Radio Horizontes",
                        url: optionsContact[index]["url"],
                      ))),
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
