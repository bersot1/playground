import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Webview extends StatefulWidget {
  const Webview({Key? key}) : super(key: key);

  @override
  _WebviewState createState() => _WebviewState();
}

class _WebviewState extends State<Webview> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  late WebViewController _con;

  /*
  *
  * Webview
  * */

  String setHTML() {
    return ('''
    <html>
      <head>
        <!-- Required meta tags -->
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <script src="https://api.test.easypay.pt/assets/checkout/js/sdk/1.2.1/checkout.js"></script>
        
      </head>
      
        <body style="background-color:#fff;height:100vh ">

        <div id="easypay-checkout"></div>


          <script>
           document.addEventListener('DOMContentLoaded', function () {
            console.log('document is ready. I can sleep now');
            hello();
            setTimeout(function() {document.getElementById('easypay-checkout-open').click();}, 1000);            
            });

            function onCancelPost(){
              Print.postMessage('The checkout was canceled!');
            }

            function onClose(){
              Print.postMessage('The checkout was close!');
            }

            function onComplete(){
              Print.postMessage('The checkout was complete!');
            }

          function hello() {
            console.log('teste metodo hello');

            var manifest = {
                "id": "0c56832f-b80e-4032-a0d2-2fd828b20d10",
                "session": "zIE9ep6HGin5JANPc78gZisXTDrASbdtv9ZpSmXJmR6p_bnY0owqHhReVLvHQPjGsG8txI_xxP6eiGsbWd8DP6BKrbrvMWsONWsXi2t9s-Eb5wytsbCItmT_uVytSC5q-Rc-fOlp4q1gTgQcJoG51JqF9n0TBIoXSvvbYi29cTiiRsVOPWyJqZn0m0OGYV1vHuD2BnjZhsHLTW0y6c8rZcUU5os-T2cFHrXyYXyiGx_V_qnKlnvQ-2EgL45rqPWjQJHJzrK90csstO-8hHpWKKiLiGZTYACfS8Os11UMuOe3FTvbPuBDDWsyXZqc6vipafBYfa14A3aLvbSrFmHvq3NIpHKM9QPlKmI44NLsItkEx8oetGSv2WeJDRx7vS-MMvhjXk7okzgTCjLGWiIkswQJYmuWFjY_gR6pCx9Rhl5CngNIHkGEcUJrg7FDqzFQnMVkxSv765worITyXEnvWxFGDKvFFwQaqb78exostGnEsopWKu_0fs4lpciZYH1hivYzGpJXhhUJOXeIHQhV6blp35F2ixlTIR28n2jc9iU=",
                "config": null
            };

            EasypayCheckoutUI.setup(manifest).then(function (modal) {
              modal.onCancel(function () {
                // This is triggered on popup close, if the checkout is not complete
                alert('The checkout was canceled!');
                onCancelPost();
              });
          
              modal.onClose(function () {
                // This is triggered on popup close, if the checkout is complete
                alert('The checkout was closed!');
                onCancelPost();
              });
          
              modal.onComplete(function (data) {
                alert('The checkout was finished');
                onCancelPost();
              });
            });

            
          }

         
          </script>
        </body>
      </html>
      

    ''');
  }

  _loadHTML() async {
    _con.loadUrl(
        Uri.dataFromString(setHTML(), mimeType: 'text/html', encoding: Encoding.getByName('utf-8')).toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Webview'),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return ListView(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: WebView(
                  javascriptMode: JavascriptMode.unrestricted,
                  javascriptChannels: Set.from([
                    JavascriptChannel(
                        name: 'Print',
                        onMessageReceived: (JavascriptMessage message) {
                          //This is where you receive message from
                          //javascript code and handle in Flutter/Dart
                          //like here, the message is just being printed
                          //in Run/LogCat window of android studio
                          print(message.message);
                        })
                  ]),
                  onWebViewCreated: (WebViewController webViewController) {
                    // _controller.complete(webViewController);
                    _con = webViewController;
                    _loadHTML();
                  },
                  onProgress: (int progress) {
                    print("WebView is loading (progress : $progress%)");
                  },
                  navigationDelegate: (NavigationRequest request) {
                    if (request.url.startsWith('https://www.youtube.com/')) {
                      print('blocking navigation to $request}');
                      return NavigationDecision.prevent;
                    }
                    print('allowing navigation to $request');
                    return NavigationDecision.navigate;
                  },
                  onPageStarted: (String url) {
                    print('Page started loading: $url');
                  },
                  onPageFinished: (String url) {
                    print('Page finished loading: $url');
                  },
                  gestureNavigationEnabled: true,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          print(message.message);
        });
  }
}
