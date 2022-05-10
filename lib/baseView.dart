import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class BaseView<T> extends StatefulWidget {
  final T? viewModel;
  final Widget Function(BuildContext context, T value)? onPageBuilder;
  final Function(T model)? onModelReady;
  final VoidCallback? onDispose;

  const BaseView(
      {Key? key,
      required this.viewModel,
      required this.onPageBuilder,
      required this.onModelReady,
      required this.onDispose})
      : super(key: key);

  @override
  _BaseViewState createState() => _BaseViewState();
}

class _BaseViewState extends State<BaseView> {
  var subscription;
  var internetStatus;
  @override
  void initState() {
    super.initState();
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      setState(() {
        internetStatus = result;
      });
    });
    if (widget.onModelReady != null) widget.onModelReady!(widget.onDispose);
  }

  @override
  Widget build(BuildContext context) {
    return internetStatus == ConnectivityResult.none
        ? Scaffold(
            appBar: AppBar(
              title:const Text("NO INTERNET"),
            ),
          )
        : widget.onPageBuilder!(context, widget.viewModel);
  }

  @override
  void dispose() {
    subscription.dispose();
    if (widget.onDispose != null) {
      widget.onDispose!();
    }

    super.dispose();
  }
}
