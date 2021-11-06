import 'dart:developer';

import 'package:gdscworkshop/src/provider/config/base_provider.dart';
import 'package:get_it/get_it.dart';

import '../../provider/map_provider.dart';

GetIt locator = GetIt.I;

setupLocator() {
  locator.registerFactory(() => MapProvider());
  locator.registerFactory(() => locator<BaseProvider>());
  log('[Locator : Registered Locators]');
}
