import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sapphire/widgets/info_modal_bottom_sheet.dart';
import 'package:device_info_plus/device_info_plus.dart';

class LinuxPrettyNameWidget extends StatefulWidget {
  const LinuxPrettyNameWidget({super.key});

  @override
  _LinuxPrettyNameWidgetState createState() => _LinuxPrettyNameWidgetState();
}

class _LinuxPrettyNameWidgetState extends State<LinuxPrettyNameWidget> {
  String _prettyName = "";

  Future<void> getPrettyName() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      LinuxDeviceInfo linuxInfo = await deviceInfo.linuxInfo;
      setState(() {
        _prettyName = linuxInfo.prettyName;
      });
    } catch (e) {
      setState(() {
        _prettyName = context.tr('unknownOrNotLinuxNotice');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_prettyName == "") getPrettyName();
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('linuxPrettyNameLongName')),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) => InfoModalBottomSheet(
                      name: context.tr('linuxPrettyNameLongName'),
                      description: context.tr('linuxPrettyNameLongDescription'),
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
            Text(_prettyName, style: const TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}
