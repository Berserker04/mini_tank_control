import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

const htmlData = r"""
  <iframe
    width="100%"
    height="300"
    id="inlineFrameExample"
    title="Camera preview"
    src="http://127.0.0.1:5500/test.html"
    >
  </iframe>
""";

class HtmlView extends StatelessWidget {
  const HtmlView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 1,
      color: Colors.white70,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Html(data: htmlData)]),
    );
  }
}
