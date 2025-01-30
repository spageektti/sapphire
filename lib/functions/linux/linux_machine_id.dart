import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sapphire/widgets/info_modal_bottom_sheet.dart';
import 'package:device_info_plus/device_info_plus.dart';

class LinuxMachineIdWidget extends StatefulWidget {
  const LinuxMachineIdWidget({super.key});

  @override
  _LinuxMachineIdWidgetState createState() => _LinuxMachineIdWidgetState();
}

class _LinuxMachineIdWidgetState extends State<LinuxMachineIdWidget> {
  String _machineId = "";

  Future<void> getMachineId() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      LinuxDeviceInfo linuxInfo = await deviceInfo.linuxInfo;
      setState(() {
        _machineId =
            linuxInfo.machineId ?? context.tr('unknownOrNotLinuxNotice');
      });
    } catch (e) {
      setState(() {
        _machineId = context.tr('unknownOrNotLinuxNotice');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_machineId == "") getMachineId();
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('linuxMachineIdLongName')),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) => InfoModalBottomSheet(
                      name: context.tr('linuxMachineIdLongName'),
                      description: context.tr('linuxMachineIdLongDescription'),
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
            Text(_machineId, style: const TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}
