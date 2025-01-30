import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sapphire/widgets/info_modal_bottom_sheet.dart';
import 'package:device_info_plus/device_info_plus.dart';

class LinuxVersionIdWidget extends StatefulWidget {
  const LinuxVersionIdWidget({super.key});

  @override
  _LinuxVersionIdWidgetState createState() => _LinuxVersionIdWidgetState();
}

class _LinuxVersionIdWidgetState extends State<LinuxVersionIdWidget> {
  String _versionId = "";

  Future<void> getVersionId() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      LinuxDeviceInfo linuxInfo = await deviceInfo.linuxInfo;
      setState(() {
        _versionId =
            linuxInfo.versionId ?? context.tr('unknownOrNotLinuxNotice');
      });
    } catch (e) {
      setState(() {
        _versionId = context.tr('unknownOrNotLinuxNotice');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_versionId == "") getVersionId();
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('linuxVersionIdLongName')),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) => InfoModalBottomSheet(
                      name: context.tr('linuxVersionIdLongName'),
                      description: context.tr('linuxVersionIdLongDescription'),
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
            Text(_versionId, style: const TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}
