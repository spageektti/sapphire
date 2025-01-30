import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sapphire/widgets/info_modal_bottom_sheet.dart';
import 'package:device_info_plus/device_info_plus.dart';

class LinuxBuildIdWidget extends StatefulWidget {
  const LinuxBuildIdWidget({super.key});

  @override
  _LinuxBuildIdWidgetState createState() => _LinuxBuildIdWidgetState();
}

class _LinuxBuildIdWidgetState extends State<LinuxBuildIdWidget> {
  String _buildId = "";

  Future<void> getBuildId() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      LinuxDeviceInfo linuxInfo = await deviceInfo.linuxInfo;
      setState(() {
        _buildId = linuxInfo.buildId ?? context.tr('unknownOrNotLinuxNotice');
      });
    } catch (e) {
      setState(() {
        _buildId = context.tr('unknownOrNotLinuxNotice');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_buildId == "") getBuildId();
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('linuxBuildIdLongName')),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) => InfoModalBottomSheet(
                      name: context.tr('linuxBuildIdLongName'),
                      description: context.tr('linuxBuildIdLongDescription'),
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
            Text(_buildId, style: const TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}
