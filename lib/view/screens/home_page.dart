import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';

import '../../provider/mirror_wall_provider.dart';
import 'bottom_navigationbar.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.sizeOf(context).height;
    double w = MediaQuery.sizeOf(context).width;

    var providerTrue = Provider.of<SearchEngineProvider>(context);
    var providerFalse =
    Provider.of<SearchEngineProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: txtSearch,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(top: 1, left: 16),
            label: Text('Search'),
            suffixIcon: GestureDetector(
              onTap: () {
                final searchUrl =
                    providerTrue.selectedEngineUrl + txtSearch.text;
                providerTrue.webViewController?.loadUrl(
                  urlRequest: URLRequest(
                    url: WebUri(searchUrl),
                  ),
                );
                providerFalse.addToHistory(searchUrl);
                providerFalse.updateNavigationButtons();
              },
              child: Icon(Icons.search),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        ),
        actions: [
          PopupMenuButton<Map<String, String>>(
            color: Colors.white,
            onSelected: (Map<String, String> engine) {
              providerTrue.setSearchEngine(
                  engine['url']!); // Update the search engine URL
              providerTrue.webViewController!.loadUrl(
                urlRequest: URLRequest(
                  url: WebUri(engine['url']!),
                ),
              );
            },
            itemBuilder: (BuildContext context) {
              return providerTrue.searchEngines.map((engine) {
                return PopupMenuItem<Map<String, String>>(
                  value: engine,
                  child: Row(
                    children: [
                      Image.network(
                        engine['logo']!,
                        width: 20,
                        height: 20,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 8),
                      Text(engine['name']!),
                    ],
                  ),
                );
              }).toList();
            },
            icon: const Icon(Icons.more_vert), // Icon for the button
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<SearchEngineProvider>(
              builder: (context, value, child) {
                return InAppWebView(
                  initialUrlRequest: URLRequest(
                    url: WebUri(value.selectedEngineUrl),
                  ),
                  onWebViewCreated: (controller) {
                    value.webViewController = controller;
                  },
                  onLoadStop: (controller, url) async {
                    if (url != null) {
                      value.setLoader(false);
                      await value.updateNavigationButtons();
                    }
                  },
                  onLoadStart: (controller, url) {
                    value.addToHistory(url.toString());
                    providerFalse.setLoader(true);
                  },
                );
              },
            ),
          ),
          if (providerTrue.isLoading)
            const Center(
              child: LinearProgressIndicator(),
            ),
        ],
      ),
      bottomNavigationBar: BottomNaviagation(),
    );
  }
}

TextEditingController txtSearch = TextEditingController();