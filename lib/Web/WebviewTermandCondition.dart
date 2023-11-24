import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:arm_cool_care/General/AppConstant.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

class WebViewClass extends StatefulWidget {
  final String title;
  final String url;

  const WebViewClass(this.title, this.url, {super.key});
  @override
  _WebViewClassState createState() => _WebViewClassState();
}

class _WebViewClassState extends State<WebViewClass> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.title == ""
          ? null
          : AppBar(
              backgroundColor: AppColors.tela,
              leading: Padding(
                padding: const EdgeInsets.only(left: 0.0),
                child: InkWell(
                  onTap: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    } else {
                      SystemNavigator.pop();
                    }
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    size: 30,
                    color: Colors.black,
                  ),
                ),
              ),
              title: Text(
                widget.title,
                style: const TextStyle(color: Colors.black),
              ),
            ),
      body: Stack(
        children: [
          // WebView(
          //   initialUrl: widget.url,
          //   onWebViewCreated: (WebViewController webViewController) {
          //     _controller.complete(webViewController);
          //   },
          //   onPageFinished: (finish) {
          //     setState(() {
          //       isLoading = false;
          //     });
          //   },
          // ),

          // InAppWebView(
          //                 key: webViewKey,
          //                 initialUrlRequest:
          //                     URLRequest(url: Uri.parse(widget.url ?? "")),
          //                 // initialUrlRequest:
          //                 // URLRequest(url: WebUri(Uri.base.toString().replaceFirst("/#/", "/") + 'page.html')),
          //                 // initialFile: "assets/index.html",

          //                 // contextMenu: contextMenu,
          //                 pullToRefreshController: pullToRefreshController,
          //                 onWebViewCreated: (controller) async {
          //                   webViewController = controller;
          //                   print(await controller.getUrl());
          //                 },
          //                 onLoadStart: (controller, url) async {
          //                   setState(() {
          //                     this.url = url.toString();
          //                     urlController.text = widget.url ?? "";
          //                   });
          //                 },

          //                 onLoadStop: (controller, url) async {
          //                   setState(() {
          //                     this.url = url.toString();
          //                     urlController.text = this.url;
          //                     isLoading = false;
          //                   });
          //                 },

          //                 onProgressChanged: (controller, progress) {
          //                   if (progress == 100) {
          //                     pullToRefreshController?.endRefreshing();
          //                   }
          //                   setState(() {
          //                     this.progress = progress / 100;
          //                     urlController.text = this.url;
          //                   });
          //                 },
          //                 onUpdateVisitedHistory: (controller, url, isReload) {
          //                   setState(() {
          //                     this.url = url.toString();
          //                     urlController.text = this.url;
          //                   });
          //                 },
          //                 onConsoleMessage: (controller, consoleMessage) {
          //                   print(consoleMessage);
          //                 },
          //               ),

          isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : const Stack(),

          WebViewWidget(controller: WebViewController())
        ],
      ),
    );
  }
}


/*
class WebViewState extends State<WebViewScreen>{

  String title,url;
  bool isLoading=true;
  final _key = UniqueKey();

  WebViewState(String title,String url){
    this.title=title;
    this.url=url;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
          title: Text(this.title,style: TextStyle(fontWeight: FontWeight.w700)),centerTitle: true
      ),
      body: Stack(
        children: <Widget>[
          WebView(
            key: _key,
            initialUrl: this.url,
            javascriptMode: JavascriptMode.unrestricted,
            onPageFinished: (finish) {
              setState(() {
                isLoading = false;
              });
            },
          ),
          isLoading ? Center( child: CircularProgressIndicator(),)
              : Stack(),
        ],
      ),
    );
  }

}*/
