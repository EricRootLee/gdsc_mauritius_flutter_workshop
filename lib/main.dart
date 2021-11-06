import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gdscworkshop/src/core/di/locator.dart';
import 'package:gdscworkshop/src/splash_screen.dart';
import 'package:provider/provider.dart';

import 'src/helpers/common/app_constants.dart';
import 'src/helpers/common/color_palette.dart';
import 'src/provider/config/provider_config.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: AppConstants.envFilePath);
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Palette.primaryAccent,
      statusBarColor: Palette.transaparent,
    ),
  );
  await Firebase.initializeApp();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) async => runApp(GdscFlutterWorkshop()));
}

class GdscFlutterWorkshop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: ProviderConfig.providers,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppConstants.appName,
        theme: ThemeData(
          primaryColor: Palette.primaryColor,
          primarySwatch: Colors.deepOrange,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
