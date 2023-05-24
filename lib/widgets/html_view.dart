import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

const htmlData = r"""
  <iframe
    width="100%"
    height="285"
    id="inlineFrameExample"
    title="Camera preview"
    src="https://minitank.chernandezdev.online/"
    >
  </iframe>
""";

class HtmlView extends StatelessWidget {
  const HtmlView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 1,
      // color: Colors.red,
      child: Html(data: htmlData),
    );
  }
}
