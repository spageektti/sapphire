import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sapphire/widgets/info_modal_bottom_sheet.dart';
import 'package:device_info_plus/device_info_plus.dart';

class LinuxVariantWidget extends StatefulWidget {
  const LinuxVariantWidget({super.key});

  @override
  _LinuxVariantWidgetState createState() => _LinuxVariantWidgetState();
}

class _LinuxVariantWidgetState extends State<LinuxVariantWidget> {
  String _variant = "";

  Future<void> getVariant() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      LinuxDeviceInfo linuxInfo = await deviceInfo.linuxInfo;
      setState(() {
        _variant = linuxInfo.variant ?? context.tr('unknownOrNotLinuxNotice');
      });
    } catch (e) {
      setState(() {
        _variant = context.tr('unknownOrNotLinuxNotice');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_variant == "") getVariant();
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('linuxVariantLongName')),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) => InfoModalBottomSheet(
                      name: context.tr('linuxVariantLongName'),
                      description: context.tr('linuxVariantLongDescription'),
                      author: 'Wiktor Perskawiec (spageektti)',
                      authorUrl: 'https://spageektti.cc'));
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(_variant, style: const TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}
