import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Browser extends StatelessWidget {
  final String url;

  const Browser({Key key, @required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
        javascriptChannels: <JavascriptChannel>[
          JavascriptChannel(
              name: "Toast",
              onMessageReceived: (JavascriptMessage message) {
                Toast.show(message.message, context);
                print(message.message);
                _openGallery();
              }),
        ].toSet(),
      ),
    );
  }


  _openGallery() async {
    await ImagePicker.pickImage(source: ImageSource.gallery);
  }

}
