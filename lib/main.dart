// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_base_app/Cubit/AppCubit.dart';
import 'package:fire_base_app/Cubit/RegisterCubit/RegisterAndLoginCubit.dart';
import 'package:fire_base_app/Cubit/RegisterCubit/RegisterAndLoginSates.dart';
import 'package:fire_base_app/Cubit/cubit/cubits.dart';
import 'package:fire_base_app/Cubit/cubit/states.dart';
import 'package:fire_base_app/modules/login.dart';
import 'package:fire_base_app/shared/components/conestaenc.dart';
import 'package:fire_base_app/shared/network/local/cache-Helper.dart';
import 'package:fire_base_app/shared/styles/ThemeData.dart';
import 'package:fire_base_app/shared/styles/blocObserver.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();

  /* await Firebase.initializeApp();
  var token = FirebaseMessaging.instance.getToken();

  print(token);
  FirebaseMessaging.onMessage.listen((event) {
    print(event.data.toString());
  });
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    print(event.data.toString());
  });*/

  await CacheHelper.init();
  Firebase.initializeApp();
  // CacheHelper.saveData(key: 'uId', value: true);
  // uId = CacheHelper.getData(key: 'uId');
  uId = 'y2HCjFl6sFSW2U6XMSEvchiYVmm2';

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (BuildContext context) => SocialRegisterCubit()),
          BlocProvider(create: (BuildContext context) => SocialAppCubit()),
          BlocProvider(
              create: (BuildContext context) => SocialCubit()
                ..getUserData()
                ..getPosts()),
        ],
        child: BlocConsumer<SocialRegisterCubit, SocialRegisterStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return MaterialApp(
              theme: lightMode,
              home: SocialAppLoginScreen(),
            );
          },
        ));
  }
}
