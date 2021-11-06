import 'package:gdscworkshop/src/core/di/locator.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../map_provider.dart';
import 'base_provider.dart';

class ProviderConfig {
  static List<SingleChildWidget> providers = [
    ChangeNotifierProvider(create: (context) => locator<BaseProvider>()),
    ChangeNotifierProvider(create: (context) => locator<MapProvider>()),
  ];
}
