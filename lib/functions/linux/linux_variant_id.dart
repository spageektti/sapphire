import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sapphire/widgets/info_modal_bottom_sheet.dart';
import 'package:device_info_plus/device_info_plus.dart';

class LinuxVariantIdWidget extends StatefulWidget {
  const LinuxVariantIdWidget({super.key});

  @override
  _LinuxVariantIdWidgetState createState() => _LinuxVariantIdWidgetState();
}

class _LinuxVariantIdWidgetState extends State<LinuxVariantIdWidget> {
  String _variantId = "";

  Future<void> getVariantId() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      LinuxDeviceInfo linuxInfo = await deviceInfo.linuxInfo;
      setState(() {
        _variantId = linuxInfo.id;
      });
    } catch (e) {
      setState(() {
        _variantId = context.tr('unknownOrNotLinuxNotice');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_variantId == "") getVariantId();
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('linuxVariantIdLongName')),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) => InfoModalBottomSheet(
                      name: context.tr('linuxVariantIdLongName'),
                      description: context.tr('linuxVariantIdLongDescription'),
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
            Text(_variantId, style: const TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}
