import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart'; // Get 패키지 추가
import 'package:pinned/pages/main/selectPage.dart';
import 'package:logger/logger.dart';

final supportedLocales = [Locale('en', 'US'), Locale('ko', 'KR')];
Logger logger = Logger();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  logger.i('start check');
  runApp(
    EasyLocalization(
        supportedLocales: const [
          Locale('ko', 'KR'),
          Locale('en', 'US'),
        ],
        path: 'assets/translations',
        fallbackLocale: Locale('en', 'US'),
        startLocale: Locale('en', 'US'),
        child: MainApp()),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // 페이지 라우팅 설정
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const SelectPage()), // 첫 번째 화면
        // 추가적인 페이지들 설정 가능
      ],
      translations: null,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
    );
  }
}
