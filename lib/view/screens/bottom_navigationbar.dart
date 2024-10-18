import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';

import '../../provider/mirror_wall_provider.dart';
import 'history.dart';

class BottomNaviagation extends StatelessWidget {
  const BottomNaviagation({super.key});


  @override
  Widget build(BuildContext context) {
    var providerTrue = Provider.of<SearchEngineProvider>(context);
    var providerFalse =
    Provider.of<SearchEngineProvider>(context, listen: false);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(onPressed: () {
          providerTrue.txtSearch.clear();
          providerTrue.webViewController!.loadUrl(
            urlRequest: URLRequest(
              url: WebUri(providerTrue.selectedEngineUrl),
            ),
          );
        }, icon: Icon(Icons.home)),
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: providerTrue.canGoBack ? providerFalse.goBack : null,
        ),
        IconButton(
          onPressed: () {
            providerTrue.webViewController!.reload();
          },
          icon: const Icon(Icons.refresh),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed:
          providerTrue.canGoForward ? providerFalse.goForward : null,
        ),
        IconButton(
          icon: const Icon(Icons.history),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HistoryScreen(),
              ),
            );
          },
        ),
      ],
    );
  }
}