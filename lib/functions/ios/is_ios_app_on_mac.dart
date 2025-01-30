import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';

class IsIosAppOnMacWidget extends StatefulWidget {
  const IsIosAppOnMacWidget({super.key});

  @override
  _IsIosAppOnMacWidgetState createState() => _IsIosAppOnMacWidgetState();
}

class _IsIosAppOnMacWidgetState extends State<IsIosAppOnMacWidget> {
  bool _isIosAppOnMac = false;

  Future<void> checkIfIosAppOnMac() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      setState(() {
        _isIosAppOnMac = iosInfo.isiOSAppOnMac;
      });
    } catch (e) {
      setState(() {
        _isIosAppOnMac = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    checkIfIosAppOnMac();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('iosisAppOnMacLongName')),
      ),
      body: Center(
        child: _isIosAppOnMac
            ? Text(
                context.tr('yes'),
                style: const TextStyle(fontSize: 24),
              )
            : Text(
                context.tr('no'),
                style: const TextStyle(fontSize: 24),
              ),
      ),
    );
  }
}
