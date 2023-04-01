import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:web_view/core/utils/constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../viewModel/contact&message/contacts_messages_model.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  late WebViewController controller;
  StateProvider<bool> isLoadingProvider = StateProvider<bool>((ref) => true);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        SchedulerBinding.instance.addPostFrameCallback(
          (timeStamp) async {
            ///get contacts & messages
            final contactsListProvider = ref.read(contactsProvider.notifier);
            //await contactsListProvider.getAndSendData(context);
          },
        );
      },
    );
    super.initState();
    // Enable virtual display.
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            ref.read(isLoadingProvider.notifier).state = false;
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(
        Uri.parse(Constants.webViewLink),
      );
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = ref.watch(isLoadingProvider);
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: 1.sw,
          height: 1.sh,
          child: Column(
            children: [
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : WebViewWidget(
                        controller: controller,
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
