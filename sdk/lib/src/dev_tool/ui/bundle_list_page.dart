import 'dart:async';

import 'package:fair_pushy/src/delegate.dart';
import 'package:fair_pushy/src/dev_tool/ui/shake_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fair_pushy/fair_pushy.dart';
import 'package:sensors_plus/sensors_plus.dart';

class BundleListPage extends StatefulWidget {
  final String? bundleId;

  const BundleListPage({required this.bundleId, super.key});

  @override
  State<BundleListPage> createState() => _BundleListPageState();
}

class _BundleListPageState extends State<BundleListPage> {
  List<String> itemList = [];

  bool _isShow = false;

  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  @override
  void initState() {
    super.initState();
    final isLocalEnv = widget.bundleId == null;
    if (isLocalEnv) {
      _registerSensorListener();
    }
    final pageListFuture = isLocalEnv
        ? Delegate.getLocalEnvPageList()
        : Delegate.getBundlePageList(widget.bundleId!);
    pageListFuture.then((pageList) {
      setState(() {
        itemList.addAll(pageList);
      });
    });
  }

  void _registerSensorListener() {
    _streamSubscriptions
        .add(accelerometerEventStream().listen((AccelerometerEvent event) async {
      int value = 20;
      if (event.x.abs() > value ||
          event.y.abs() > value ||
          event.z.abs() > value) {
        if (!_isShow) {
          _isShow = true;
          if (!mounted) return;
          await showDialog<bool>(
            builder: (BuildContext context) {
              return ShakeDialog(
                onDismiss: () {
                  _isShow = false;
                },
              );
            },
            context: context,
            barrierDismissible: false,
          );
        }
      }
    }));
  }

  @override
  void dispose() {
    super.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('在线预览'),
      ),
      body: Center(
        child: ListView.builder(
            itemCount: itemList.length,
            itemBuilder: (context, index) {
              final item = itemList[index];
              return MaterialButton(
                onPressed: () {
                  Navigator.of(context)
                      .push<void>(MaterialPageRoute(builder: (context) {
                    return FairDevTools.fairWidgetBuilder(getPageName(item), item);
                  }));
                },
                child: SizedBox(
                  height: 50,
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            getPageName(item),
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                                decoration: TextDecoration.none,
                                fontSize: 14,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 0.5,
                            color: Colors.grey,
                          ))
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }

  String getPageName(String path) {
    final split = path.split("/");
    late final String pageSuffix;
    if (path.endsWith(Delegate.Debug_suffix)) {
      pageSuffix = Delegate.Debug_suffix;
    } else if (path.endsWith(Delegate.Release_suffix)) {
      pageSuffix = Delegate.Release_suffix;
    } else {
      return path;
    }
    return split[split.length - 1].replaceAll(pageSuffix, "");
  }

}
class RouteItem {
  final String name;
  final String routePath;

  RouteItem(this.name, this.routePath);
}
