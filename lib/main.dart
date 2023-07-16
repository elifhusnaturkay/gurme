import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gurme/common/widgets/loading_spinner.dart';
import 'package:gurme/features/auth/controller/auth_controller.dart';
import 'package:gurme/firebase_options.dart';
import 'package:gurme/models/user_model.dart';
import 'package:gurme/router.dart';

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
        WidgetsBinding.instance.addPostFrameCallback(
          (_) async {
            if (user != null) {
              getUserData(user);
            } else {
              await ref
                  .read(authControllerProvider.notifier)
                  .signInAnonymously();
            }
          },
        );
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Gurme',
          locale: DevicePreview.locale(context),
          builder: (context, myWidget) {
            myWidget = DevicePreview.appBuilder(context, myWidget);
            myWidget = EasyLoading.init()(context, myWidget);
            return myWidget;
          },
          routeInformationParser:
              ref.watch(routerProvider).routeInformationParser,
          routeInformationProvider:
              ref.watch(routerProvider).routeInformationProvider,
          routerDelegate: ref.watch(routerProvider).routerDelegate,
          theme: ThemeData.light(),
        );
      },
      error: (error, stackTrace) {
        return Text(error.toString());
      },
      loading: () {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Container(
            color: Theme.of(context).canvasColor,
            child: const Center(
              child: LoadingSpinner(width: 75, height: 75),
            ),
          ),
        );
      },
    );
  }
}
