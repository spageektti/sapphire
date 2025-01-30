/*
 * SPDX-FileCopyrightText: 2024 Wiktor Perskawiec <contact@spageektti.cc>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
/*
* Copyright (C) 2024 Wiktor Perskawiec <contact@spageektti.cc>

? This program is free software: you can redistribute it and/or modify
? it under the terms of the GNU General Public License as published by
? the Free Software Foundation, either version 3 of the License, or
? (at your option) any later version.

! This program is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.

* You should have received a copy of the GNU General Public License
* along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/
/* 
! To contribute, please read the CONTRIBUTING.md file in the root of the project.
? It contains important information about the project structure, code style, suggested VSCode extensions, and more.
*/
import 'package:flutter/material.dart';
import 'package:sapphire/functions/android/version_security_path.dart';
import 'package:sapphire/functions/math/gcd.dart';
import 'package:sapphire/functions/math/lcm.dart';
import 'package:sapphire/functions/math/power.dart';
import 'package:sapphire/functions/math/root.dart' as math_root;
import 'package:sapphire/functions/android/board.dart';
import 'package:sapphire/functions/android/device.dart';
import 'package:sapphire/functions/android/hardware.dart';
import 'package:sapphire/functions/android/is_low_ram_device.dart';
import 'package:sapphire/functions/android/model.dart';
import 'package:sapphire/functions/android/supported_32_bit_abis.dart';
import 'package:sapphire/functions/android/system_features.dart';
import 'package:sapphire/functions/android/version_base_os.dart';
import 'package:sapphire/functions/android/version_preview_sdk_int.dart';
import 'package:sapphire/functions/android/bootloader.dart';
import 'package:sapphire/functions/android/display.dart';
import 'package:sapphire/functions/android/host.dart';
import 'package:sapphire/functions/android/is_physical_device.dart';
import 'package:sapphire/functions/android/product.dart';
import 'package:sapphire/functions/android/supported_64_bit_abis.dart';
import 'package:sapphire/functions/android/tags.dart';
import 'package:sapphire/functions/android/version_codename.dart';
import 'package:sapphire/functions/android/version_release.dart';
import 'package:sapphire/functions/android/brand.dart';
import 'package:sapphire/functions/android/fingerprint.dart';
import 'package:sapphire/functions/android/id.dart';
import 'package:sapphire/functions/android/manufacturer.dart';
import 'package:sapphire/functions/android/serial_number.dart';
import 'package:sapphire/functions/android/supported_abis.dart';
import 'package:sapphire/functions/android/type.dart';
import 'package:sapphire/functions/android/version_incremental.dart';
import 'package:sapphire/functions/android/version_sdk_int.dart';
import 'package:sapphire/functions/ios/identifier_for_vendor.dart';
import 'package:sapphire/functions/ios/is_physical_device.dart' as ios_physical;
import 'package:sapphire/functions/ios/model.dart' as ios_model;
import 'package:sapphire/functions/ios/name.dart';
import 'package:sapphire/functions/ios/system_version.dart';
import 'package:sapphire/functions/ios/utsname_nodename.dart';
import 'package:sapphire/functions/ios/utsname_sysname.dart';
import 'package:sapphire/functions/ios/is_ios_app_on_mac.dart';
import 'package:sapphire/functions/ios/localized_model.dart';
import 'package:sapphire/functions/ios/model_name.dart';
import 'package:sapphire/functions/ios/system_name.dart';
import 'package:sapphire/functions/ios/utsname_machine.dart';
import 'package:sapphire/functions/ios/utsname_release.dart';
import 'package:sapphire/functions/ios/utsname_version.dart';
import 'package:sapphire/functions/linux/linux_build_id.dart';
import 'package:sapphire/functions/linux/linux_id.dart';
import 'package:sapphire/functions/linux/linux_id_like.dart';
import 'package:sapphire/functions/linux/linux_machine_id.dart';
import 'package:sapphire/functions/linux/linux_name.dart';
import 'package:sapphire/functions/linux/linux_pretty_name.dart';
import 'package:sapphire/functions/linux/linux_variant.dart';
import 'package:sapphire/functions/linux/linux_variant_id.dart';
import 'package:sapphire/functions/linux/linux_version_codename.dart';
import 'package:sapphire/functions/linux/linux_version.dart';
import 'package:sapphire/functions/linux/linux_version_id.dart';

class FunctionItem {
  final Widget widget;
  final String name;
  final String author;
  final IconData icon;
  final List<String> tags;
  final int index;

  FunctionItem({
    required this.widget,
    required this.name,
    required this.author,
    required this.icon,
    required this.tags,
    required this.index,
  });
}

List<FunctionItem> functionList = [
  FunctionItem(
    widget: const GcdWidget(),
    name: 'gcd',
    author: 'spageektti',
    icon: Icons.calculate,
    tags: ['math', 'gcd', 'lcm'],
    index: 0,
  ),
  FunctionItem(
      widget: const LcmWidget(),
      name: 'lcm',
      author: 'spageektti',
      icon: Icons.calculate,
      tags: ['math', 'lcm', 'gcd'],
      index: 1),
  FunctionItem(
      widget: const math_root.RootWidget(),
      name: 'root',
      author: 'spageektti',
      icon: Icons.square_foot,
      tags: ['math', 'root', 'power'],
      index: 2),
  FunctionItem(
      widget: const PowerWidget(),
      name: 'power',
      author: 'spageektti',
      icon: Icons.bolt,
      tags: ['math', 'power', 'root'],
      index: 3),
  FunctionItem(
      widget: const VersionSecurityPathWidget(),
      name: 'versionSecurityPath',
      author: 'spageektti',
      icon: Icons.info_outline,
      tags: ['android', 'version', 'security', 'patch'],
      index: 4),
  FunctionItem(
    widget: const BoardWidget(),
    name: 'board',
    author: 'spageektti',
    icon: Icons.memory,
    tags: ['android', 'board'],
    index: 5,
  ),
  FunctionItem(
    widget: const DeviceWidget(),
    name: 'device',
    author: 'spageektti',
    icon: Icons.devices,
    tags: ['android', 'device'],
    index: 6,
  ),
  FunctionItem(
    widget: const HardwareWidget(),
    name: 'hardware',
    author: 'spageektti',
    icon: Icons.hardware,
    tags: ['android', 'hardware'],
    index: 7,
  ),
  FunctionItem(
    widget: const IsLowRamDeviceWidget(),
    name: 'isLowRamDevice',
    author: 'spageektti',
    icon: Icons.memory,
    tags: ['android', 'low_ram'],
    index: 8,
  ),
  FunctionItem(
    widget: const ModelWidget(),
    name: 'model',
    author: 'spageektti',
    icon: Icons.phone_android,
    tags: ['android', 'model'],
    index: 9,
  ),
  FunctionItem(
    widget: const Supported32BitAbisWidget(),
    name: 'supported32BitAbis',
    author: 'spageektti',
    icon: Icons.architecture,
    tags: ['android', '32_bit_abis'],
    index: 10,
  ),
  FunctionItem(
    widget: const SystemFeaturesWidget(),
    name: 'systemFeatures',
    author: 'spageektti',
    icon: Icons.featured_play_list,
    tags: ['android', 'system_features'],
    index: 11,
  ),
  FunctionItem(
    widget: const VersionBaseOsWidget(),
    name: 'versionBaseOs',
    author: 'spageektti',
    icon: Icons.system_update,
    tags: ['android', 'version_base_os'],
    index: 12,
  ),
  FunctionItem(
    widget: const VersionPreviewSdkIntWidget(),
    name: 'versionPreviewSdkInt',
    author: 'spageektti',
    icon: Icons.developer_mode,
    tags: ['android', 'version_preview_sdk_int'],
    index: 13,
  ),
  FunctionItem(
    widget: const BootloaderWidget(),
    name: 'bootloader',
    author: 'spageektti',
    icon: Icons.settings_backup_restore,
    tags: ['android', 'bootloader'],
    index: 14,
  ),
  FunctionItem(
    widget: const DisplayWidget(),
    name: 'display',
    author: 'spageektti',
    icon: Icons.display_settings,
    tags: ['android', 'display'],
    index: 15,
  ),
  FunctionItem(
    widget: const HostWidget(),
    name: 'host',
    author: 'spageektti',
    icon: Icons.router,
    tags: ['android', 'host'],
    index: 16,
  ),
  FunctionItem(
    widget: const IsPhysicalDeviceWidget(),
    name: 'isPhysicalDevice',
    author: 'spageektti',
    icon: Icons.device_hub,
    tags: ['android', 'physical_device'],
    index: 17,
  ),
  FunctionItem(
    widget: const ProductWidget(),
    name: 'product',
    author: 'spageektti',
    icon: Icons.production_quantity_limits,
    tags: ['android', 'product'],
    index: 18,
  ),
  FunctionItem(
    widget: const Supported64BitAbisWidget(),
    name: 'supported64BitAbis',
    author: 'spageektti',
    icon: Icons.architecture,
    tags: ['android', '64_bit_abis'],
    index: 19,
  ),
  FunctionItem(
    widget: const TagsWidget(),
    name: 'tags',
    author: 'spageektti',
    icon: Icons.tag,
    tags: ['android', 'tags'],
    index: 20,
  ),
  FunctionItem(
    widget: const VersionCodenameWidget(),
    name: 'versionCodename',
    author: 'spageektti',
    icon: Icons.code,
    tags: ['android', 'version_codename'],
    index: 21,
  ),
  FunctionItem(
    widget: const VersionReleaseWidget(),
    name: 'versionRelease',
    author: 'spageektti',
    icon: Icons.system_update_alt,
    tags: ['android', 'version_release'],
    index: 22,
  ),
  FunctionItem(
    widget: const BrandWidget(),
    name: 'brand',
    author: 'spageektti',
    icon: Icons.branding_watermark,
    tags: ['android', 'brand'],
    index: 23,
  ),
  FunctionItem(
    widget: const FingerprintWidget(),
    name: 'fingerprint',
    author: 'spageektti',
    icon: Icons.fingerprint,
    tags: ['android', 'fingerprint'],
    index: 24,
  ),
  FunctionItem(
    widget: const IdWidget(),
    name: 'id',
    author: 'spageektti',
    icon: Icons.perm_identity,
    tags: ['android', 'id'],
    index: 25,
  ),
  FunctionItem(
    widget: const ManufacturerWidget(),
    name: 'manufacturer',
    author: 'spageektti',
    icon: Icons.factory,
    tags: ['android', 'manufacturer'],
    index: 26,
  ),
  FunctionItem(
    widget: const SerialNumberWidget(),
    name: 'serialNumber',
    author: 'spageektti',
    icon: Icons.confirmation_number,
    tags: ['android', 'serial_number'],
    index: 27,
  ),
  FunctionItem(
    widget: const SupportedAbisWidget(),
    name: 'supportedAbis',
    author: 'spageektti',
    icon: Icons.architecture,
    tags: ['android', 'supported_abis'],
    index: 28,
  ),
  FunctionItem(
    widget: const TypeWidget(),
    name: 'type',
    author: 'spageektti',
    icon: Icons.category,
    tags: ['android', 'type'],
    index: 29,
  ),
  FunctionItem(
    widget: const VersionIncrementalWidget(),
    name: 'versionIncremental',
    author: 'spageektti',
    icon: Icons.update,
    tags: ['android', 'version_incremental'],
    index: 30,
  ),
  FunctionItem(
    widget: const VersionSdkIntWidget(),
    name: 'versionSdkInt',
    author: 'spageektti',
    icon: Icons.developer_board,
    tags: ['android', 'version_sdk_int'],
    index: 31,
  ),
  FunctionItem(
    widget: const IdentifierForVendorWidget(),
    name: 'identifierForVendor',
    author: 'spageektti',
    icon: Icons.perm_identity,
    tags: ['ios', 'identifier_for_vendor'],
    index: 32,
  ),
  FunctionItem(
    widget: const ios_physical.IsPhysicalDeviceWidget(),
    name: 'iosisPhysicalDevice',
    author: 'spageektti',
    icon: Icons.device_hub,
    tags: ['ios', 'physical_device'],
    index: 33,
  ),
  FunctionItem(
    widget: const ios_model.ModelWidget(),
    name: 'iosmodel',
    author: 'spageektti',
    icon: Icons.phone_android,
    tags: ['ios', 'model'],
    index: 34,
  ),
  FunctionItem(
    widget: const NameWidget(),
    name: 'name',
    author: 'spageektti',
    icon: Icons.text_fields,
    tags: ['ios', 'name'],
    index: 35,
  ),
  FunctionItem(
    widget: const SystemVersionWidget(),
    name: 'systemVersion',
    author: 'spageektti',
    icon: Icons.system_update,
    tags: ['ios', 'system_version'],
    index: 36,
  ),
  FunctionItem(
    widget: const UtsnameNodenameWidget(),
    name: 'utsnameNodename',
    author: 'spageektti',
    icon: Icons.computer,
    tags: ['ios', 'utsname_nodename'],
    index: 37,
  ),
  FunctionItem(
    widget: const UtsnameSysnameWidget(),
    name: 'utsnameSysname',
    author: 'spageektti',
    icon: Icons.system_security_update,
    tags: ['ios', 'utsname_sysname'],
    index: 38,
  ),
  FunctionItem(
    widget: const IsIosAppOnMacWidget(),
    name: 'isIosAppOnMac',
    author: 'spageektti',
    icon: Icons.desktop_mac,
    tags: ['ios', 'is_ios_app_on_mac'],
    index: 39,
  ),
  FunctionItem(
    widget: const LocalizedModelWidget(),
    name: 'localizedModel',
    author: 'spageektti',
    icon: Icons.language,
    tags: ['ios', 'localized_model'],
    index: 40,
  ),
  FunctionItem(
    widget: const ModelNameWidget(),
    name: 'modelName',
    author: 'spageektti',
    icon: Icons.phone_iphone,
    tags: ['ios', 'model_name'],
    index: 41,
  ),
  FunctionItem(
    widget: const SystemNameWidget(),
    name: 'systemName',
    author: 'spageektti',
    icon: Icons.system_update_alt,
    tags: ['ios', 'system_name'],
    index: 42,
  ),
  FunctionItem(
    widget: const UtsnameMachineWidget(),
    name: 'utsnameMachine',
    author: 'spageektti',
    icon: Icons.memory,
    tags: ['ios', 'utsname_machine'],
    index: 43,
  ),
  FunctionItem(
    widget: const UtsnameReleaseWidget(),
    name: 'utsnameRelease',
    author: 'spageektti',
    icon: Icons.update,
    tags: ['ios', 'utsname_release'],
    index: 44,
  ),
  FunctionItem(
    widget: const UtsnameVersionWidget(),
    name: 'utsnameVersion',
    author: 'spageektti',
    icon: Icons.verified,
    tags: ['ios', 'utsname_version'],
    index: 45,
  ),
  FunctionItem(
    widget: const LinuxBuildIdWidget(),
    name: 'linuxBuildId',
    author: 'spageektti',
    icon: Icons.build,
    tags: ['linux', 'build_id'],
    index: 46,
  ),
  FunctionItem(
    widget: const LinuxIdWidget(),
    name: 'linuxId',
    author: 'spageektti',
    icon: Icons.perm_identity,
    tags: ['linux', 'id'],
    index: 47,
  ),
  FunctionItem(
    widget: const LinuxIdLikeWidget(),
    name: 'linuxIdLike',
    author: 'spageektti',
    icon: Icons.perm_identity,
    tags: ['linux', 'id_like'],
    index: 48,
  ),
  FunctionItem(
    widget: const LinuxMachineIdWidget(),
    name: 'linuxMachineId',
    author: 'spageektti',
    icon: Icons.memory,
    tags: ['linux', 'machine_id'],
    index: 49,
  ),
  FunctionItem(
    widget: const LinuxNameWidget(),
    name: 'linuxName',
    author: 'spageektti',
    icon: Icons.text_fields,
    tags: ['linux', 'name'],
    index: 50,
  ),
  FunctionItem(
    widget: const LinuxPrettyNameWidget(),
    name: 'linuxPrettyName',
    author: 'spageektti',
    icon: Icons.text_fields,
    tags: ['linux', 'pretty_name'],
    index: 51,
  ),
  FunctionItem(
    widget: const LinuxVariantWidget(),
    name: 'linuxVariant',
    author: 'spageektti',
    icon: Icons.category,
    tags: ['linux', 'variant'],
    index: 52,
  ),
  FunctionItem(
    widget: const LinuxVariantIdWidget(),
    name: 'linuxVariantId',
    author: 'spageektti',
    icon: Icons.perm_identity,
    tags: ['linux', 'variant_id'],
    index: 53,
  ),
  FunctionItem(
    widget: const LinuxVersionCodenameWidget(),
    name: 'linuxVersionCodename',
    author: 'spageektti',
    icon: Icons.code,
    tags: ['linux', 'version_codename'],
    index: 54,
  ),
  FunctionItem(
    widget: const LinuxVersionWidget(),
    name: 'linuxVersion',
    author: 'spageektti',
    icon: Icons.system_update,
    tags: ['linux', 'version'],
    index: 55,
  ),
  FunctionItem(
    widget: const LinuxVersionIdWidget(),
    name: 'linuxVersionId',
    author: 'spageektti',
    icon: Icons.perm_identity,
    tags: ['linux', 'version_id'],
    index: 56,
  ),
];
