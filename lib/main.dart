import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gurme/common/constants/asset_constants.dart';
import 'package:gurme/features/auth/controller/auth_controller.dart';
import 'package:gurme/firebase_options.dart';
import 'package:gurme/models/user_model.dart';
import 'package:gurme/router.dart';

final themeProvider = StateProvider<ThemeData>((ref) => ThemeData.light());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    ProviderScope(
      child: DevicePreview(enabled: true, builder: (context) => const MyApp()),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  UserModel? userModel;
  void getUserData(User user) async {
    userModel = await ref
        .watch(authControllerProvider.notifier)
        .getUserData(user.uid)
        .first;

    ref.read(userProvider.notifier).update((state) => userModel);
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(authStateChangeProvider).when(
      data: (user) {
        if (user != null) {
          getUserData(user);
        }
        if (userModel == null) {
          ref.read(authControllerProvider.notifier).signInAnonymously(context);
        }
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Gurme',
          locale: DevicePreview.locale(context),
          builder: DevicePreview.appBuilder,
          routeInformationParser:
              ref.watch(routerProvider).routeInformationParser,
          routeInformationProvider:
              ref.watch(routerProvider).routeInformationProvider,
          routerDelegate: ref.watch(routerProvider).routerDelegate,
          theme: ref.watch(themeProvider),
        );
      },
      error: (error, stackTrace) {
        return Text(error.toString());
      },
      loading: () {
        return MaterialApp(
          home: Container(
            color: Colors.indigo.shade400,
            child: Center(
              child: Image.asset(
                AssetConstants.longLogoWhite,
                width: MediaQuery.of(context).size.width / 1.5,
              ),
            ),
          ),
        );
      },
    );
  }
}
