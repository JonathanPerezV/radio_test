// ignore_for_file: library_private_types_in_public_api, must_be_immutable
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InternalWebView extends StatefulWidget {
  String? url;
  String title;

  InternalWebView({super.key, this.url, required this.title});
  @override
  _InternalWebViewState createState() => _InternalWebViewState();
}

class _InternalWebViewState extends State<InternalWebView> {
  late WebViewController webController;
  final sckey = GlobalKey<ScaffoldState>();
  bool loading = true;
  bool progresoBarra = true;
  int progreso = 0;
  String titulo = "Términos y condiciones";
  bool pageInit = false;
  //late final CheckInternet _internet;

  @override
  void initState() {
    super.initState();
    initWebView();
  }

  void initWebView() async {
    webController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (int progress) {
          progreso = progress;
        },
        onPageStarted: (String url) {
          if (!pageInit) setState(() => loading = true);
        },
        onPageFinished: (String url) {
          if (!pageInit) setState(() => loading = false);
          if (!pageInit) setState(() => pageInit = true);
          if (!pageInit) setState(() {});
        },
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith('https://www.youtube.com/')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ))
      ..loadRequest(Uri.parse(widget.url!));

    await webController.getTitle().then((value) {
      setState(() {
        loading = false;
        progresoBarra = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(33, 29, 82, 1),
      key: sckey,
      body: Stack(
        children: [
          Column(children: [
            const SizedBox(height: 50),
            barraProgreso(),
            Expanded(
                child: !loading
                    ? WebViewWidget(controller: webController)
                    : Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(
                                color: Colors.white),
                            const SizedBox(height: 10),
                            Text("Cargando web... $progreso%",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold))
                          ],
                        ),
                      )),
          ]),
        ],
      ),
    );
    // });
  }

  barraProgreso() {
    return Visibility(
      visible: progresoBarra,
      child: const LinearProgressIndicator(
        minHeight: 5,
        color: Colors.blue,
      ),
    );
  }
}
