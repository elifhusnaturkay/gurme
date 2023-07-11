import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gurme/common/widgets/loading_spinner.dart';
import 'package:gurme/features/auth/controller/auth_controller.dart';
import 'package:gurme/firebase_options.dart';
import 'package:gurme/models/user_model.dart';
import 'package:gurme/router.dart';

final themeProvider = StateProvider<ThemeData>((ref) => ThemeData.light());
final locationProvider = StateProvider<GeoPoint?>((ref) => null);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (FirebaseAuth.instance.currentUser == null) {
    FirebaseAuth.instance.signInAnonymously();
  }
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
          debugShowCheckedModeBanner: false,
          home: Container(
            color: Colors.transparent,
            child: const Center(
              child: LoadingSpinner(width: 75, height: 75),
            ),
          ),
        );
      },
    );
  }
}
