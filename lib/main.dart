import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_template/bloc_observer.dart';
import 'package:project_template/navigation/navigation_cubit.dart';
import 'package:logging/logging.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:project_template/router/my_router.dart';
import 'package:logger/logger.dart' as debug;

const bool kReleaseMode = false;
void main() {
  var prettyLogger;
  if (!kReleaseMode) {
    // Only use this while developing
    prettyLogger = debug.Logger(
      printer: debug
          .PrettyPrinter(), // Use the PrettyPrinter to format and print log
    );
    //
  }
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    final String log =
        '[${record.level.name}] - <${record.loggerName}> -- ${record.time} -- ${record.message}';
    debugPrint(log);
    if (!kReleaseMode) {
      if (record.level == Level.FINE ||
          record.level == Level.FINER ||
          record.level == Level.FINEST) {
        prettyLogger.d(log);
      } else if (record.level == Level.INFO) {
        prettyLogger.i(log);
      } else if (record.level == Level.WARNING) {
        prettyLogger.w(log);
      } else if (record.level == Level.SEVERE) {
        prettyLogger.e(log);
      } else if (record.level == Level.SHOUT) {
        prettyLogger.wtf(log);
      } else {
        prettyLogger.v(log);
      }
    }
  });
  Bloc.observer = GlobalCubitObserver();
  EquatableConfig.stringify = !kReleaseMode;
  runApp(
    DevicePreview(
      // ignore: avoid_redundant_argument_values
      enabled: !kReleaseMode,
      builder: (context) => MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  static final _log = Logger("MyApp");

  final Future<void> setPortrait = SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.value("Load"), //setPortrait,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            _log.severe("Error: ${snapshot.error.toString()}");
            return const Directionality(
                textDirection: TextDirection.ltr, child: Text("Error!"));
          } else if (snapshot.hasData) {
            _log.finest("Init complete");
            return MyAppCore();
          }
          return SplashPage();
        });
  }
}

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const CircularProgressIndicator(),
    );
  }
}

class MyAppCore extends StatelessWidget {
  const MyAppCore({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NavigationCubit(),
        )
      ],
      child: MaterialApp(
        locale: DevicePreview.locale(context), // <--- /!\ Add the locale
        builder: ExtendedNavigator.builder(
            router: MyRouter(),
            initialRoute: Routes.rootPage,
            builder: DevicePreview.appBuilder), // <--- /!\ Add the builder)
        theme: Theme.of(context),
        title: 'Project Template',
      ),
    );
  }
}
