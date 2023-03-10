import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udemy_social_app/layout/social_layout.dart';
import 'package:udemy_social_app/modules/social_login/social_login_screen.dart';
import 'package:udemy_social_app/network/local/cache_helper.dart';
import 'package:udemy_social_app/shared/components/components.dart';
import 'package:udemy_social_app/shared/components/constants.dart';
import 'package:udemy_social_app/shared/cubit/cubit.dart';
import 'package:udemy_social_app/styles/theme_data/theme_data_light.dart';

import 'bloc_observer.dart';

Future<void> _firebaseMessagingOnBackgroundHandler(
    RemoteMessage message) async {
  print('on background app');
  print(message.data.toString());

  showToast(text: 'on background app', state: ToastStates.success);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();

  await Firebase.initializeApp();

  var token = await FirebaseMessaging.instance.getToken();
  print(token);

  FirebaseMessaging.onMessage.listen((event) {
    print('on message');
    print(event.data.toString());

    showToast(text: 'on message', state: ToastStates.success);
  });

  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    print('on message opened app');
    print(event.data.toString());

    showToast(text: 'on message opened app', state: ToastStates.success);
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingOnBackgroundHandler);

  Widget widget;

  uId = CacheHelper.getData(key: 'uId');

  if (uId != null) {
    widget = const SocialLayout();
  } else {
    widget = LoginScreen();
  }
  runApp(MyApp(startWidget: widget));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.startWidget});

  final Widget startWidget;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => SocialCubit()
            ..getUserData()
            ..getPosts(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: getThemeDataLight(),
        home: startWidget,
      ),
    );
  }
}
